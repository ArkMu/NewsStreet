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

@interface CalendarVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *countryNameDict;

@property (nonatomic, strong) NSMutableArray *marketArr;

@property (nonatomic, strong) NSDictionary *countryDict;

@end

@implementation CalendarVC

static NSString *cellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    _marketArr = [NSMutableArray array];
    [manager GET:@"http://api.markets.wallstreetcn.com/v1/calendar.json?start=1461081600&end=1461168000&category=&importance=&_eva_t=1461115611" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        
        NSArray *resultArr = resultDict[@"results"];
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MarketModel *model = [MarketModel modelWithDictionary:(NSDictionary *)obj];
            [_marketArr addObject:model];
        }];
        
        [self loadTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 120) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 100.f;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MarketViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
}




@end
