//
//  TrainEachDayContentCell.m
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainEachDayContentCell.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

@implementation TrainEachDayContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.dayLb];
        [self addSubview:self.contentLb];
        [self addSubview:self.numLb];
        [self addSubview:self.typeLb];
        [self addSubview:self.myimageViwe];
        
        [self needsUpdateConstraints];
    }
    return self;
}

#pragma mark -private method


- (void)setMyData:(TrainGetTrainEachDayModel *)model day:(NSInteger)day
{
    [self.dayLb setText:[NSString stringWithFormat:@"第%ld天",day]];
    [self.contentLb setText:model.name];
    [self.numLb setText:[NSString stringWithFormat:@"%ld",model.length]];
    if (model.classify == 0) {
        [self.myimageViwe setImage:[UIImage imageNamed:@"train_timeIcon"]];
        [self.typeLb setText:@"min"];
        [self.numLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.myimageViwe);
            make.centerY.equalTo(self.myimageViwe).offset(2);
        }];

    }
    else
    {
        [self.myimageViwe setImage:[UIImage imageNamed:@"train_kmIcon"]];
        [self.typeLb setText:@"km"];
        [self.numLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.myimageViwe);
        }];

    }
}

- (void)updateConstraints
{
    [self.dayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(16);
        make.bottom.equalTo(self).offset(-16);
    }];
    
    [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLb.mas_right).offset(20);
        make.top.bottom.equalTo(self.dayLb);
    }];
    
    [self.myimageViwe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.right.equalTo(self).offset(-19);
    }];
    [self.typeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myimageViwe.mas_bottom);
        make.centerX.equalTo(self.myimageViwe);
    }];
//    [self.numLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo(self.myimageViwe);
//        }];
   
    [super updateConstraints];

}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI




- (UILabel *)dayLb
{
    if (!_dayLb) {
        _dayLb = [UILabel setLabel:_dayLb text:@"第一天" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _dayLb;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [UILabel setLabel:_contentLb text:@"腹肌燃烧" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _contentLb;
}

- (UILabel *)numLb
{
    if (!_numLb) {
        _numLb = [UILabel setLabel:_numLb text:@"30" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor colorLightGray_898888]];
    }
    return _numLb;
}

- (UILabel *)typeLb
{
    if (!_typeLb) {
        _typeLb = [UILabel setLabel:_typeLb text:@"km" font:[UIFont systemFontOfSize:fontSize_12] textColor:[UIColor colorLightGray_898888]];
    }
    return _typeLb;
}

- (UIImageView *)myimageViwe
{
    if (!_myimageViwe) {
        _myimageViwe = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"train_kmIcon"]];
    }
    return _myimageViwe;
}

@end
