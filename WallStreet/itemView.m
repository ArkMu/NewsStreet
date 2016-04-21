//
//  itemView.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "itemView.h"

#import "UIImageView+WebCache.h"

#import "MessModel.h"

@interface itemView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation itemView

-(void)setMessModel:(MessModel *)messModel {
    _messModel = messModel;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_messModel.imgurl] placeholderImage:nil];
    _titleLabel.text = _messModel.title;
    _timeLabel.text = [_messModel.ctime substringWithRange:NSMakeRange(11, 5)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
