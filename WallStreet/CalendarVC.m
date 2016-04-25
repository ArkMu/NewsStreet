//
//  CalendarVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "CalendarVC.h"

#import "AFHTTPSessionManager.h"

#import "MarketModel.h"
#import "MarketViewCell.h"

#import "Common.h"

@interface CalendarVC () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    
    BOOL isToday;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *countryNameDict;

@property (nonatomic, strong) NSMutableArray *marketArr;

@property (nonatomic, strong) NSDictionary *countryDict;

@end

@implementation CalendarVC

static NSString *cellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [self createRandomEvents];
    
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_menuView];
    [_calendarManager setContentView:_contentView];
    [_calendarManager setDate:_todayDate];
    
    _calendarManager.settings.weekModeEnabled = YES;
    [_calendarManager reload];
    
    [self loadData];
    
}

- (NSDictionary *)countryDict {
    if (_countryDict) {
        return _countryDict;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryname" ofType:@"plist"];
    _countryDict = [NSDictionary dictionaryWithContentsOfFile:path];
    return _countryDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (!isToday) {
        _dateSelected = _todayDate;
        isToday = YES;
    }
    
    NSString *str = [formatter stringFromDate:_dateSelected];
    NSString *subStr = [str substringToIndex:10];
    NSString *selecredStr = [subStr stringByAppendingString:@" 00:00:00"];
    
    NSDate *selectedDay = [formatter dateFromString:selecredStr];
    NSInteger endInterval = (NSInteger)[selectedDay timeIntervalSince1970];
    NSInteger startInterval = endInterval - 3600 * 24;
    
    NSDate *date = [NSDate date];
    NSInteger currentInterval = (NSInteger)[date timeIntervalSince1970];
    
    NSDictionary *parameter = @{@"start":@(startInterval),
                                @"end":@(endInterval),
                                @"_eva_t":@(currentInterval)};
    
    _marketArr = [NSMutableArray array];
    [manager GET:@"http://api.markets.wallstreetcn.com/v1/calendar.json?category=&importance=" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        
        NSArray *resultArr = resultDict[@"results"];
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MarketModel *model = [MarketModel modelWithDictionary:(NSDictionary *)obj];
            [_marketArr addObject:model];
        }];
        
        [self loadTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _marketArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.markModel = _marketArr[indexPath.row];
    cell.countryName = self.countryDict;
    return cell;
}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 184) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 100.f;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MarketViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        
        [self loadData];
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        
        [self loadData];
        
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_contentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    _dateSelected = dayView.date;
    
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    if (![_calendarManager.dateHelper date:_contentView.date isTheSameMonthThan:dayView.date]) {
        if ([_contentView.date compare:dayView.date] == NSOrderedAscending) {
            [_contentView loadNextPageWithAnimation];
        }
        else {
            [_contentView loadPreviousPageWithAnimation];
        }
    }
}


#pragma mark - CalendarManager delegate - Page management

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {

}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {

}

#pragma mark - Fake Data

- (void)createMinAndMaxDate {
    _todayDate = [NSDate date];
    
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}


- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date {
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if (_eventsByDate[key] && [_eventsByDate[key] count] > 0) {
        return YES;
    }
    
    return NO;
}

- (void)createRandomEvents {
    _eventsByDate = [NSMutableDictionary new];
    
    for (int i = 0; i < 30; i++) {
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if (!_eventsByDate[key]) {
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}


@end
