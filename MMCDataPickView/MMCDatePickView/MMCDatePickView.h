//
//  MMCDatePickView.h
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCDatePickView;
typedef enum : NSUInteger {
    MCDatePickTypeOnlyYear,//only display year
    MCDatePickTypeYearAndMonth,//display year,month
    MCDatePickTypeYearAndMonthAndDay,//display year,month,day
    MCDatePickTypeYearAndMonthAndDayAndHour,//display year,month,day,hour
    MCDatePickTypeYearAndMonthAndDayAndHourAndMinute//display year,month,day,hour,minute
} MCDatePickType;

typedef enum : NSUInteger {
    ShowTypeSheet,
    ShowTypeAlert
} ShowType;

//block
typedef void(^yesActionBlock)(MMCDatePickView *datePick,NSArray *dateArray);
typedef void(^MCDatePickBlock)(MMCDatePickView *);

@interface MMCDatePickView : UIView

@property (nonatomic, strong) UIView         *attachedView;       // default is MMPopupWindow. You can attach MMPopupView to any UIView.


@property (nonatomic,strong,readonly)NSArray *dateArray;//装着的是返回的时间数组例如@[@"2015",@"03",@"23",@"12",@"45"]




//@property (nonatomic, assign) BOOL showBackgroundCover;//default is YES
@property (nonatomic, assign) BOOL touchWildToHide;//default is YES
@property (nonatomic,strong)UIColor *toolbarBackgroundColor;
@property (nonatomic,strong)UIColor *toolbarTintColor;
@property (nonatomic,strong)UIColor *cancelColor;
@property (nonatomic,strong)UIColor *yesColor;
@property (nonatomic, assign) NSTimeInterval animationDuration;   // default is 0.3
@property (nonatomic, assign) ShowType showType;   // default is ShowTypeSheet

@property (nonatomic,copy)yesActionBlock yesActionBlock;




//动画的处理
@property (nonatomic, copy) MCDatePickBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy) MCDatePickBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy) MCDatePickBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy) MCDatePickBlock   hideAnimation;       // custom hide animation block.







- (instancetype)initWithFrame:(CGRect)frame Type:(MCDatePickType)type Year:(NSString *)year Month:(NSString *)month Day:(NSString *)day Hour:(NSString *)hour Minute:(NSString *)minute;

- (void)show;
- (void)dismiss;
//用于回调的方法
- (void)setYesActionBlock:(yesActionBlock)yesActionBlock;


@end
