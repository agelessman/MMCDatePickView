//
//  ViewController.m
//  MMCDataPickView
//
//  Created by 马超 on 15/9/30.
//  Copyright © 2015年 马超. All rights reserved.
//

#import "ViewController.h"
#import "MMCDatePickView.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)buttonAction:(UIButton *)sender {
    
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    NSString *hour = @"";
    NSString *minute = @"";
    
    MCDatePickType type;
    switch (sender.tag) {
        case 1:
        {
            type = MCDatePickTypeOnlyYear;
            if (self.label0.text.length) {
                year = self.label0.text;
            }
            
        }
            break;
        case 2:
        {
            type = MCDatePickTypeYearAndMonth;
            if (self.label1.text.length) {
                year = [self.label1.text substringWithRange:NSMakeRange(0, 4)];
                month = [self.label1.text substringWithRange:NSMakeRange(5, 2)];
            }
        }
            break;
        case 3:
        {
            type = MCDatePickTypeYearAndMonthAndDay;
            if (self.label2.text.length) {
                year = [self.label2.text substringWithRange:NSMakeRange(0, 4)];
                month = [self.label2.text substringWithRange:NSMakeRange(5, 2)];
                day = [self.label2.text substringWithRange:NSMakeRange(8, 2)];
            }
        }
            break;
        case 4:
        {
            type = MCDatePickTypeYearAndMonthAndDayAndHour;
            if (self.label3.text.length) {
                year = [self.label3.text substringWithRange:NSMakeRange(0, 4)];
                month = [self.label3.text substringWithRange:NSMakeRange(5, 2)];
                day = [self.label3.text substringWithRange:NSMakeRange(8, 2)];
                hour = [self.label3.text substringWithRange:NSMakeRange(11, 2)];
            }
        }
            break;
        case 5:
        {
            type = MCDatePickTypeYearAndMonthAndDayAndHourAndMinute;
            if (self.label4.text.length) {
                year = [self.label4.text substringWithRange:NSMakeRange(0, 4)];
                month = [self.label4.text substringWithRange:NSMakeRange(5, 2)];
                day = [self.label4.text substringWithRange:NSMakeRange(8, 2)];
                hour = [self.label4.text substringWithRange:NSMakeRange(11, 2)];
                minute = [self.label4.text substringWithRange:NSMakeRange(13, 2)];
            }
        }
            break;
        default:
            break;
    }
    
    MMCDatePickView *datePick = [[MMCDatePickView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180+44) Type:type Year:year Month:month Day:day Hour:hour Minute:minute];
    [datePick show];
    
    [datePick setYesActionBlock:^(MMCDatePickView *datePick, NSArray *dateArray) {
        switch (sender.tag) {
            case 1:
            {
                self.label0.text = [NSString stringWithFormat:@"%@",dateArray[0]];
                
            }
                break;
            case 2:
            {
                self.label1.text = [NSString stringWithFormat:@"%@-%@",dateArray[0],dateArray[1]];
            }
                break;
            case 3:
            {
                self.label2.text = [NSString stringWithFormat:@"%@-%@-%@",dateArray[0],dateArray[1],dateArray[2]];
            }
                break;
            case 4:
            {
              self.label3.text = [NSString stringWithFormat:@"%@-%@-%@ %@",dateArray[0],dateArray[1],dateArray[2],dateArray[3]];
            }
                break;
            case 5:
            {
               self.label4.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",dateArray[0],dateArray[1],dateArray[2],dateArray[3],dateArray[4]];
            }
                break;
            default:
                break;
        }
    }];
}

@end
