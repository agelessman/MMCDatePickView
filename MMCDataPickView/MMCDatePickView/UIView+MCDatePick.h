//
//  UIView+MCDatePick.h
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (MCDP)

+ (UIColor *) mc_colorWithHex:(NSUInteger)hex;

@end


@interface UIView (MCDatePick)

@property (nonatomic, strong, readonly) UIView         *mc_dissmissBackgroundView;
@property (nonatomic, assign, readonly) BOOL           mc_dissmissBackgroundAnimating;
@property (nonatomic, assign          ) NSTimeInterval mc_dissmissAnimationDuration;

- (void) mc_showDissmissBackground;
- (void) mc_hideDissmissBackground;

- (void) mc_distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) mc_distributeSpacingVerticallyWith:(NSArray*)views;




@end
