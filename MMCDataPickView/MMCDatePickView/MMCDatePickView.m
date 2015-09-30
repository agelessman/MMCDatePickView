//
//  MMCDatePickView.m
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#import "MMCDatePickView.h"
#import "MCDatePickDefine.h"
#import "MCDatePickWindow.h"
#import "UIView+MCDatePick.h"

#define currentMonth [_currentMonthString integerValue]

@interface MMCDatePickView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak)UIView *toolBar;
@property (nonatomic,weak)UIPickerView *datePickView;


@property (nonatomic,strong)NSMutableArray *yearArray;
@property (nonatomic,strong)NSArray *monthArray;
@property (nonatomic,strong)NSArray *monthArrayWithout0;
@property (nonatomic,strong)NSMutableArray *DaysArrayWithRi;
@property (nonatomic,strong)NSMutableArray *DaysArray;
@property (nonatomic,strong)NSArray *amPmArray;
@property (nonatomic,strong)NSArray *hoursArray;
@property (nonatomic,strong)NSArray *hoursArrayWithDian;
@property (nonatomic,strong)NSMutableArray *minutesArray;
@property (nonatomic,strong)NSMutableArray *yearAndMonthArray;

@property (nonatomic,assign)int selectedYearRow;
@property (nonatomic,assign)int selectedMonthRow;
@property (nonatomic,assign)int selectedDayRow;
@property (nonatomic,assign)int selectedHourRow;
@property (nonatomic,assign)int selectedMinuteRow;


//当前的选中的字符串
@property (nonatomic,copy)NSString *currentYearString;
@property (nonatomic,copy)NSString *currentMonthString;
@property (nonatomic,copy)NSString *currentDayString;
@property (nonatomic,copy)NSString *currentHourString;
@property (nonatomic,copy)NSString *currentMinuteString;
@property (nonatomic,assign,getter=isFirstTimeLoad)BOOL firstTimeLoad;



@property (nonatomic,assign)MCDatePickType type;

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *yesBtn;

@end
@implementation MMCDatePickView

#pragma mark lazy
- (NSMutableArray *)yearArray
{
    if (_yearArray == nil) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame Type:(MCDatePickType)type Year:(NSString *)year Month:(NSString *)month Day:(NSString *)day Hour:(NSString *)hour Minute:(NSString *)minute
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = type;
        self.currentYearString = year;
        self.currentMonthString = month;
        self.currentDayString = day;
        self.currentHourString = hour;
        self.currentMinuteString = minute;
        
        self.animationDuration = 0.3f;
        self.showAnimation = [self sheetShowAnimation];
        self.hideAnimation = [self sheetHideAnimation];
        self.touchWildToHide = YES;
        
        [self initToolBar];
        [self initDatePickView];
       
      
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark init toolbar
- (void)initToolBar
{
    //创建头部控件
    UIView *tool = [[UIView alloc] init];
    tool .frame = CGRectMake(0, 0, self.frame.size.width, 44);
    tool.tintColor = [UIColor orangeColor];
    
    tool.backgroundColor = [UIColor whiteColor];
//    [tool setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
//    [tool setShadowImage:[UIImage new]
//              forToolbarPosition:UIToolbarPositionAny];
    [self addSubview:tool];
    self.toolBar = tool;
    
   
    

    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(toolbarCancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
    cancelBtn.frame = CGRectMake(10, 0, 60, 44);
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [tool addSubview:cancelBtn];
    
    self.cancelBtn = cancelBtn;

    
    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"选择日期" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    titleBtn.enabled = NO;
    titleBtn.titleLabel.font  = [UIFont systemFontOfSize:14.0];
    titleBtn.frame = CGRectMake(0, 0, 90, 44);
    CGPoint centerP = titleBtn.center;
    centerP.x = tool.center.x;
    titleBtn.center = centerP;
    [tool addSubview:titleBtn];
   
    
    UIButton *yesBtn = [[UIButton alloc] init];
    [yesBtn setTitle:@"选择" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [yesBtn addTarget:self action:@selector(toolbarYesAction) forControlEvents:UIControlEventTouchUpInside];
    yesBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
    yesBtn.frame = CGRectMake(tool.frame.size.width-10-60, 0, 60, 44);
    yesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [tool addSubview:yesBtn];
    
    self.yesBtn = yesBtn;
    
    
}
- (void)initDatePickView
{
    
    //初始化选择器
    UIPickerView *pick = [[UIPickerView alloc] init];
    pick.delegate = self;
    pick.backgroundColor = [UIColor whiteColor];
    
    pick.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), self.frame.size.width, 180);
    [self addSubview:pick];
    self.datePickView = pick;
    
    _firstTimeLoad = YES;
    
    
    // PickerView -  Years data
    
    
    for (int i = 1970; i <= 2030 ; i++)
    {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    self.monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    
    self.monthArrayWithout0  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.yearAndMonthArray = [NSMutableArray array];
    for (NSString *year in self.yearArray) {
        for (NSString *month in self.monthArray) {
            NSString *yearAndmonth = [NSString stringWithFormat:@"%@年%@月",year,month];
            [self.yearAndMonthArray addObject:yearAndmonth];
        }
    }
    
    // PickerView -  Hours data
    
    
    self.hoursArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    self.hoursArrayWithDian = @[@"00点",@"01点",@"02点",@"03点",@"04点",@"05点",@"06",@"07点",@"08点",@"09点",@"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点",@"18点",@"19点",@"20点",@"21点",@"22点",@"23点"];
    // PickerView -  Hours data
    
    self.minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [self.minutesArray addObject:[NSString stringWithFormat:@"%02d分",i]];
        
    }
    
    // PickerView -  AM PM data
    
    //        amPmArray = @[@"AM",@"PM"];
    
    // PickerView -  days data
    
    self.DaysArray = [[NSMutableArray alloc]init];
    self.DaysArrayWithRi = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 31; i++)
    {
        [self.DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
        [self.DaysArrayWithRi addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
    
    
    
    // 设置年和月
    NSString *MonthAndYear = [NSString stringWithFormat:@"%@年%@月",self.currentYearString,self.currentMonthString];
    
    if (self.type == MCDatePickTypeOnlyYear) {
        [self.yearArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *year = obj;
            if ([year isEqualToString:self.currentYearString]) {
                [self.datePickView selectRow:idx inComponent:0 animated:YES];
                
                *stop = YES;
            }
        }];
    }else{
        __block int seleYearRow;
        [self.yearAndMonthArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *objStr = obj;
            if ([objStr isEqualToString:MonthAndYear]) {
                seleYearRow =  (int)idx;
                [self.datePickView selectRow:idx inComponent:0 animated:YES];
                
                *stop = YES;
                
            }
        }];

        self.selectedMonthRow = (int)seleYearRow;
    }
    
    
    
    self.selectedDayRow = (int)[self.DaysArray indexOfObject:self.currentDayString];
    self.selectedHourRow = (int)[self.hoursArray indexOfObject:self.currentHourString];
    self.selectedMinuteRow = (int)[self.minutesArray indexOfObject:[NSString stringWithFormat:@"%@分",self.currentMinuteString]];
    
    if (self.type != MCDatePickTypeOnlyYear && self.type != MCDatePickTypeYearAndMonth) {
         [self.datePickView selectRow:self.selectedDayRow inComponent:1 animated:YES];
    }
   
    
    //选中小时
    if (self.type == MCDatePickTypeYearAndMonthAndDayAndHour || self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute) {
        [self.datePickView selectRow:self.selectedHourRow inComponent:2 animated:YES];
    }
    
    //选中分
    if (self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute) {
        [self.datePickView selectRow:self.selectedMinuteRow inComponent:3 animated:YES];
    }
    
    
    
    
}

#pragma mark setter

- (void)setCancelColor:(UIColor *)cancelColor
{
    _cancelColor = cancelColor;
    
    [self.cancelBtn setTitleColor:cancelColor forState:UIControlStateNormal];
}

- (void)setYesColor:(UIColor *)yesColor
{
    _yesColor = yesColor;
    [self.yesBtn setTitleColor:yesColor forState:UIControlStateNormal];
}

- (void)setToolbarTintColor:(UIColor *)toolbarTintColor
{
    _toolbarTintColor = toolbarTintColor;
    
    self.toolBar.tintColor = toolbarTintColor;
}
- (void)setShowType:(ShowType)showType
{
    _showType = showType;
    
    switch (showType) {
        case ShowTypeSheet:
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        case ShowTypeAlert:
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        default:
            break;
    }
}
- (void)setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor
{
    _toolbarBackgroundColor = toolbarBackgroundColor;
    
    self.toolBar.backgroundColor = toolbarBackgroundColor;
}

#pragma mark action
- (void)toolbarCancelAction
{
    [self dismiss];
}
- (void)toolbarYesAction
{
    
    NSArray *array;
    if (self.type == MCDatePickTypeOnlyYear) {
        
        NSString *year = [self.yearArray objectAtIndex:[self.datePickView selectedRowInComponent:0]];
        array = @[year,@"",@"",@"",@""];
        
    }else {
        
        NSString *yearAndMonth = @"";
        NSString *month = @"";
        NSString *year = @"";
        NSString *day = @"";
        NSString *hour = @"";
        NSString *minute = @"";
        @try {
              yearAndMonth = [self.yearAndMonthArray objectAtIndex:[self.datePickView selectedRowInComponent:0]];
              month = [yearAndMonth substringWithRange:NSMakeRange(5, 2)];
              year = [yearAndMonth substringWithRange:NSMakeRange(0, 4)];
            
        }
        @catch (NSException *exception) {
            year = @"";
            month = @"";
        }
   
        if (self.type == MCDatePickTypeYearAndMonthAndDay || self.type == MCDatePickTypeYearAndMonthAndDayAndHour || self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute) {
            
            @try {
                day = [self.DaysArray objectAtIndex:[self.datePickView selectedRowInComponent:1]];
            }
            @catch (NSException *exception) {
                day = @"";
            }
            
        }
        
        if ( self.type == MCDatePickTypeYearAndMonthAndDayAndHour || self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute) {
            
            @try {
                hour = [self.hoursArray objectAtIndex:[self.datePickView selectedRowInComponent:2]];
            }
            @catch (NSException *exception) {
                hour = @"";
            }
            
        }
        
        if (  self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute) {
            
            @try {
                NSString *minu = [self.minutesArray objectAtIndex:[self.datePickView selectedRowInComponent:3]];
                minute = [minu substringToIndex:2];
            }
            @catch (NSException *exception) {
                minute = @"";
            }
            
        }
       
        array = @[year,month,day,hour,minute];
    
    }
    
    _dateArray = array;
    
    [self dismiss];

    self.yesActionBlock(self,_dateArray);

    
    
}


#pragma mark private
- (void)show
{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(MCDatePickBlock)block
{
    if ( block )
    {
        self.showCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MCDatePickWindow sharedWindow];
    }
    [self.attachedView mc_showDissmissBackground];
    
    

    
    if (self.touchWildToHide) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.attachedView.mc_dissmissBackgroundView addGestureRecognizer:gesture];
    }
    
   
    
    self.showAnimation(self);
    
   
}
- (void)dismiss
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(MCDatePickBlock)block
{
    if ( block )
    {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MCDatePickWindow sharedWindow];
    }
    [self.attachedView mc_hideDissmissBackground];
    if (self.touchWildToHide) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.attachedView.mc_dissmissBackgroundView addGestureRecognizer:gesture];
    }

    self.hideAnimation(self);
}

- (MCDatePickBlock)sheetShowAnimation
{
    MCWeakify(self);
    MCDatePickBlock block = ^(MMCDatePickView *datePick){
        MCStrongify(self);
        
        [self.attachedView.mc_dissmissBackgroundView addSubview:self];
 
//        if (!self.showBackgroundCover) {
//            CGRect tempFrame = self.frame;
//            tempFrame.origin.y = self.attachedView.frame.size.height - self.frame.size.height;
//            self.attachedView.mc_dissmissBackgroundView.frame = tempFrame;
//            self.attachedView.mc_dissmissBackgroundView.backgroundColor = [UIColor orangeColor];
//        }
        
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = self.attachedView.frame.size.height;
        self.frame = tempFrame;
        
        CGPoint tempCenter = self.center;
        tempCenter.x = self.attachedView.center.x;
        self.center = tempCenter;
       

        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
       
                             CGRect tempFrame = self.frame;
                             tempFrame.origin.y = self.attachedView.frame.size.height- tempFrame.size.height;
                             self.frame = tempFrame;
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCDatePickBlock)sheetHideAnimation
{
    MCWeakify(self);
    MCDatePickBlock block = ^(MMCDatePickView *datePick){
        MCStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGRect tempFrame = self.frame;
                             tempFrame.origin.y = self.attachedView.frame.size.height;
                             self.frame = tempFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCDatePickBlock)alertShowAnimation
{
    MCWeakify(self);
    MCDatePickBlock block = ^(MMCDatePickView *datePick){
        MCStrongify(self);
        
        [self.attachedView.mc_dissmissBackgroundView addSubview:self];
        
        
        CGPoint tempCenter = self.center;
        tempCenter.x = self.attachedView.center.x;
        tempCenter.y = self.attachedView.center.y;
        self.center = tempCenter;
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCDatePickBlock)alertHideAnimation
{
    MCWeakify(self);
    MCDatePickBlock block = ^(MMCDatePickView *datePick){
        MCStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}


#pragma mark pickView delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    

    _firstTimeLoad = NO;
    if (component == 0)
    {
        _selectedMonthRow = (int)row;
        [self.datePickView reloadAllComponents];
    }
    else if (component == 1)
    {
        _selectedDayRow = (int)row;
        [self.datePickView reloadAllComponents];
    }
    else if (component == 2)
    {
        _selectedHourRow = (int)row;
        
        [self.datePickView reloadAllComponents];
        
    }else{
        _selectedMinuteRow = (int)row;
        
        [self.datePickView reloadAllComponents];
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 40);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        if (self.type == MCDatePickTypeOnlyYear) {
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        }else{
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    if (component == 0)
    {
        if (self.type == MCDatePickTypeOnlyYear) {
            pickerLabel.text =  [_yearArray objectAtIndex:row];
        }else{
            pickerLabel.text =  [_yearAndMonthArray objectAtIndex:row]; // Year
        }
        
        pickerLabel. frame = CGRectMake(0.0, 0.0, 120, 40);
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        pickerLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    }
    else if (component == 1)
    {
        pickerLabel.text =  [_DaysArrayWithRi objectAtIndex:row]; // Date
        pickerLabel.  frame = CGRectMake(0.0, 0.0, 70, 40);
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        pickerLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        
    }else if (component == 2)
    {
        pickerLabel.text =  [_hoursArrayWithDian objectAtIndex:row]; // Date
        pickerLabel.  frame = CGRectMake(0.0, 0.0, 70, 40);
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        pickerLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        
    }else{
        
        pickerLabel.text =  [_minutesArray objectAtIndex:row]; // Date
        pickerLabel.  frame = CGRectMake(0.0, 0.0, 70, 40);
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        pickerLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    }
    return pickerLabel;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    if (self.type == MCDatePickTypeOnlyYear) {
        return 1;
    }else if (self.type == MCDatePickTypeYearAndMonth){
        return 1;
    }else if (self.type == MCDatePickTypeYearAndMonthAndDay){
        return 2;
    }else if (self.type == MCDatePickTypeYearAndMonthAndDayAndHour){
        return 3;
    }else if (self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute){
        return 4;
    }
    else{
        return  0;
    }
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat w4 = self.frame.size.width/4;
    CGFloat w5 = self.frame.size.width/5;
    if (self.type == MCDatePickTypeOnlyYear) {
        return self.frame.size.width;
    }else if (self.type == MCDatePickTypeYearAndMonth)
    {
        return self.frame.size.width*0.5;
    }else if (self.type == MCDatePickTypeYearAndMonthAndDay){
        return self.frame.size.width*0.5;
    }else if (self.type == MCDatePickTypeYearAndMonthAndDayAndHour){
        if (component == 0) {
            return w4 * 2;
        }else{
            return w4;
        }
    }else if (self.type == MCDatePickTypeYearAndMonthAndDayAndHourAndMinute){
        if (component == 0) {
            return w5 * 2;
        }else{
            return w5;
        }
    }
    return 0;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        if (self.type == MCDatePickTypeOnlyYear) {
            return _yearArray.count;
        }else{
            return [_yearAndMonthArray count];
        }
        
    }
    else if (component == 1)
    { // day
        
        if (_firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[_yearArray objectAtIndex:_selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {//选择的月,这里用的是年和月组合模式，一次要%12
            
            if (_selectedMonthRow%12 == 0 || _selectedMonthRow%12 == 2 || _selectedMonthRow%12 == 4 || _selectedMonthRow%12 == 6 || _selectedMonthRow%12 == 7 || _selectedMonthRow%12 == 9 || _selectedMonthRow%12 == 11)
            {
                return 31;
            }
            else if (_selectedMonthRow%12 == 1)
            {
                int yearint = [[_yearArray objectAtIndex:_selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        
        
    }
    else if (component == 2) {
        return [_hoursArray count];
    }else{
        
        return [_minutesArray count];
    }
    
    
    
}

@end
