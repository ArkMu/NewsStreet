//
//  InfoCellOne.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "InfoCellOne.h"

#import "NSString+Time.h"

#import "InfoModel.h"

#import "UIImageView+WebCache.h"

@interface InfoCellOne ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation InfoCellOne

- (void)setInfoModel:(InfoModel *)infoModel {
    _infoModel = infoModel;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:infoModel.imgUrl] placeholderImage:nil];
    _titleLabel.text = infoModel.title;
    _timeLabel.text = [NSString dateString:infoModel.createdAt];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
