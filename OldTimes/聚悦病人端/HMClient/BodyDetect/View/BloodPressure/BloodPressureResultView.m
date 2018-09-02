//
//  BloodPressureResultView.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureResultView.h"

@interface BloodPressureValueView ()
{
    UILabel *lbName;
    UILabel *lbSubname;
    UILabel *lbValue;
    UILabel *lbunit;
    UIView *middlelineView;
}
@property (nonatomic,strong) UIView *lineView;

- (void) setValueString:(NSString*) aValue;

@end

@implementation BloodPressureValueView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setFont:[UIFont systemFontOfSize:18]];
        [lbName setTextColor:[UIColor colorWithHexString:@"666666"]];
        [lbName setTextAlignment:NSTextAlignmentCenter];
        
        lbSubname = [[UILabel alloc] init];
        [self addSubview:lbSubname];
        [lbSubname setFont:[UIFont font_26]];
        [lbSubname setTextColor:[UIColor commonGrayTextColor]];
        [lbSubname setTextAlignment:NSTextAlignmentCenter];
        
        middlelineView = [[UIView alloc] init];
        [middlelineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:middlelineView];
        
        lbValue = [[UILabel alloc] init];
        [self addSubview:lbValue];
        [lbValue setText:@"0"];
        [lbValue setFont:[UIFont systemFontOfSize:45]];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setTextAlignment:NSTextAlignmentRight];
        
        lbunit = [[UILabel alloc] init];
        [self addSubview:lbunit];
        [lbunit setText:@"mmHg"];
        [lbunit setFont:[UIFont font_26]];
        [lbunit setTextColor:[UIColor commonGrayTextColor]];
        
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:_lineView];

        
        [self subViewsLayout];
    }
    
    return self;
}

- (void)subViewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(7);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    [lbSubname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbName.mas_bottom);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [middlelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right).with.offset(10);
        make.top.equalTo(self);
        make.width.mas_equalTo(1);
        make.height.equalTo(self);
    }];
    
    [lbunit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(lbSubname.mas_bottom);
        make.height.mas_equalTo(@25);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbunit.mas_left).with.offset(-5);
        make.bottom.equalTo(lbunit.mas_bottom);
        make.height.mas_equalTo(@40);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.width.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setName:(NSString *)aName subName:(NSString *)subName unit:(NSString*)unit
{
    [lbName setText:aName];
    [lbSubname setText:subName];
    [lbunit setText:unit];
}

- (void) setValueString:(NSString*) aValue
{
    [lbValue setText:aValue];
}

//更新布局
- (void)updateViewConstraints
{
    [lbName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(18);
    }];
}


@end



@interface BloodPressureResultView ()
{
    UIImageView *colorImage;
    UILabel *lbresultTitle;
    UIView *toplineView;
    UIView *rightlineView;
    UIView *bottomlineView;
    
    BloodPressureValueView *sysValueView;
    BloodPressureValueView *diaValueView;
    BloodPressureValueView *heartRateValueView;
}

@end

@implementation BloodPressureResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        colorImage = [[UIImageView alloc] init];
        [colorImage setImage:[UIImage imageNamed:@"bg_xueya_result"]];
        [self addSubview:colorImage];
        
        toplineView = [[UIView alloc] init];
        [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:toplineView];
        
        rightlineView = [[UIView alloc] init];
        [rightlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:rightlineView];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];
        
        lbresultTitle = [[UILabel alloc] init];
        [lbresultTitle setText:@"测量结果:"];
        [lbresultTitle setFont:[UIFont font_28]];
        [lbresultTitle setTextColor:[UIColor commonLightGrayTextColor]];
        [self addSubview:lbresultTitle];
        
        sysValueView = [[BloodPressureValueView alloc] init];
        [self addSubview:sysValueView];
        [sysValueView setName:@"平均收缩压" subName:@"(高压)" unit:@"mmHg"];

        diaValueView = [[BloodPressureValueView alloc] init];
        [self addSubview:diaValueView];
        [diaValueView setName:@"平均舒张压" subName:@"(低压)" unit:@"mmHg"];
        
        heartRateValueView = [[BloodPressureValueView alloc] init];
        [self addSubview:heartRateValueView];
        [heartRateValueView setName:@"平均心率" subName:@"" unit:@"次/分钟"];
        [heartRateValueView.lineView setHidden:YES];
        
        [diaValueView updateViewConstraints];
        [heartRateValueView updateViewConstraints];
        
        [self subViewsLayout];
        
    }
    return self;
}

- (void)subViewsLayout
{
    [colorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(self).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(14, 249));
    }];
    
    [toplineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right);
        make.top.equalTo(colorImage.mas_top).with.offset(1);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(1);
    }];
    
    [rightlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toplineView.mas_right);
        make.top.equalTo(toplineView.mas_top);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(colorImage.mas_bottom).with.offset(-1);
    }];
    
    [bottomlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right);
        make.top.equalTo(colorImage.mas_bottom).with.offset(-1);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(1);
    }];
    
    [lbresultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right).with.offset(14);
        make.top.equalTo(self).with.offset(28);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [sysValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right).with.offset(14);
        make.top.equalTo(lbresultTitle.mas_bottom).with.offset(20);
        make.height.mas_equalTo(57.5);
        make.width.mas_equalTo(OBJWidth(290));
    }];
    
    [diaValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right).with.offset(14);
        make.top.equalTo(sysValueView.mas_bottom);
        make.height.mas_equalTo(69.5);
        make.width.mas_equalTo(OBJWidth(290));
    }];
    
    [heartRateValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImage.mas_right).with.offset(14);
        make.top.equalTo(diaValueView.mas_bottom);
        make.height.mas_equalTo(57.5);
        make.width.mas_equalTo(OBJWidth(290));
    }];
}

- (void) setDetectResult:(BloodPressureDetectResult*) result
{
    [sysValueView setValueString:[NSString stringWithFormat:@"%ld", result.dataDets.SSY]];
    [diaValueView setValueString:[NSString stringWithFormat:@"%ld", result.dataDets.SZY]];
    [heartRateValueView setValueString:[NSString stringWithFormat:@"%ld", result.dataDets.XL_OF_XY]];
}

@end
