//
//  WebVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailVC.h"

#import "AFHTTPSessionManager.h"

#import "DetailModel.h"

#import "Masonry.h"

@interface DetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DetailModel *detailModel;

@end

@implementation DetailVC

static NSString *webIdentifier = @"web";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:webView];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
//    [webView loadRequest:request];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    NSString *str = [NSString stringWithFormat:@"http://api.wallstreetcn.com/v2/posts/%ld", _Id];
    
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@", error);
        
//        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSDictionary *resultDict = (NSDictionary *)obj;
        
//        NSMutableDictionary *htmlDict = [NSMutableDictionary dictionary];
        NSString *title = resultDict[@"title"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultDict[@"createdAt"] integerValue]];
        NSString *created = [NSString stringWithFormat:@"%@", date];
        
        NSString *summary = resultDict[@"summary"];
        NSString *imageUrl = resultDict[@"imageUrl"];
        NSString *content = resultDict[@"content"];
        NSString *html = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img{width: %f;height: auto;text-align:center}</style></head><h2 style=\"font-size:20px;color:black\">%@</h2><p style=\"font-size:14px;color:gray\">%@ %@</p><body style=\"font-size:17px;color:gray\">%@</body></html>", 360.f,title, created, summary, content];
        
                                                                             
        
        
//        NSLog(@"%@", resultDict);
        
        _detailModel = [DetailModel modelWithDictionary:resultDict];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//        [webView loadHTMLString:_detailModel.content baseURL:nil];
        [webView loadHTMLString:html baseURL:nil];
        
        [self.view addSubview:webView];
//        [self loadTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 500.f;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:webIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:webIdentifier];
    UIWebView *webView = [[UIWebView alloc] init];
    [cell.contentView addSubview:webView];
    
    webView.paginationBreakingMode = UIWebPaginationBreakingModeColumn;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(cell);
        make.size.mas_equalTo(cell);
    }];
    
    [webView loadHTMLString:_detailModel.content baseURL:nil];
    NSLog(@"%f", webView.scrollView.contentSize.height);
    return cell;
}



@end
