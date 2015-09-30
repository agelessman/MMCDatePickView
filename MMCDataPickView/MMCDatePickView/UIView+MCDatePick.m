//
//  UIView+MCDatePick.m
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import "UIView+MCDatePick.h"
#import "MCDatePickDefine.h"
#import <objc/runtime.h>


@implementation UIColor (MCDP)

+ (UIColor *) mc_colorWithHex:(NSUInteger)hex {
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end


static const void *mc_dissmissReferenceCountKey      = &mc_dissmissReferenceCountKey;

static const void *mc_dissmissBackgroundViewKey      = &mc_dissmissBackgroundViewKey;
static const void *mc_dissmissAnimationDurationKey   = &mc_dissmissAnimationDurationKey;
static const void *mc_dissmissBackgroundAnimatingKey = &mc_dissmissBackgroundAnimatingKey;


@interface UIView (MCPick)

@property (nonatomic, assign, readwrite) NSInteger mc_dissmissReferenceCount;

@end

@implementation UIView (MCPick)

@dynamic mc_dissmissReferenceCount;


- (NSInteger)mc_dissmissReferenceCount {
    return [objc_getAssociatedObject(self, mc_dissmissReferenceCountKey) integerValue];
}

- (void)setMc_dissmissReferenceCount:(NSInteger)mc_dissmissReferenceCount
{
    objc_setAssociatedObject(self, mc_dissmissReferenceCountKey, @(mc_dissmissReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@implementation UIView (MCDatePick)

@dynamic mc_dissmissBackgroundView;
@dynamic mc_dissmissAnimationDuration;
@dynamic mc_dissmissBackgroundAnimating;


- (UIView *)mc_dissmissBackgroundView
{
    UIView *dimView = objc_getAssociatedObject(self, mc_dissmissBackgroundViewKey);
    
    if ( !dimView )
    {
        dimView = [UIView new];
        [self addSubview:dimView];
        dimView.frame = self.frame;
        dimView.hidden = YES;
        
        self.mc_dissmissAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, mc_dissmissBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dimView;
}

- (BOOL)mc_dissmissBackgroundAnimating
{
    return [objc_getAssociatedObject(self, mc_dissmissBackgroundViewKey) boolValue];
}

- (void)setMc_dissmissBackgroundAnimating:(BOOL)mc_dissmissBackgroundAnimating
{
    objc_setAssociatedObject(self, mc_dissmissBackgroundAnimatingKey, @(mc_dissmissBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)mc_dissmissAnimationDuration
{
    return [objc_getAssociatedObject(self, mc_dissmissAnimationDurationKey) doubleValue];
}

- (void)setMc_dissmissAnimationDuration:(NSTimeInterval)mc_dissmissAnimationDuration
{
    objc_setAssociatedObject(self, mc_dissmissAnimationDurationKey, @(mc_dissmissAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mc_showDissmissBackground
{
    ++self.mc_dissmissReferenceCount;
    
    if ( self.mc_dissmissReferenceCount > 1 )
    {
        return;
    }
    
    self.mc_dissmissBackgroundView.hidden = NO;
    self.mc_dissmissBackgroundAnimating = YES;
    
    if ( [self isKindOfClass:[UIWindow class]] )
    {
        self.hidden = NO;
        [(UIWindow*)self makeKeyAndVisible];
    }
    else
    {
        [self bringSubviewToFront:self.mc_dissmissBackgroundView];
    }
    
    [UIView animateWithDuration:self.mc_dissmissAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.mc_dissmissBackgroundView.backgroundColor = MCHexColor(0x0000007F);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.mc_dissmissBackgroundAnimating = NO;
                             
                             
                         }
                         
                     }];
}

- (void)mc_hideDissmissBackground
{
    --self.mc_dissmissReferenceCount;
    
    if ( self.mc_dissmissReferenceCount > 0 )
    {
        return;
    }
    
    self.mc_dissmissBackgroundAnimating = YES;
    [UIView animateWithDuration:self.mc_dissmissAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.mc_dissmissBackgroundView.backgroundColor = MCHexColor(0x00000000);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.mc_dissmissBackgroundView.hidden = YES;
                             self.mc_dissmissBackgroundAnimating = NO;
                             
                             if ( [self isKindOfClass:[UIWindow class]] )
                             {
                                 self.hidden = YES;
                                 [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                             }
                         }
                     }];
}

- (void) mc_distributeSpacingHorizontallyWith:(NSArray *)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        //设置宽和高相同
        [NSLayoutConstraint
                      constraintWithItem:v
                      attribute:NSLayoutAttributeWidth
                      relatedBy:NSLayoutRelationEqual
                      toItem: v
                      attribute:NSLayoutAttributeHeight
                      multiplier:1.0f
                      constant:0];
    }
    
    UIView *v0 = spaces[0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeLeft
     multiplier:1.0f
     constant:0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeCenterY
     relatedBy:NSLayoutRelationEqual
     toItem: (UIView*)views[0]
     attribute:NSLayoutAttributeCenterY
     multiplier:1.0f
     constant:0];
    

    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [NSLayoutConstraint
         constraintWithItem:obj
         attribute:NSLayoutAttributeLeft
         relatedBy:NSLayoutRelationEqual
         toItem: lastSpace
         attribute:NSLayoutAttributeRight
         multiplier:1.0f
         constant:0];
        
   
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeLeft
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeRight
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeCenterY
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeCenterY
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeWidth
         relatedBy:NSLayoutRelationEqual
         toItem: v0
         attribute:NSLayoutAttributeWidth
         multiplier:1.0f
         constant:0];
        

        
        lastSpace = space;
    }
    
    [NSLayoutConstraint
     constraintWithItem:lastSpace
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeRight
     multiplier:1.0f
     constant:0];
    
  
    
}

- (void) mc_distributeSpacingVerticallyWith:(NSArray *)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [NSLayoutConstraint
         constraintWithItem:v
         attribute:NSLayoutAttributeWidth
         relatedBy:NSLayoutRelationEqual
         toItem: v
         attribute:NSLayoutAttributeHeight
         multiplier:1.0f
         constant:0];
        

    }
    
    UIView *v0 = spaces[0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeTop
     multiplier:1.0f
     constant:0];
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem: (UIView*)views[0]
     attribute:NSLayoutAttributeCenterX
     multiplier:1.0f
     constant:0];
    

    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [NSLayoutConstraint
         constraintWithItem:obj
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationEqual
         toItem: lastSpace
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:0];
        
   
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeCenterX
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeCenterX
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeHeight
         relatedBy:NSLayoutRelationEqual
         toItem: v0
         attribute:NSLayoutAttributeHeight
         multiplier:1.0f
         constant:0];

        
        lastSpace = space;
    }
    
    [NSLayoutConstraint
     constraintWithItem:lastSpace
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeBottom
     multiplier:1.0f
     constant:0];

    
 
    
}
@end
