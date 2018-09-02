//
//  TrainTitelView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainTitelView.h"
#import <Masonry.h>
#import "UILabel+EX.h"
#import "MyDefine.h"

@implementation TrainTitelView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.titelLb];
        [self addSubview:self.strengthView];
        [self addSubview:self.instrumentLb];
        
        [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.right.lessThanOrEqualTo(self);
        }];
        [self.strengthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.titelLb.mas_bottom).offset(13);
            make.width.mas_equalTo(53);
            make.height.mas_equalTo(15);
        }];
        [self.instrumentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.strengthView);
            make.left.equalTo(self.strengthView.mas_right).offset(13);
            make.right.lessThanOrEqualTo(self);
        }];
    }
    return self;
}

-(void)setMyData:(TrainGetTrainInfoModel *)model
{
    [self.titelLb setText:model.name];
    [self.strengthView setTrainStrengLevel:model.difficulty];
    [self.instrumentLb setText:model.equipment];
}

- (void)setDayInfoData:(TrainGetDayTrainInfoModel *)model
{
    [self.titelLb setText:model.trainingName];
    [self.strengthView setTrainStrengLevel:model.difficulty];
    [self.instrumentLb setText:model.equipment];
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"零基础适应性训练" font:[UIFont systemFontOfSize:fontSize_18] textColor:[UIColor whiteColor]];
    }
    return _titelLb;
}

- (UILabel *)instrumentLb
{
    if (!_instrumentLb) {
        _instrumentLb = [UILabel setLabel:_instrumentLb text:@"无器械" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _instrumentLb;
}

- (TrainStrengthView *)strengthView
{
    if (!_strengthView) {
        _strengthView = [[TrainStrengthView alloc]init];
    }
    return _strengthView;
}
@end
