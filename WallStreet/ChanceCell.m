//
//  ChanceCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChanceCell.h"

#import "MessModel.h"

@interface ChanceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctimeLabel;


@end

@implementation ChanceCell

-(void)setMessModel:(MessModel *)messModel {
    _messModel = messModel;
    
    _titleLabel.text = messModel.title;
    _ctimeLabel.text = [messModel.ctime substringWithRange:NSMakeRange(11, 5)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
