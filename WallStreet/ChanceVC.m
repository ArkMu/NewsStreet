//
//  ChanceVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChanceVC.h"

#import "AFHTTPSessionManager.h"
#import "GDataXMLNode.h"

#import "Common.h"

#import "MJRefresh.h"

#import "MessModel.h"
#import "ChanceCell.h"

#import "MessageDetailVC.h"

#import "Reachability.h"
#import "SVProgressHUD.h"

@interface ChanceVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *itemMarr;

@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation ChanceVC

static NSString *chancelIdentifier = @"chancel";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 120) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.estimatedRowHeight = 120.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChanceCell class]) bundle:nil] forCellReuseIdentifier:chancelIdentifier];
    
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        _itemMarr = [NSMutableArray array];
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
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
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
    NSString *str = [NSString stringWithFormat:@"http://news.10jqka.com.cn/tzjh_mlist/1_0_0_%ld/", _pageIndex];
    
    [manager GET:str parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
        _isRefreshing = YES;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject options:-1 error:&error];

        
        
        GDataXMLElement *rootElement = [doc rootElement];
        
        NSArray *students = [rootElement elementsForName:@"pageItems"];
        NSArray *items = [students.firstObject elementsForName:@"item"];
        
        for (GDataXMLElement *item in items) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            
            GDataXMLElement *seqElement = [[item elementsForName:@"seq"] objectAtIndex:0];
            NSString *seq = [seqElement stringValue];
            
            GDataXMLElement *titleElement = [[item elementsForName:@"title"] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            
            GDataXMLElement *ctimeElement = [[item elementsForName:@"ctime"] objectAtIndex:0];
            NSString *ctime = [ctimeElement stringValue];
            
            GDataXMLElement *urlElement = [[item elementsForName:@"url"] objectAtIndex:0];
            NSString *url = [urlElement stringValue];
            
            [mDict setValue:seq forKey:@"seq"];
            [mDict setValue:title forKey:@"title"];
            [mDict setValue:ctime forKey:@"ctime"];
            [mDict setValue:url forKey:@"url"];
            
            
            MessModel *model = [MessModel modelWithDictionary:mDict];
            [_itemMarr addObject:model];
        }
        
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
    return _itemMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanceCell *cell = [tableView dequeueReusableCellWithIdentifier:chancelIdentifier];
    cell.messModel = _itemMarr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageDetailVC"];
    MessModel *model = _itemMarr[indexPath.row];
    detail.url = model.url;
    
    [self presentViewController:detail animated:YES completion:nil];
//    [self.navigationController pushViewController:detail animated:NO];
    
}

@end
