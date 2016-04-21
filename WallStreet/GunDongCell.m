//
//  GunDongCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "GunDongCell.h"

#import "MessModel.h"

@interface GunDongCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GunDongCell

- (void)setMessModel:(MessModel *)messModel {
    _messModel = messModel;
    
    _timeLabel.text = [messModel.ctime substringWithRange:NSMakeRange(11, 5)];
    
    _contentLabel.text = [NSString stringWithFormat:@"[%@] %@", messModel.title, messModel.digest];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
