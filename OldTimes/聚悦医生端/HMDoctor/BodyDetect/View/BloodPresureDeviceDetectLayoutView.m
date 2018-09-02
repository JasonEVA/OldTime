//
//  BloodPresureDeviceDetectLayoutView.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPresureDeviceDetectLayoutView.h"

@interface BloodPresureDeviceDetectLayoutView ()
{
    UIView *heartView;
    UILabel *lbheartValue;
    UIView *bottomView;
    UIImageView *imgView;
}
@end

@implementation BloodPresureDeviceDetectLayoutView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        heartView = [[UIView alloc] init];
        [heartView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:heartView];
        
        _heartImage = [[UIImageView alloc] init];
        [_heartImage setImage:[UIImage imageNamed:@"icon_heart_small"]];
        [heartView addSubview:_heartImage];
        
        lbheartValue = [[UILabel alloc] init];
        [lbheartValue setText:@"000"];
        [lbheartValue setTextColor:[UIColor commonTextColor]];
        [lbheartValue setFont:[UIFont systemFontOfSize:24]];
        [heartView addSubview:lbheartValue];
        
        bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        imgView = [[UIImageView alloc] init];
        [imgView setImage:[UIImage imageNamed:@"pic_xueya_ceshi"]];
        [bottomView addSubview:imgView];
        
        _measureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_measureButton.layer setMasksToBounds:YES];
        [_measureButton.layer setCornerRadius:5.0];
        [_measureButton setTitle:@"开始" forState:UIControlStateNormal];
        [_measureButton setBackgroundColor:[UIColor mainThemeColor]];
        [_measureButton.titleLabel setFont: [UIFont font_30]];
        [_measureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_measureButton];
        //[measureButton addTarget:self action:@selector(buttonStateChange) forControlEvents:UIControlEventTouchUpInside];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)setHeartValue:(NSString *)heartValue
{
    [lbheartValue setText:heartValue];
}

- (void)setHeartImageAnimationPlay
{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath =@"transform.scale";
    animation.fromValue = [NSNumber numberWithFloat:0.8];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = NSNotFound;
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation, nil]];
    [_heartImage.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void)subviewsLayout
{
    [heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(75);
    }];
    
    [_heartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(heartView);
        make.centerX.mas_equalTo(heartView).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(50, 42));
    }];
    
    [lbheartValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(heartView);
        make.left.equalTo(_heartImage.mas_right).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heartView.mas_bottom).with.offset(5);
        make.width.and.bottom.equalTo(self);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DeviceHomePageImg_Width, DeviceHomePageImg_Height));
    }];
    
    [_measureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).with.offset(40);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(45);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
