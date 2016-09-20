//
//  MLSNScrollingHandler.h
//  Pods
//
//  Created by Santiago Lazzari on 9/20/16.
//
//

@import UIKit;

@interface MLSNScrollingHandler : NSObject

+ (instancetype)scrollingHandlerWithScrollViewTopConstraint:(NSLayoutConstraint *)scrollViewTopConstraint navbar:(UIView *)navbar scrollView:(UIScrollView *)scrollView;

@end
