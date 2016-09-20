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
@property (nonatomic) CGFloat previousOffset;

@property (nonatomic) CGFloat scrollingLimit;
@property (nonatomic) CGFloat currentScrolling;
@property (nonatomic) CGFloat deltaScrolling;

@end

@implementation MLSNScrollingHandler

#pragma mark - Init
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView {
    MLSNScrollingHandler *scrollingHandler = [[MLSNScrollingHandler alloc] init];
    scrollingHandler.scrollViewTopConstraint = scrollViewTopConstraint;
    scrollingHandler.navbar = navbar;
    scrollingHandler.scrollView = scrollView;
    
    [scrollView addObserver:scrollingHandler forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollNavbar];
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
    if (self.currentScrolling > 0) {
        self.currentScrolling -= self.deltaScrolling;
        
        
        CGFloat navbarX = self.navbar.frame.origin.x;
        CGFloat navbarY = self.navbar.frame.origin.y + self.deltaScrolling;
        CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
        CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
        
        self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
    } else {
        CGFloat statusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
        
        CGFloat navbarX = self.navbar.frame.origin.x;
        CGFloat navbarY = statusBarHeight;
        CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
        CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
        
        self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
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
        
        
        CGFloat navbarX = self.navbar.frame.origin.x;
        CGFloat navbarY = self.navbar.frame.origin.y - self.deltaScrolling;
        CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
        CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
        
        self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
    } else {
        CGFloat navbarX = self.navbar.frame.origin.x;
        CGFloat navbarY = - self.scrollingLimit;
        CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
        CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
        
        self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
    }
}

- (void)collapseScrollViewTopConstraint {
    
}



#pragma mark - Memory
- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
