//
//  MessageDetailVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MessageDetailVC.h"

#import "Masonry.h"

#import "Common.h"

#import "ContainerVC.h"
@interface MessageDetailVC ()

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, ScreenW, 40)];
    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [navView addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"browser_previous@2x"] forState:UIControlStateNormal];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"资讯正文";
    [navView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(navView);
    }];
    
    [btn addTarget:self action:@selector(btnOnDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 64)];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnOnDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
//    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"contVC"];
//
//    [self presentViewController:vc animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
