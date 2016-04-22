//
//  LiveVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LiveVC.h"

#import "GlobalVC.h"
#import "AguVC.h"
#import "CalendarVC.h"

@interface LiveVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *VCArr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIPageViewController *pageViewControl;

@end

@implementation LiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"全球", @"A股", @"日历"];
    _segment = [[UISegmentedControl alloc] initWithItems:arr];
    _segment.frame = CGRectMake(0, 0, 180, 30);
    _segment.selectedSegmentIndex = _index;
    self.navigationItem.titleView = _segment;
    [_segment addTarget:self action:@selector(segmentControlValuedChanged:) forControlEvents:UIControlEventValueChanged];
    
//    NSDate *date = [NSDate date];
//    NSString *str = [NSString stringWithFormat:@"%@", date];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 60, 40);
//    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
//    [rightBtn addTarget:self action:@selector(actionOnBtnTaped) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setTitle:[str substringWithRange:NSMakeRange(0, 7)] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _pageViewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"pageVC"];
    _pageViewControl.dataSource = self;
    _pageViewControl.delegate = self;
    
    _VCArr = [NSMutableArray array];
    
    GlobalVC *global = [self.storyboard instantiateViewControllerWithIdentifier:@"GlobalVC"];
    [_VCArr addObject:global];
    
    AguVC *agu = [self.storyboard instantiateViewControllerWithIdentifier:@"AguVC"];
    [_VCArr addObject:agu];
    
    CalendarVC *calendar = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
    [_VCArr addObject:calendar];
    
    [self addChildViewController:_pageViewControl];
    [self.view addSubview:_pageViewControl.view];
    
    [_pageViewControl setViewControllers:@[global] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [[viewController valueForKey:@"index"] integerValue];
    _index = index;
    
    _segment.selectedSegmentIndex = _index;
    
    _index--;
    if (_index < 0) {
        return nil;
    }
    
    
    UIViewController *vc = _VCArr[_index];
    [vc setValue:@(_index) forKey:@"index"];
    
    return _VCArr[_index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [[viewController valueForKey:@"index"] integerValue];
    _index = index;
    
    _segment.selectedSegmentIndex = _index;
    
    _index++;
    if (_index == _VCArr.count) {
        return nil;
    }
    
    
    UIViewController *vc = _VCArr[_index];
    [vc setValue:@(_index) forKey:@"index"];
    
    return _VCArr[_index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)segmentControlValuedChanged:(UISegmentedControl *)segmentControl {
    NSInteger vcIndex = segmentControl.selectedSegmentIndex;
    _index = vcIndex;
    
    [_pageViewControl setViewControllers:@[_VCArr[vcIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}



@end
