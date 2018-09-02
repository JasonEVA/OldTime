//
//  BloodOxygenResultView.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenResultView.h"
#define BloodOxygenResultImg_Width 350.0/375.0*ScreenWidth

@interface BloodOxygenResultView ()
{
    UILabel *SpO2Value;
    UIImageView *PRicon;
    UILabel *lbPulseRate;
    UILabel *lbPulseRateValue;
    UIImageView *PIicon;
    UILabel *lbpi;
    UILabel *lbpiValue;
    
    UIImageView *resultImage;
    UIImageView *resultIcon;
    UILabel *lbBloodOxygenValue;
    

    UIView* colorsview;
    NSMutableArray* standandviews;
    NSMutableArray* standandLables;
    NSMutableArray* standandValueLables;
    
    UIView* valueView;
    UIImageView* ivValue;
    UILabel* lbValue;
}
@end

@implementation BloodOxygenResultView


- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        PRicon = [[UIImageView alloc] init];
        [self addSubview:PRicon];
        [PRicon setImage:[UIImage imageNamed:@"icon_blood_34"]];
        
        lbPulseRate = [[UILabel alloc]init];
        [self addSubview:lbPulseRate];
        [lbPulseRate setFont:[UIFont systemFontOfSize:13]];
        [lbPulseRate setTextColor:[UIColor commonGrayTextColor]];
        [lbPulseRate setText:@"脉率:"];
        
        lbPulseRateValue = [[UILabel alloc]init];
        [self addSubview:lbPulseRateValue];
        [lbPulseRateValue setFont:[UIFont boldSystemFontOfSize:20]];
        [lbPulseRateValue setTextColor:[UIColor commonGreenColor]];
        [lbPulseRateValue setText:@"100"];
        
        PIicon = [[UIImageView alloc] init];
        [self addSubview:PIicon];
        [PIicon setImage:[UIImage imageNamed:@"icon_blood_35"]];
        
        lbpi = [[UILabel alloc]init];
        [self addSubview:lbpi];
        [lbpi setFont:[UIFont systemFontOfSize:13]];
        [lbpi setTextColor:[UIColor commonGrayTextColor]];
        [lbpi setText:@"灌注指数:"];
        
        lbpiValue = [[UILabel alloc]init];
        [self addSubview:lbpiValue];
        [lbpiValue setFont:[UIFont boldSystemFontOfSize:20]];
        [lbpiValue setTextColor:[UIColor commonGreenColor]];
        [lbpiValue setText:@"5"];
        
        colorsview = [[UIView alloc]init];
        [self addSubview:colorsview];
        colorsview.layer.cornerRadius = 2.5;
        colorsview.layer.masksToBounds = YES;
        
        
        standandviews = [NSMutableArray array];
        NSArray* colors = @[[UIColor commonBlueColor], [UIColor mainThemeColor], [UIColor commonGreenColor], [UIColor commonGreenColor]];
        for (UIColor* bgColor in colors)
        {
            UIView* vStandand = [[UIView alloc]init];
            [colorsview addSubview:vStandand];
            [vStandand setBackgroundColor:bgColor];
            
            [standandviews addObject:vStandand];
        }
        
        standandLables = [NSMutableArray array];
        NSArray* standandNames = @[@"偏低", @"氧失饱和", @"正常"];
        for (NSString* name in standandNames)
        {
            UILabel* lbStandand = [[UILabel alloc]init];
            [colorsview addSubview:lbStandand];
            [lbStandand setText:name];
            [lbStandand setTextColor:[UIColor whiteColor]];
            [lbStandand setFont:[UIFont systemFontOfSize:10]];
            [lbStandand setBackgroundColor:[UIColor clearColor]];
            [lbStandand setTextAlignment:NSTextAlignmentCenter];
            [standandLables addObject:lbStandand];
        }
        
        standandValueLables = [NSMutableArray array];
        NSArray* standandValues = @[@"", @"90%", @"94%", @""];
        for (NSString* value in standandValues)
        {
            UILabel* lbStandand = [[UILabel alloc]init];
            [self addSubview:lbStandand];
            [lbStandand setText:value];
            [lbStandand setTextColor:[UIColor commonLightGrayTextColor]];
            [lbStandand setFont:[UIFont systemFontOfSize:10]];
            [lbStandand setBackgroundColor:[UIColor clearColor]];
            [lbStandand setTextAlignment:NSTextAlignmentCenter];
            [standandValueLables addObject:lbStandand];
        }
        
        valueView = [[UIView alloc]init];
        [self addSubview:valueView];
        
        ivValue = [[UIImageView alloc]init];
        [valueView addSubview:ivValue];
        
        lbValue = [[UILabel alloc]init];
        [valueView addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setTextColor:[UIColor whiteColor]];
        [lbValue setFont:[UIFont boldSystemFontOfSize:18]];

        [self subViewsLayout];
    }
    return self;
}

- (void) subViewsLayout
{
    [PRicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.bottom.equalTo(self.mas_top).with.offset(32);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [lbPulseRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(PRicon.mas_right).with.offset(3);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(self.mas_top).with.offset(32);
    }];
    
    [lbPulseRateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPulseRate.mas_right).with.offset(3);
        make.height.mas_equalTo(26);
        make.bottom.equalTo(lbPulseRate).with.offset(3);
    }];
    
    
    [PIicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPulseRateValue.mas_right).with.offset(30);
        make.bottom.equalTo(self.mas_top).with.offset(32);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [lbpi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(PIicon.mas_right).with.offset(3);
        make.height.mas_equalTo(17);
        make.top.equalTo(lbPulseRate);
    }];
    
    [lbpiValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbpi.mas_right).with.offset(3);
        make.height.mas_equalTo(@26);
        make.bottom.equalTo(lbpi).with.offset(3);
        
    }];
    
    [resultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(BloodOxygenResultImg_Width, 35));
    }];
    
    [colorsview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(@18);
        make.top.equalTo(self).with.offset(120);
    }];
    
    for (NSInteger index = 0; index < standandviews.count; ++index)
    {
        UIView* vStandand = standandviews[index];
        NSInteger nextIndex = index + 1;
        if (nextIndex >= standandviews.count)
        {
            nextIndex = 0;
        }
        UIView* vNext = standandviews[nextIndex];
        
        [vStandand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(colorsview);
            make.height.equalTo(colorsview);
            make.width.equalTo(vNext);
            if (0 == index)
            {
                make.left.equalTo(colorsview);
            }
            if (0 != nextIndex)
            {
                make.right.equalTo(vNext.mas_left);
            }
            else
            {
                make.right.equalTo(colorsview);
            }
        }];
    }
    
    for (NSInteger index = 0; index < standandLables.count; ++index)
    {
        UILabel* lbStandand = standandLables[index];
        UIView* vStandand = standandviews[index];
        [lbStandand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.top.equalTo(colorsview);
            make.left.equalTo(vStandand);
            if (index < standandLables.count - 1)
            {
                make.right.equalTo(vStandand);
            }
            else
            {
                make.right.equalTo(colorsview);
            }
        }];
    }
    
    for (NSInteger index = 0; index < standandValueLables.count; ++index)
    {
        UILabel* lbStandand = standandValueLables[index];
        UIView* vStandand = standandviews[index];
        [lbStandand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(colorsview.mas_bottom).with.offset(2);
            make.height.mas_equalTo(14);
            if (0 == index)
            {
                make.left.equalTo(colorsview);
            }
            else if (index == standandValueLables.count - 1)
            {
                make.right.equalTo(colorsview);
            }
            else
            {
                make.centerX.equalTo(vStandand.mas_left);
            }
        }];
    }
    
    [valueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 70));
        make.bottom.equalTo(colorsview.mas_top).with.offset(-2);
    }];
    
    [ivValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(valueView);
        make.center.equalTo(valueView);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(valueView);
        make.top.equalTo(valueView).with.offset(18);
    }];

}

- (void) setDetectResult:(BloodOxygenationResult*) result
{
    if (!result) {
        return;
    }
   
    [lbPulseRateValue setText:[NSString stringWithFormat:@"%ld",result.dataDets.PULSE_RATE]];
    [lbpiValue setText:[NSString stringWithFormat:@"%ld",result.dataDets.PI_VAL]];
    
    [lbValue setText:[NSString stringWithFormat:@"%ld％", result.dataDets.OXY_SUB]];
    //NSInteger index = 0;
    if (90 > result.dataDets.OXY_SUB)
    {
        [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_blue"]];
        UIView* standandview = standandviews[0];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
    }
    else if (94 > result.dataDets.OXY_SUB)
    {
        [ivValue setImage:[UIImage imageNamed:@"icon_43"]];
        UIView* standandview = standandviews[1];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
        
    }
    else
    {
        [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
        UIView* standandview = standandviews[2];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
        
    }
}


@end
