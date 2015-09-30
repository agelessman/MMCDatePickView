//
//  MCDatePickWindow.m
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import "MCDatePickWindow.h"
#import "UIView+MCDatePick.h"
#import "MMCDatePickView.h"


@interface MCDatePickWindow ()
@property (nonatomic, assign) CGRect keyboardRect;
@end
@implementation MCDatePickWindow


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self addGestureRecognizer:gesture];
        
       
    }
    return self;
}

+ (MCDatePickWindow *)sharedWindow
{
    static MCDatePickWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        window = [[MCDatePickWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    });
    
    return window;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
    
    self.hidden = YES;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWildToHide && !self.mc_dissmissBackgroundAnimating )
    {
        for ( UIView *v in self.mc_dissmissBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[MMCDatePickView class]] )
            {
                MMCDatePickView *popupView = (MMCDatePickView*)v;
                [popupView dismiss];
            }
        }
    }
}

- (void)notifyKeyboardChangeFrame:(NSNotification *)n
{
    NSValue *keyboardBoundsValue = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.keyboardRect = [keyboardBoundsValue CGRectValue];
}


@end
