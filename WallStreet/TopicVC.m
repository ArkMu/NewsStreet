//
//  TopicVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "TopicVC.h"

#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"

#import "ResultModel.h"
#import "InfoCell.h"

#import "DetailVC.h"

#import "PostModel.h"

@interface TopicVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) ResultModel *resultModel;

@end

@implementation TopicVC

static NSString *CellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 100;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoCell class]) bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
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
    
//    NSDictionary *parameter = @{@"page":@(_pageIndex)};
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.wallstreetcn.com/v2/posts/special/%ld?_eva_t=1461239594&page=%ld&limit=10", _index, _pageIndex];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSDictionary *dict = resultDict[@"results"];
        _resultModel = [ResultModel modelWithDictionary:dict];
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultModel.resultMarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.postModel = _resultModel.resultMarr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    PostModel *model = _resultModel.resultMarr[indexPath.row];
    detail.Id = [model.Id integerValue];
    
    [self.navigationController pushViewController:detail animated:NO];
    
}

@end
