//
//  MLSNScrollingHandler.m
//  Pods
//
//  Created by Santiago Lazzari on 9/20/16.
//
//

#import "MLSNScrollingHandler.h"

@interface MLSNScrollingHandler ()

@property (nonatomic) NSLayoutConstraint *scrollViewTopConstraint;
@property (nonatomic) UIView *navbar;
@property (nonatomic) UIScrollView *scrollView;

// El offset del contentOffset pasado
@property (nonatomic) CGFloat previousOffset;

// El límite de cuánto tiene que scrollear el navbar
@property (nonatomic) CGFloat scrollingLimit;

// Es la propiedad que dice cuando se movió de su estado original
@property (nonatomic) CGFloat currentScrolling;

// La diferencia de scrolling que tuvo
@property (nonatomic) CGFloat deltaScrolling;

@property (nonatomic) NSUInteger draggingCount;

@end

@implementation MLSNScrollingHandler

#pragma mark - Init
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView {
    MLSNScrollingHandler *scrollingHandler = [[MLSNScrollingHandler alloc] init];
    scrollingHandler.scrollViewTopConstraint = scrollViewTopConstraint;
    scrollingHandler.navbar = navbar;
    scrollingHandler.scrollView = scrollView;
    scrollingHandler.currentScrolling = - [[UIApplication sharedApplication] statusBarFrame].size.height;
    scrollingHandler.draggingCount = 0;
    
    [scrollView addObserver:scrollingHandler forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:scrollingHandler forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];

    return scrollingHandler;
}

#pragma mark - Getters
- (CGFloat)scrollingLimit {
    return self.navbar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)deltaScrolling {
    CGFloat delta = self.scrollView.contentOffset.y - self.previousOffset;
    
    return delta > 0 ? delta : -delta;
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollNavbar];
    }
    
    if ([keyPath isEqualToString:@"pan.state"]) {
        self.draggingCount += (self.scrollView.dragging) ? 1 : -1;
        
        if (self.draggingCount == 1) {
            self.draggingCount = 0;
        
            [self autoScroll];
        }
    }
}

#pragma mark - ScrollingNavbar
- (void)scrollNavbar {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    
    if ([self isExpanding]) {
        [self expandNavbar];
        [self expandScrollViewTopConstraint];
    }
    
    if ([self isCollapsing]) {
        [self collapseNavbar];
        [self collapseScrollViewTopConstraint];
    }
    
    self.previousOffset = offsetY;
}

#pragma mark - Expand
- (BOOL)isExpanding {
    return self.scrollView.contentOffset.y < self.previousOffset;
}

- (void)expandNavbar {
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (self.currentScrolling > -statusBarHeight) {
        self.currentScrolling -= self.deltaScrolling;
        
        self.currentScrolling = (self.currentScrolling < -statusBarHeight) ? -statusBarHeight : self.currentScrolling;
        
        [self updateCurrentScrollingNavbarFrame];
    }
}

- (void)expandScrollViewTopConstraint {
    
}

#pragma mark - Collapse
- (BOOL)isCollapsing {
    return self.scrollView.contentOffset.y > self.previousOffset;
}

- (void)collapseNavbar {
    if (self.scrollingLimit > self.currentScrolling) {
        self.currentScrolling += self.deltaScrolling;
     
        self.currentScrolling = (self.currentScrolling > self.scrollingLimit) ? self.scrollingLimit : self.currentScrolling;
        [self updateCurrentScrollingNavbarFrame];
    }
}

- (void)updateCurrentScrollingNavbarFrame {
    CGFloat navbarX = self.navbar.frame.origin.x;
    CGFloat navbarY = - self.currentScrolling;
    CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
    CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
    
    self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
}

- (void)collapseScrollViewTopConstraint {
    
}

#pragma mark - Autoscroll
- (BOOL)mightCollide {
    return self.currentScrolling + [[UIApplication sharedApplication] statusBarFrame].size.height >= self.scrollingLimit / 2.0;
}

- (BOOL)mightExpand {
    return self.currentScrolling + [[UIApplication sharedApplication] statusBarFrame].size.height < self.scrollingLimit / 2.0;
}

- (void)autoScroll {
    if ([self mightCollide]) {
        CGPoint finalPoint = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + self.scrollingLimit - self.currentScrolling);
        
        [self.scrollView setContentOffset:finalPoint animated:YES];
    } else {
        CGPoint finalPoint = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - (self.currentScrolling + [[UIApplication sharedApplication] statusBarFrame].size.height));
        
        [self.scrollView setContentOffset:finalPoint animated:YES];
        
    }
}

#pragma mark - Memory
- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
