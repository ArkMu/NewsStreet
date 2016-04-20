//
//  ArticleVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ArticleVC.h"

#import "MJRefresh.h"
#import "AFHTTPSessionManager.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

#import "InfoModel.h"
#import "RelationModel.h"

#import "InfoCellOne.h"

#import "ScrollView.h"

#import "BtnViewCell.h"

#import "MoreInfoVC.h"
#import "DetailVC.h"

#import "ListVC.h"

#import "MoreInfoVC.h"

@interface ArticleVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mArr;

@property (nonatomic, strong) NSMutableArray *infoArr;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) ListVC *list;

@end

@implementation ArticleVC

static NSString *cellIdentifier = @"cell";
static NSString *moreIdentifier = @"more";
static NSString *btnIdentifier = @"btn";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.rowHeight = 100.f;
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_item_catalogs@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(actionOnLeftBarBtnTaped)];
    
    _list = [self.storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
    [self addChildViewController:_list];
    
    [self.view addSubview:_list.view];
    
    [self.view.window bringSubviewToFront:_list.view];
    _list.view.frame = CGRectMake(-375, 0, self.view.frame.size.width, self.view.frame.size.height);
    __weak ArticleVC *article = self;
    _list.dismissListVC = ^(MoreInfoVC *info){
        [article backView];
        [article.navigationController pushViewController:info animated:NO];
    };
    
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoCellOne class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:moreIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BtnViewCell class]) bundle:nil] forCellReuseIdentifier:btnIdentifier];
    
    _mArr = [NSMutableArray array];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self loadMoreData];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadMoreData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = currentDate.timeIntervalSince1970;
    NSInteger inter = (NSInteger)interval;
    
    NSDictionary *parameter = @{@"page":@(_pageIndex),
                                @"_eva_t":@(inter)};

    
    [manager GET:@"http://api.wallstreetcn.com/v2/mobile-articles?channel=global&device=android&accept=article,external-article,topic,facility,flash-strip,external-topic,ad.inhouse,ad.airwaveone,ad.madhouse,chat" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *arr = resultDict[@"results"];
        
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InfoModel *model = [InfoModel modelWithDictionary:(NSDictionary *)obj];
            [_mArr addObject:model];
        }];

        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://api.wallstreetcn.com/v2/mobile-articles?limit=5&page=1&channel=global-carousel&device=android&version=3&_eva_t=1460986634" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *resultArr = resultDict[@"results"];
        
        _infoArr = [NSMutableArray array];
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InfoModel *model = [InfoModel modelWithDictionary:(NSDictionary *)obj];
            [_infoArr addObject:model];
        }];
        
        
        ScrollView *scroll = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ScrollView class]) owner:nil options:nil][0];
        scroll.infoArr = _infoArr;
        _tableView.tableHeaderView = scroll;

        [self loadMoreData];
        
        if ([_tableView.mj_header isRefreshing]) {
           [_tableView.mj_header endRefreshing]; 
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoModel *model = _mArr[indexPath.row];
    NSLog(@"%@", model.type);
    if ([model.title isEqualToString:@"4columns"]) {
        BtnViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnIdentifier];
        
        cell.btnModel = _mArr[indexPath.row];
        cell.gotoView = ^(NSString *url) {
            MoreInfoVC *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreInfoVC"];
            infoVC.channel = url;
        };
        return cell;
    } else if ([model.type isEqualToString:@"topic"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
        
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [view removeFromSuperview];
            }
        }
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13.0];
        label.text  = model.title;
        [cell addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.trailing.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        
        UIView *view = [self setImgViewForScrollView:model.relationArr];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
        scroll.contentSize = view.frame.size;
        [scroll addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.center.mas_equalTo(scroll);
        }];
        
        [cell.contentView addSubview:scroll];
        
        [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(label.mas_bottom).with.offset(-10);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
        
        return cell;
    } else {
        InfoCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.infoModel = _mArr[indexPath.row];
        return cell;
    }

}


- (UIView *)setImgViewForScrollView:(NSArray *)relation {
    
    CGFloat imgWidth = 150.f;
    CGFloat imgHeight = 100.f;
    CGFloat imgSpace = 10.f;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (imgSpace + imgWidth) * relation.count, imgHeight)];
    
    [relation enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RelationModel *model = (RelationModel *)obj;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake((imgSpace + imgWidth) * idx, 20, imgWidth, imgHeight);
        
        [containerView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.title;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13.0];
        [btn addSubview:label];
        label.numberOfLines = 0;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8);
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(btn).with.offset(-8);
        }];

    }];
    
    return containerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoModel *model = _mArr[indexPath.row];
    if ([model.type isEqualToString:@"topic"]) {
       return 150.f;
    }
    return 100.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoModel *model = _mArr[indexPath.row];
    
    DetailVC *web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
    web.Id = model.Id;
//    web.url = model.url;
    
    [self.navigationController pushViewController:web animated:NO];
}



- (void)actionOnLeftBarBtnTaped {
    [UIView animateWithDuration:1.0 animations:^{
        _list.view.transform = CGAffineTransformMakeTranslation(300, 0);
        _tableView.transform = CGAffineTransformMakeTranslation(300, 0);
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(300, 0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
    [_tableView addGestureRecognizer:tap];
    
}

- (void)backView {
    [UIView animateWithDuration:.5 animations:^{
        _list.view.transform = CGAffineTransformIdentity;
        _tableView.transform = CGAffineTransformIdentity;
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    }];
}

@end
