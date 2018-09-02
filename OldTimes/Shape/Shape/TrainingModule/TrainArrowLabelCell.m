//
//  TrainArrowLabelCell.m
//  Shape
//
//  Created by jasonwang on 15/11/3.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainArrowLabelCell.h"
#import <Masonry.h>
#import "UILabel+EX.h"
#import "MyDefine.h"

@implementation TrainArrowLabelCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView1];
        [self addSubview:self.imageView3];
        [self addSubview:self.imageView2];
        [self addSubview:self.label];
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self);
            make.bottom.equalTo(self).offset(-8);
        }];

        [self.imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.label.mas_right).offset(6);
            make.centerY.equalTo(self.label);
        }];
        [self.imageView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView1.mas_right);
            make.centerY.equalTo(self.label);
            //make.top.bottom.equalTo(self);
        }];
        [self.imageView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView2.mas_right);
            make.centerY.equalTo(self.label);
            make.right.lessThanOrEqualTo(self);
            //make.top.right.bottom.equalTo(self);
        }];
       
    }
    return self;
}


- (void)setTitel:(NSString *)titel strenth:(NSInteger)strenth
{
    [self.label setText:titel];
    switch (strenth) {
        case 0:
        {
            [self.imageView1 setImage:[UIImage imageNamed:@"train_hold"]];
            [self.imageView2 setHidden:YES];
            [self.imageView3 setHidden:YES];
        }
            break;
        case -1:
        {
            [self.imageView1 setImage:[UIImage imageNamed:@"train_down"]];
            [self.imageView2 setHidden:YES];
            [self.imageView3 setHidden:YES];
        }
            break;
        case 1:
        {
            [self.imageView1 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView2 setHidden:YES];
            [self.imageView3 setHidden:YES];
        }
            break;
        case 2:
        {
            [self.imageView1 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView2 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView2 setHidden:NO];
            [self.imageView3 setHidden:YES];
        }
            break;
        case 3:
        {
            [self.imageView1 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView2 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView3 setImage:[UIImage imageNamed:@"train_up"]];
            [self.imageView1 setHidden:NO];
            [self.imageView3 setHidden:NO];
            [self.imageView2 setHidden:NO];
        }
            break;
        default:
            break;
    }
}

- (UIImageView *)imageView1
{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc]init];
        [_imageView1 setImage:[UIImage imageNamed:@"train_up"]];
    }
    return _imageView1;
}

- (UIImageView *)imageView2
{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc]init];
        [_imageView2 setImage:[UIImage imageNamed:@"train_up"]];
    }
    return _imageView2;
}

- (UIImageView *)imageView3
{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc]init];
        [_imageView3 setImage:[UIImage imageNamed:@"train_up"]];
    }
    return _imageView3;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel setLabel:_label text:@"腹肌" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _label;
}
@end


