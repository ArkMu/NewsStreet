//
//  ScrollView.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ScrollView.h"

#import "InfoModel.h"

#import "UIImageView+WebCache.h"

@interface ScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ScrollView

- (void)awakeFromNib {
    _scrollView.delegate = self;
    
    _centerImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOnTap)];
    [_centerImgView addGestureRecognizer:tap];
}

- (void)setInfoArr:(NSArray *)infoArr {
    _infoArr = infoArr;
    
    _pageControl.numberOfPages = infoArr.count;
    
    [self setImgForView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        _currentIndex--;
    } else if (scrollView.contentOffset.x == 2 * self.scrollView.frame.size.width) {
        _currentIndex++;
    }
    
    _currentIndex = [self indexEnable:_currentIndex];
    
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    
    [self setImgForView];
}

- (void)setImgForView {
    
    _pageControl.currentPage = _currentIndex;
    
    NSInteger leftindex = [self indexEnable:_currentIndex - 1];
    InfoModel *leftModel = _infoArr[leftindex];
    [_leftImgView sd_setImageWithURL:[NSURL URLWithString:leftModel.imgUrl] placeholderImage:nil];
    _titleLabel.text = leftModel.title;
    _leftImgView.userInteractionEnabled = YES;
    
    NSInteger centerindex = [self indexEnable:_currentIndex];
    InfoModel *centerModel = _infoArr[centerindex];
    [_centerImgView sd_setImageWithURL:[NSURL URLWithString:centerModel.imgUrl] placeholderImage:nil];
    _titleLabel.text = centerModel.title;
    _centerImgView.userInteractionEnabled = YES;
    
    NSInteger rightindex = [self indexEnable:_currentIndex + 1];
    InfoModel *rightModel = _infoArr[rightindex];
    [_rightImgView sd_setImageWithURL:[NSURL URLWithString:rightModel.imgUrl] placeholderImage:nil];
    _titleLabel.text = rightModel.title;
    _rightImgView.userInteractionEnabled = YES;
    
}


- (NSInteger)indexEnable:(NSInteger)index {
    if (index < 0) {
        return _infoArr.count - 1;
    } else if (index > _infoArr.count - 1) {
        return 0;
    }
    
    return index;
}


- (void)actionOnTap {
    
    InfoModel *model = _infoArr[_currentIndex];
    
    if (_gotoView) {
        _gotoView(model.Id);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
