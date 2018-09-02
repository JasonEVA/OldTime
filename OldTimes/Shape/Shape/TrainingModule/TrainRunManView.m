//
//  TrainRunManView.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainRunManView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>

@implementation TrainRunManView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.runImageView];
        [self addSubview:self.distanceLb];
        [self addSubview:self.targetLb];
        
        [self.runImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-5);
        }];
        
        [self.distanceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.runImageView).offset(-5);
            make.centerX.equalTo(self.runImageView).offset(8);
        }];
        
        [self.targetLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.distanceLb);
            make.bottom.equalTo(self.distanceLb.mas_top).offset(-5);
        }];

    }
    return self;
}

- (UIImageView *)runImageView
{
    if (!_runImageView) {
        _runImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"train_runman"]];
    }
    return _runImageView;
}

- (UILabel *)targetLb
{
    if (!_targetLb) {
        _targetLb = [UILabel setLabel:_targetLb text:@"目标" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _targetLb;
}

- (UILabel *)distanceLb
{
    if (!_distanceLb) {
        _distanceLb = [UILabel setLabel:_distanceLb text:@"4KM" font:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor]];
        _distanceLb.font = [UIFont fontWithName:fontName_BebasNeue size:30];
    }
    return _distanceLb;
}
@end
