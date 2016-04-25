//
//  MessageVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ImportantNewsVC.h"

#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"

#import "Common.h"

#import "GDataXMLNode.h"

#import "MessModel.h"
#import "itemView.h"

#import "MessageDetailVC.h"

#import "Reachability.h"
#import "SVProgressHUD.h"

@interface ImportantNewsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *itemMarr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation ImportantNewsVC

static NSString *itemIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 120) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 100.f;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([itemView class]) bundle:nil] forCellReuseIdentifier:itemIdentifier];
    
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
    NSString *str = [NSString stringWithFormat:@"http://m.0033.com/list/headline/v2/%ld.xml", _pageIndex];
    
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
            
            GDataXMLElement *imgurlElement = [[item elementsForName:@"imgurl"] objectAtIndex:0];
            NSString *imgurl = [imgurlElement stringValue];
            [mDict setValue:seq forKey:@"seq"];
            [mDict setValue:title forKey:@"title"];
            [mDict setValue:ctime forKey:@"ctime"];
            [mDict setValue:url forKey:@"url"];
            [mDict setValue:imgurl forKey:@"imgurl"];
            
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
    itemView *item = [tableView dequeueReusableCellWithIdentifier:itemIdentifier];
    item.messModel = _itemMarr[indexPath.row];
    return item;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageDetailVC"];
    MessModel *model = _itemMarr[indexPath.row];
    detail.url = model.url;

    
    [self presentViewController:detail animated:YES completion:nil];
    
}

@end
