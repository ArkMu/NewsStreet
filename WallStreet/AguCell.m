//
//  AguCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AguCell.h"

#import "AguModel.h"


@interface AguCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation AguCell

- (void)setAguModel:(AguModel *)aguModel {
    _aguModel = aguModel;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[aguModel.updatedAt integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    _timeLabel.text = [dateString substringWithRange:NSMakeRange(11, 5)];
    _titleLabel.text = aguModel.title;
}

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
