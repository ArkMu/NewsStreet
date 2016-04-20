//
//  ListVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ListVC.h"

#import "ListHeaderView.h"

#import "MoreInfoVC.h"

@interface ListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView; 

@property (nonatomic, strong) NSDictionary *infoDic;

@end

@implementation ListVC

static NSString *cellIdentifier = @"cell";
static NSString *headerIdentifier = @"header";

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoDic = @{@"专题":@"specials", @"最热":@"most-read", @"推荐":@"editors-choice", @"美国":@"us", @"中国":@"china", @"欧洲":@"europe", @"经济":@"economy", @"市场":@"markets", @"央行":@"central-banks", @"研究帝":@"research", @"盘前报告":@"MarketSummary"};
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(75, 24, 300, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
 
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headerIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoDic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *infoArr = _infoDic.allKeys;
    cell.textLabel.text = infoArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120.f;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
        return headerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreInfoVC *info = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreInfoVC"];
    NSString *key = _infoDic.allKeys[indexPath.row];
    info.channel = _infoDic[key];
    
    if (_dismissListVC) {
        _dismissListVC(info);
    }
    
}

@end
