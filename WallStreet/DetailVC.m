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

#import "Common.h"

@interface DetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DetailModel *detailModel;

@end

@implementation DetailVC

static NSString *webIdentifier = @"web";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_previous@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(actionOnBarBtnTaped)];
    
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
        
        NSDictionary *resultDict = (NSDictionary *)obj;
        
        NSString *title = resultDict[@"title"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultDict[@"createdAt"] integerValue]];
        NSString *created = [NSString stringWithFormat:@"%@", date];
        
        NSString *summary = resultDict[@"summary"];
        NSString *content = resultDict[@"content"];
        NSString *html = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img{width: %f;height: auto;text-align:center}</style></head><h2 style=\"font-size:20px;color:black\">%@</h2><p style=\"font-size:14px;color:gray\">%@ %@</p><body style=\"font-size:17px;color:gray\">%@</body></html>", 360.f,title, created, summary, content];
        
        _detailModel = [DetailModel modelWithDictionary:resultDict];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 120)];
        [webView loadHTMLString:html baseURL:nil];
        
        [self.view addSubview:webView];
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
//    NSLog(@"%f", webView.scrollView.contentSize.height);
    return cell;
}


- (void)actionOnBarBtnTaped {
    [self.navigationController popViewControllerAnimated:NO];
}


@end
