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

#import "MJRefresh.h"

#import "MessModel.h"
#import "ChanceCell.h"

#import "MessageDetailVC.h"

@interface ChanceVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *itemMarr;

@end

@implementation ChanceVC

static NSString *chancelIdentifier = @"chancel";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemMarr = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.estimatedRowHeight = 120.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChanceCell class]) bundle:nil] forCellReuseIdentifier:chancelIdentifier];
    
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

-(void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *str = [NSString stringWithFormat:@"http://news.10jqka.com.cn/tzjh_mlist/1_0_0_%ld/", _pageIndex];
    
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
//            
//            GDataXMLElement *imgurlElement = [[item elementsForName:@"imgurl"] objectAtIndex:0];
//            NSString *imgurl = [imgurlElement stringValue];
//            
//            GDataXMLElement *digestElement = [[item elementsForName:@"digest"] objectAtIndex:0];
//            NSString *digest = [digestElement stringValue];
            
            [mDict setValue:seq forKey:@"seq"];
            [mDict setValue:title forKey:@"title"];
            [mDict setValue:ctime forKey:@"ctime"];
            [mDict setValue:url forKey:@"url"];
//            [mDict setValue:imgurl forKey:@"imgurl"];
//            [mDict setValue:digest forKey:@"digest"];
            
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
