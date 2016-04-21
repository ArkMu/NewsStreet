//
//  InfoCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "InfoCell.h"

#import "UIImageView+WebCache.h"

#import "PostModel.h"

@interface InfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end

@implementation InfoCell

-(void)setPostModel:(PostModel *)postModel {
    _postModel = postModel;
    
    _titleLabel.text = postModel.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[postModel.createdAt integerValue]];
    NSString *dateStr = [NSString stringWithFormat:@"%@", date];
    _timeLabel.text = [dateStr substringWithRange:NSMakeRange(11, 5)];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:postModel.imageUrl] placeholderImage:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
