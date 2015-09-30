//
//  MCDatePickWindow.h
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDatePickWindow : UIWindow
@property (nonatomic, assign) BOOL touchWildToHide; // default is YES. datePickView will be hidden when user touch the translucent background.

+ (MCDatePickWindow *)sharedWindow;

/**
 *  cache the window to prevent the lag of the first showing.
 */
- (void) cacheWindow;

@end
