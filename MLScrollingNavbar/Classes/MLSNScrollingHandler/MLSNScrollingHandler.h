//
//  MLSNScrollingHandler.h
//  Pods
//
//  Created by Santiago Lazzari on 9/20/16.
//
//

@import UIKit;


@interface MLSNScrollingHandler : NSObject

/**
 *  Static initialiser that returns an instance of MLScrollingHandler.
 *
 *  @parms  scrollViewTopConstraint:
 *          navbar:
 *          scrollView:
 *          color:
 */
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView statusBarBackgroundColor:(UIColor *)color;

/**
 *  Static initialiser that returns an instance of MLScrollingHandler.
 *
 *  @parms  scrollViewTopConstraint: Any object that implements MLBooleanWidgetDelegate
 *          navbar:
 *          scrollView:
 */
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView;

/**
 *
 */
- (void)expandAnimated:(BOOL)animated;

/**
 *
 */
- (void)collapseAnimated:(BOOL)animated;

@end

