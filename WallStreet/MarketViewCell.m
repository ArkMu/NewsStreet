//
//  MarketViewCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MarketViewCell.h"

#import "UIImageView+WebCache.h"

#import "MarketModel.h"

@interface MarketViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UILabel *forcastLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imporTanceImgView;
@end

@implementation MarketViewCell

- (void)setMarkModel:(MarketModel *)markModel {
    _markModel = markModel;
    
   
    
    _titleLabel.text = [NSString stringWithFormat:@"(%@)%@",markModel.country, markModel.title];
    _timeLabel.text = [NSString stringWithFormat:@"%@", [markModel.localDateTime substringWithRange:NSMakeRange(11, 5)]];
    
    if ([markModel.actual isKindOfClass:[NSNull class]]) {
        _actualLabel.text = @"今值:   ";
    } else {
        _actualLabel.text = [NSString stringWithFormat:@"今值:%@", markModel.actual];
    }
    
    if ([markModel.forecast isKindOfClass:[NSNull class]]) {
        _forcastLabel.text = @"预期:  ";
    } else {
       _forcastLabel.text = [NSString stringWithFormat:@"预期:%@", markModel.forecast];
    }
    
    if ([markModel.previous isKindOfClass:[NSNull class]]) {
        _previousLabel.text = @"前值:  ";
    } else {
      _previousLabel.text = [NSString stringWithFormat:@"前值:%@", markModel.previous];
    }
    
    
    
    
}

- (void)setCountryName:(NSDictionary *)countryName {
    _countryName = countryName;
    
    _imgView.image = [UIImage imageNamed:_countryName[_markModel.country]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
