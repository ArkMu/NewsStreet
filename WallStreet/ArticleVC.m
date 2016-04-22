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

//#import "MoreInfoVC.h"

#import "TopicVC.h"

@interface ArticleVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mArr;

@property (nonatomic, strong) NSMutableArray *infoArr;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) ListVC *list;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) BOOL gestureTag;

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
    
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_item_catalogs@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(actionOnLeftBarBtnTaped)];
    
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
    [self addChildViewController:nav];
    
    _list = nav.viewControllers.firstObject;
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
    
    //偏移手势
    // 屏幕左部偏移
    UIScreenEdgePanGestureRecognizer *screenPanLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftEdgeGestureAction:)];
    screenPanLeft.edges = UIRectEdgeLeft;
    [_tableView addGestureRecognizer:screenPanLeft];
    
    // 屏幕右部偏移
    UIScreenEdgePanGestureRecognizer *screenPanRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(rightEdgeGestureAction:)];
    screenPanRight.edges = UIRectEdgeRight;
    [_tableView addGestureRecognizer:screenPanRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

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
            if (![model.type isEqualToString:@"ad"] && ![model.title isEqualToString:@"4columns"]) {
               [_mArr addObject:model];
            }
            
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
    
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSInteger currentTime = (NSInteger)time;
    NSDictionary *parameter = @{@"_eva_t":@(currentTime)};
    
    [manager GET:@"http://api.wallstreetcn.com/v2/mobile-articles?limit=5&page=1&channel=global-carousel&device=android&version=3" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSArray *resultArr = resultDict[@"results"];
        
        _infoArr = [NSMutableArray array];
        [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InfoModel *model = [InfoModel modelWithDictionary:(NSDictionary *)obj];
            if (![model.type isEqualToString:@"ad"]) {
               [_infoArr addObject:model];
            }
            
        }];
        
        
        ScrollView *scroll = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ScrollView class]) owner:nil options:nil][0];
        scroll.infoArr = _infoArr;
        scroll.gotoView = ^(NSInteger Id){
            DetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
            detail.Id = Id;
            [self.navigationController pushViewController:detail animated:NO];
        };
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
//        if ([model.title isEqualToString:@"4columns"]) {
//        BtnViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnIdentifier];
//        
//        cell.btnModel = _mArr[indexPath.row];
//        cell.gotoView = ^(NSString *url) {
//            MoreInfoVC *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreInfoVC"];
//            infoVC.channel = url;
//        };
//        return cell;
//    } else
        if ([model.type isEqualToString:@"topic"]) {
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
        
        scroll.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump:)];
        [scroll addGestureRecognizer:tap];
        
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
        btn.userInteractionEnabled = NO;
        
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
    
    if ([model.type isEqualToString:@"topic"]) {

        TopicVC *topic = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicVC"];
        topic.index = model.Id;
        
        [self.navigationController pushViewController:topic animated:NO];
        return;
    }
    
    DetailVC *web = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    web.Id = model.Id;
    [self.navigationController pushViewController:web animated:NO];
    
}



- (void)actionOnLeftBarBtnTaped {
    [UIView animateWithDuration:1.0 animations:^{
        _list.view.transform = CGAffineTransformMakeTranslation(300, 0);
        _tableView.transform = CGAffineTransformMakeTranslation(300, 0);
        
        _gestureTag = YES;
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
        
    } completion:^(BOOL finished) {
        if (![_tableView.gestureRecognizers containsObject:_tap]) {
            [_tableView addGestureRecognizer:_tap];
        }
    }];
    
}

- (void)backView {
    [UIView animateWithDuration:.5 animations:^{

        _list.view.transform = CGAffineTransformIdentity;
        _tableView.transform = CGAffineTransformIdentity;
        
       
    }
     completion:^(BOOL finished) {
         if (_tap) {
            [_tableView removeGestureRecognizer:_tap];
             _tap = nil;
         }
         
     }];
}

- (void)jump:(UITapGestureRecognizer *)tap {
    
    
    UITableViewCell *cell = (UITableViewCell *)tap.view;
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    InfoModel *model = _mArr[indexpath.row];
    
    DetailVC *web = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    web.Id = model.Id;
    [self.navigationController pushViewController:web animated:NO];
}


- (void)leftEdgeGestureAction:(UIScreenEdgePanGestureRecognizer *)screenPan {

    CGPoint point = [screenPan translationInView:self.view];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    _tableView.transform = CGAffineTransformMakeTranslation(point.x, 0);
    _list.view.transform = CGAffineTransformMakeTranslation(point.x, 0);
    
    
    if (screenPan.state == UIGestureRecognizerStateEnded) {
        if (point.x < width / 2) {
            [self backView];
        } else {
            [self actionOnLeftBarBtnTaped];
            _gestureTag = YES;
        }
    }
    
    
}

- (void)rightEdgeGestureAction:(UIScreenEdgePanGestureRecognizer *)screenPan {
    if (!_gestureTag) {
        return;
    }
    
    CGPoint point = [screenPan translationInView:self.view];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    _tableView.transform = CGAffineTransformMakeTranslation(300 + point.x, 0);
    _list.view.transform = CGAffineTransformMakeTranslation(300 + point.x, 0);
    
    
    if (screenPan.state == UIGestureRecognizerStateEnded) {
        if (abs((int)point.x) > width / 2) {
            
            [self actionOnLeftBarBtnTaped];
            _gestureTag = NO;
        } else {
            
            [self backView];
        }
    }
}


@end
