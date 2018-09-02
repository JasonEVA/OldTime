//
//  TrainStrengthView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainStrengthView.h"
#import <Masonry.h>

@implementation TrainStrengthView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.light1];
        [self addSubview:self.light2];
        [self addSubview:self.light3];
        [self addSubview:self.light4];
        [self addSubview:self.light5];
        
        [self.light1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
        }];
        [self.light2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.top.bottom.equalTo(self.light1);
            make.left.equalTo(self.light1.mas_right);
        }];
        [self.light3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.top.bottom.equalTo(self.light1);
            make.left.equalTo(self.light2.mas_right);
        }];
        [self.light4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.top.bottom.equalTo(self.light1);
            make.left.equalTo(self.light3.mas_right);
        }];
        [self.light5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.top.bottom.equalTo(self.light1);
            make.left.equalTo(self.light4.mas_right);
            make.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setTrainStrengLevel:(NSInteger)strengthLevel
{
    switch (strengthLevel) {
        case 1:
            [self.light1 setHighlighted:YES];
            break;
        case 2:
            [self.light1 setHighlighted:YES];
            [self.light2 setHighlighted:YES];
            break;
        case 3:
            [self.light1 setHighlighted:YES];
            [self.light2 setHighlighted:YES];
            [self.light3 setHighlighted:YES];
            break;
        case 4:
            [self.light1 setHighlighted:YES];
            [self.light4 setHighlighted:YES];
            [self.light2 setHighlighted:YES];
            [self.light3 setHighlighted:YES];
            break;
        case 5:
            [self.light1 setHighlighted:YES];
            [self.light5 setHighlighted:YES];
            [self.light4 setHighlighted:YES];
            [self.light2 setHighlighted:YES];
            [self.light3 setHighlighted:YES];
            break;
            
        default:
            break;
    }
}

- (UIImageView *)light1
{
    if (!_light1) {
        _light1 = [[UIImageView alloc]init];
        [_light1 setImage:[UIImage imageNamed:@"train_light_disable"]];
        [_light1 setHighlightedImage:[UIImage imageNamed:@"train_light"]];
    }
    return _light1;
}

- (UIImageView *)light2
{
    if (!_light2) {
        _light2 = [[UIImageView alloc]init];
        [_light2 setImage:[UIImage imageNamed:@"train_light_disable"]];
        [_light2 setHighlightedImage:[UIImage imageNamed:@"train_light"]];
    }
    return _light2;
}

- (UIImageView *)light3
{
    if (!_light3) {
        _light3 = [[UIImageView alloc]init];
        [_light3 setImage:[UIImage imageNamed:@"train_light_disable"]];
        [_light3 setHighlightedImage:[UIImage imageNamed:@"train_light"]];
    }
    return _light3;
}

- (UIImageView *)light4
{
    if (!_light4) {
        _light4 = [[UIImageView alloc]init];
        [_light4 setImage:[UIImage imageNamed:@"train_light_disable"]];
        [_light4 setHighlightedImage:[UIImage imageNamed:@"train_light"]];
    }
    return _light4;
}

- (UIImageView *)light5
{
    if (!_light5) {
        _light5 = [[UIImageView alloc]init];
        [_light5 setImage:[UIImage imageNamed:@"train_light_disable"]];
        [_light5 setHighlightedImage:[UIImage imageNamed:@"train_light"]];
    }
    return _light5;
}

@end
