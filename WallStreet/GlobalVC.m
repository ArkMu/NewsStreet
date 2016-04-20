//
//  GlobalVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "GlobalVC.h"

#import "AguModel.h"
#import "AguCell.h"

#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"

@interface GlobalVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *aguArr;

@end

@implementation GlobalVC

static NSString *aguIdentifier = @"agu";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 100.f;
    _tableView.rowHeight = UITableViewRowAnimationAutomatic;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AguCell class]) bundle:nil] forCellReuseIdentifier:aguIdentifier];
    
    _aguArr = [NSMutableArray array];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 0;
        [self loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self loadData];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger time = (NSInteger)interval;
    NSDictionary *parameter = @{@"page":@(_pageIndex),
                                @"_eva_t":@(time)};
    //    NSString *url = @"";
    //    if (_currentIndex == 0) {
    //        url = @"http://api.wallstreetcn.com/v2/livenews?cid=&type=&importance=&channelId=1";
    //    } else if (_currentIndex == 1) {
    //        url = @"http://api.wallstreetcn.com/v2/livenews?channelId=2";
    //    } else {
    //        url = @"";
    //    }
    
    [manager GET:@"http://api.wallstreetcn.com/v2/livenews?cid=&type=&importance=&channelId=1" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *resultArr = resultDict[@"results"];
        
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AguModel *model = [AguModel modelWithDictionary:(NSDictionary *)obj];
            [_aguArr addObject:model];
        }];
        
        [_tableView reloadData];
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aguArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AguCell *cell = [tableView dequeueReusableCellWithIdentifier:aguIdentifier];
    AguModel *model = _aguArr[indexPath.row];
    cell.aguModel = model;
    return cell;
}

@end
