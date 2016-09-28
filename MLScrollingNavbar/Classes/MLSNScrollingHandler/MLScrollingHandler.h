//
//  MLSNScrollingHandler.h
//  Pods
//
//  Created by Santiago Lazzari on 9/20/16.
//
//

@import UIKit;


@interface MLScrollingHandler : NSObject

/**
 *  Static initialiser that returns an instance of MLScrollingHandler.
 *
 *  @parms  scrollViewTopConstraint: Top constraint of the UIScrollView witch scroll the navbar.
 *          navbar: UINavigationBar from UINavigationController.
 *          scrollView: UIScrollView that will lead to scrolling the navbar.
 *          color: UIColor that will like to put in the space of the status bar.
 */
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView statusBarBackgroundColor:(UIColor *)color;

/**
 *  Static initialiser that returns an instance of MLScrollingHandler. This initialiser will take the color from the navigation bar.
 *
 *  @parms  scrollViewTopConstraint: Top constraint of the UIScrollView witch scroll the navbar.
 *          navbar: UINavigationBar from UINavigationController.
 *          scrollView: UIScrollView that will lead to scrolling the navbar.
 */
+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView;

/**
 *  Expands the navigation bar
 *
 *  @parms  animated: BOOL that make the transition of expanded animated
 */
- (void)expandAnimated:(BOOL)animated;

/**
 *  Collapses the navigation bar
 *
 *  @parms  animated: BOOL that make the transition of expanded animated
 */- (void)collapseAnimated:(BOOL)animated;

@end
