//
//  CalendarVC.h
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"

@interface CalendarVC : UIViewController <JTCalendarDelegate>

@property (nonatomic, assign) NSInteger index;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *contentView;

@property (nonatomic, strong) JTCalendarManager *calendarManager;

@end
