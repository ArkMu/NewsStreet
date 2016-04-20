//
//  AguCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AguCell.h"

#import "AguModel.h"

#import "NSString+Time.h"

@interface AguCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation AguCell

- (void)setAguModel:(AguModel *)aguModel {
    _aguModel = aguModel;
    
    _timeLabel.text = [NSString dateString:[aguModel.updatedAt integerValue]];
    _titleLabel.text = aguModel.title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
