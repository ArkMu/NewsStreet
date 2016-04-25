//
//  LiveVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AguVC.h"

#import "AguModel.h"
#import "AguCell.h"

#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"

#import "Common.h"

#import "Reachability.h"
#import "SVProgressHUD.h"

@interface AguVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *aguArr;

@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation AguVC

static NSString *aguIdentifier = @"agu";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 120) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 100.f;
    _tableView.rowHeight = UITableViewRowAnimationAutomatic;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AguCell class]) bundle:nil] forCellReuseIdentifier:aguIdentifier];
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 0;
        _aguArr = [NSMutableArray array];
        [_tableView reloadData];
        [self loadData];
    }];
    
    if ([self netCanReach]) {
        [_tableView.mj_header beginRefreshing];
    }
   
}

- (BOOL)netCanReach {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (!([reach currentReachabilityStatus] == ReachableViaWWAN) && !([reach currentReachabilityStatus] == ReachableViaWiFi)) {
        [SVProgressHUD showErrorWithStatus:@"网络不通"];
        return NO;
    } else {
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageIndex++;
            [self loadData];
        }];
        return YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


- (void)loadData {
    if (![self netCanReach]) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        return;
    }
    
    if (_isRefreshing) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger time = (NSInteger)interval;
    NSDictionary *parameter = @{@"page":@(_pageIndex),
                                @"_eva_t":@(time)};
    
    
    [manager GET:@"http://api.wallstreetcn.com/v2/livenews?channelId=2" parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        _isRefreshing = YES;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *resultArr = resultDict[@"results"];
        
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AguModel *model = [AguModel modelWithDictionary:(NSDictionary *)obj];
            [_aguArr addObject:model];
        }];
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        _isRefreshing = NO;
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        _isRefreshing = NO;
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
