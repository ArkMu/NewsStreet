//
//  BtnViewCell.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "BtnViewCell.h"

#import "UIButton+WebCache.h"

#import "InfoModel.h"
#import "RelationModel.h"

#import "MoreInfoVC.h"

@interface BtnViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnL;
@property (weak, nonatomic) IBOutlet UIButton *btnLC;

@property (weak, nonatomic) IBOutlet UIButton *btnRC;
@property (weak, nonatomic) IBOutlet UIButton *btnR;

@end

@implementation BtnViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setBtnModel:(InfoModel *)btnModel {
    _btnModel = btnModel;
    
    NSArray *btnArr = _btnModel.relationArr;
    RelationModel *modelL = btnArr[0];
    
    [_btnL sd_setImageWithURL:[NSURL URLWithString:modelL.imgUrl] forState:UIControlStateNormal];
    [_btnL setTitle:modelL.title forState:UIControlStateNormal];
    
    RelationModel *modelLC = btnArr[1];
    
    [_btnLC sd_setImageWithURL:[NSURL URLWithString:modelLC.imgUrl] forState:UIControlStateNormal];
    [_btnLC setTitle:modelLC.title forState:UIControlStateNormal];
    
    RelationModel *modeRC = btnArr[2];
    
    [_btnRC sd_setImageWithURL:[NSURL URLWithString:modeRC.imgUrl] forState:UIControlStateNormal];
    [_btnRC setTitle:modeRC.title forState:UIControlStateNormal];
    
    RelationModel *modelR = btnArr[3];
    
    [_btnR sd_setImageWithURL:[NSURL URLWithString:modelR.imgUrl] forState:UIControlStateNormal];
    [_btnR setTitle:modelR.title forState:UIControlStateNormal];
}

- (IBAction)actionOnBtnTaped:(UIButton *)sender {
    NSArray *btnArr = _btnModel.relationArr;
    
    switch (sender.tag) {
        case 100:
        {
            RelationModel *model = btnArr[0];
            if (_gotoView) {
                _gotoView(model.url);
            }
        }
            break;
        case 101:
        {
           RelationModel *model = btnArr[1];
            if (_gotoView) {
                _gotoView(model.url);
            }
        }
            break;
            
        case 102:
        {
            RelationModel *model = btnArr[2];
            if (_gotoView) {
                _gotoView(model.url);
            }
        }
            break;
        case 103:
        {
            RelationModel *model = btnArr[3];
            if (_gotoView) {
                _gotoView(model.url);
            }
        }
            break;
        default:
            
            break;
    }
    
}


@end
