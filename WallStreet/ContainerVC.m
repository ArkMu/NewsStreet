//
//  ContainerVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ContainerVC.h"

#import "Common.h"

#import "ImportantNewsVC.h"
#import "GunDongVC.h"
#import "ChanceVC.h"

#import "MessModel.h"
#import "MessageDetailVC.h"

@interface ContainerVC () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *locationArr;

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationArr = @[@"要闻", @"滚动", @"机会"];
    _btnArr = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(ScreenW * 3, ScreenH);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW * 3, ScreenH)];
    [_scrollView addSubview:containerView];
    [self.view addSubview:_scrollView];
    
    _scrollView.directionalLockEnabled = YES;
    
    ImportantNewsVC *newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportantNewsVC"];
    GunDongVC *gundongVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GunDongVC"];
    ChanceVC *chance = [self.storyboard instantiateViewControllerWithIdentifier:@"ChanceVC"];
    
    
    [containerView addSubview:newVC.view];
    newVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [containerView addSubview:gundongVC.view];
    gundongVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, ScreenH);
    [containerView addSubview:chance.view];
    chance.view.frame = CGRectMake(ScreenW * 2, 0, ScreenW, ScreenH);
    
    _scrollView.delegate = self;
    
    
    for (int i = 0; i < _locationArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_locationArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        
        [btn addTarget:self action:@selector(actionOnBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_btnArr addObject:btn];
        btn.frame = CGRectMake(125 * i, 0, 125, 40);
        
        [self.navigationController.navigationBar addSubview:btn];
        
    }
    
    [self setBtnColor:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setBtnColor:(NSInteger)index {
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btn = _btnArr[index];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    
    [self setBtnColor:index];
}

- (void)actionOnBtnSelected:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    
    [_scrollView scrollRectToVisible:CGRectMake(ScreenW * index, 0, ScreenW, ScreenH) animated:YES];
    
    [self setBtnColor:index];
}


@end
