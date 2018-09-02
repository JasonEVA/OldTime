//
//  BraceletScanView.m
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletScanView.h"

@interface BraceletScanView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *searchImgView;
@end

@implementation BraceletScanView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        [self.imgView setImage:[UIImage imageNamed:@"icon_shouhuan_search"]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        
        self.scanLb = [[UILabel alloc] init];
        [self addSubview:self.scanLb];
        [self.scanLb setText:@"搜索中…"];
        [self.scanLb setTextColor:[UIColor commonTextColor]];
        [self.scanLb setFont:[UIFont font_26]];
        [self.scanLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
        self.searchImgView = [[UIImageView alloc] init];
        [self addSubview:self.searchImgView];
        [self startConnectAnimationPlay];
        [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.scanLb.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(75, 24));
        }];
        
        self.reScanBtn = [[UIButton alloc] init];
        [self addSubview:self.reScanBtn];
        [self.reScanBtn setHidden:YES];
        [self.reScanBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
        [self.reScanBtn.titleLabel setFont:[UIFont font_28]];
        [self.reScanBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self.reScanBtn setBackgroundColor:[UIColor whiteColor]];
        [self.reScanBtn.layer setCornerRadius:5.0f];
        [self.reScanBtn.layer setMasksToBounds:YES];
        [self.reScanBtn.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [self.reScanBtn.layer setBorderWidth:1.0f];
        [self.reScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.scanLb.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(100*kScreenScale, 35));
        }];
    }
    return self;
}


- (void)startConnectAnimationPlay
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 1; i<=4; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_shouhuan_search%d",i]];
        [array addObject:img];
    }
    //animationImages动画图片数组，数组中存放的必须是UIImage。
    self.searchImgView.animationImages = array;
    
    //设置单次动画的持续时间(从第一张播放到最后一张的时间)
    self.searchImgView.animationDuration = 2;
    
    //设置动画的播放次数。0表示无限播放。
    self.searchImgView.animationRepeatCount = 0;
    
    //开始动画
    [self.searchImgView startAnimating];
}

- (void)setBracelectViewWithImage:(NSString *)image promptMsg:(NSString *)msg{
    [self.imgView setImage:[UIImage imageNamed:image]];
    [self.scanLb setText:msg];
}

@end
