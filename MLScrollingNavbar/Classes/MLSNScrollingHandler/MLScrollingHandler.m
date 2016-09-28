//
//  MLSNScrollingHandler.m
//  Pods
//
//  Created by Santiago Lazzari on 9/20/16.
//
//

#import "MLScrollingHandler.h"

@interface MLScrollingHandler ()

// Necessary properties for scrolling handler to work
@property (weak, nonatomic) NSLayoutConstraint *scrollViewTopConstraint;
@property (weak, nonatomic) UIView *navbar;
@property (weak, nonatomic) UIScrollView *scrollView;

// An iteration previous offset (necesary to calculating the delta offeste)
@property (nonatomic) CGFloat previousOffset;

// Limit of how much navbar can scroll
@property (nonatomic) CGFloat scrollingLimit;

// Positive float that indicates how much navbar has moved from the original position (expanded)
@property (nonatomic) CGFloat currentScrolling;

// Different between current scrolling and previous scrolling
@property (nonatomic) CGFloat deltaScrolling;

// Mystery property to control scrolling navbar gesture recognition (not nice)
@property (nonatomic) NSUInteger draggingCount;

// Status bar auxiliar view
@property (strong, nonatomic) UIView *auxView;

@end

@implementation MLScrollingHandler

#pragma mark - Init
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView statusBarBackgroundColor:(UIColor *)color {
    MLScrollingHandler *scrollingHandler = [[MLScrollingHandler alloc] initWithScrollViewTopConstraint:scrollViewTopConstraint navbar:navbar scrollView:scrollView statusBarBackgroundColor:color];
    [scrollView addObserver:scrollingHandler forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:scrollingHandler forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
    
    
    return scrollingHandler;
}

+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView {
    
    return [self scrollingHandlerWithScrollViewTopConstraint:scrollViewTopConstraint navbar:navbar scrollView:scrollView statusBarBackgroundColor:((UINavigationBar *)navbar).barTintColor];
}

- (instancetype)initWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView statusBarBackgroundColor:(UIColor *)color {
    if (self = [[MLScrollingHandler alloc] init]) {
        self.scrollViewTopConstraint = scrollViewTopConstraint;
        self.navbar = navbar;
        self.scrollView = scrollView;
        
        self.currentScrolling = - CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        self.draggingCount = 0;
        
        [self setupNavbarWithAuxViewWithColor:color];
    }
    
    return self;
}

#pragma mark - Setup
- (void)setupNavbarWithAuxViewWithColor:(UIColor *)color {
    CGFloat auxViewX = 0;
    CGFloat auxViewY = - self.navbar.frame.origin.y;
    CGFloat auxViewWidth = CGRectGetWidth(self.navbar.frame);
    CGFloat auxViewHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    self.auxView = [[UIView alloc] initWithFrame:CGRectMake(auxViewX, auxViewY, auxViewWidth, auxViewHeight)];
    self.auxView.backgroundColor = color;
    
    [self.navbar addSubview:self.auxView];
    
    [self.navbar bringSubviewToFront:self.auxView];
}

#pragma mark - Getters
- (CGFloat)scrollingLimit {
    return CGRectGetHeight(self.navbar.frame) + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
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
        
        // FIX: View for alternative solutions
        if (self.draggingCount == 1) {
            self.draggingCount = 0;
        
            [self autoScroll];
        }
    }
}

#pragma mark - ScrollingNavbar
- (void)scrollNavbar {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat contentHeight = self.scrollView.contentSize.height;
    
    if (offsetY < 0)
        return;
    
    if (offsetY > (contentHeight - CGRectGetHeight(self.scrollView.frame)))
        return;

    if ([self isExpanding]) {
        CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        self.currentScrolling -= self.deltaScrolling;
        self.currentScrolling = self.currentScrolling > -statusBarHeight ? self.currentScrolling : - statusBarHeight;
            
        [self expandNavbar];
        [self layoutScrollViewTopConstraint];

        [self layoutAuxView];
        
    }
    
    if ([self isCollapsing]) {
        if (self.scrollingLimit > self.currentScrolling) {
            self.currentScrolling += self.deltaScrolling;
            self.currentScrolling = (self.currentScrolling > self.scrollingLimit) ? self.scrollingLimit : self.currentScrolling;
            
            
            [self collapseNavbar];
            [self layoutScrollViewTopConstraint];
            
            [self layoutAuxView];

        }
    }
    
    self.previousOffset = offsetY;
}

- (void)layoutAuxView {
    CGFloat auxViewX = 0;
    CGFloat auxViewY = - self.navbar.frame.origin.y;
    CGFloat auxViewWidth = CGRectGetWidth(self.navbar.frame);
    CGFloat auxViewHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    self.auxView.frame = CGRectMake(auxViewX, auxViewY, auxViewWidth, auxViewHeight);

}

#pragma mark - Expand
- (BOOL)isExpanding {
    return self.scrollView.contentOffset.y < self.previousOffset;
}

- (void)expandNavbar {
    [self updateCurrentScrollingNavbarFrame];
}

- (void)expandAnimated:(BOOL)animated {
    CGPoint finalPoint = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - (self.currentScrolling + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])));
    
    [self.scrollView setContentOffset:finalPoint animated:animated];
}

#pragma mark - Collapse
- (BOOL)isCollapsing {
    return self.scrollView.contentOffset.y > self.previousOffset;
}

- (void)collapseNavbar {
    [self updateCurrentScrollingNavbarFrame];
}

- (void)collapseAnimated:(BOOL)animated {
    CGPoint finalPoint = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + self.scrollingLimit - self.currentScrolling);
    
    [self.scrollView setContentOffset:finalPoint animated:animated];
}

#pragma mark - Update
- (void)updateCurrentScrollingNavbarFrame {
    CGFloat navbarX = self.navbar.frame.origin.x;
    CGFloat navbarY = - self.currentScrolling;
    CGFloat navbarWidth = CGRectGetWidth(self.navbar.frame);
    CGFloat navbarHeight = CGRectGetHeight(self.navbar.frame);
    
    self.navbar.frame = CGRectMake(navbarX, navbarY, navbarWidth, navbarHeight);
}

- (void)layoutScrollViewTopConstraint {
    CGFloat constantTopConstraint = - (self.currentScrolling + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]));
    
    constantTopConstraint = constantTopConstraint + CGRectGetHeight(self.navbar.frame) > 0 ? constantTopConstraint : - CGRectGetHeight(self.navbar.frame);
    
    self.scrollViewTopConstraint.constant = constantTopConstraint;
}


#pragma mark - Autoscroll
- (BOOL)mightCollapse {
    return self.currentScrolling + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) >= self.scrollingLimit / 2.0;
}

- (BOOL)mightExpand {
    return self.currentScrolling + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) < self.scrollingLimit / 2.0;
}

- (void)autoScroll {
    if ([self mightCollapse]) {
        [self collapseAnimated:YES];
    } else {
        [self expandAnimated:YES];
    }
}

#pragma mark - Memory
- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"pan.state"];
    [self.auxView removeFromSuperview];
}

@end
