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
@property (nonatomic) CGFloat navbarHeight;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) CGFloat previousOffset;

@end

@implementation MLSNScrollingHandler

#pragma mark - Init
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView {
    MLSNScrollingHandler *scrollingHandler = [[MLSNScrollingHandler alloc] init];
    scrollingHandler.scrollViewTopConstraint = scrollViewTopConstraint;
    scrollingHandler.navbar = navbar;
    scrollingHandler.navbarHeight = navbar.frame.size.height;
    scrollingHandler.scrollView = scrollView;
    
    [scrollView addObserver:scrollingHandler forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return scrollingHandler;
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollNavbar];
    }
}

- (void)scrollNavbar {
    CGFloat insetY = self.scrollView.contentOffset.y;
    
    
    NSLog(@"%f", insetY);
    
    
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
