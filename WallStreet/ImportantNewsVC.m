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

#import "GDataXMLNode.h"

#import "MessModel.h"
#import "itemView.h"

#import "MessageDetailVC.h"

@interface ImportantNewsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *itemMarr;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ImportantNewsVC

static NSString *itemIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemMarr = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 100.f;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([itemView class]) bundle:nil] forCellReuseIdentifier:itemIdentifier];
    
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self loadData];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//http://m.0033.com/list/headline/v2/1.xml
//http://m.0033.com/list/headline/v2/2.xml

-(void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *str = [NSString stringWithFormat:@"http://m.0033.com/list/headline/v2/%ld.xml", _pageIndex];
    
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject options:-1 error:&error];
        NSLog(@"%@", error);
        
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
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
