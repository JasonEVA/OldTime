//
//  ECGResultValueView.m
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGResultValueView.h"

@interface ECGResultValueView()
{
    UIView* colorsview;
    NSMutableArray* standandviews;
    NSMutableArray* standandLables;
    NSMutableArray* standandValueLables;
    
    UIView* valueView;
    UIImageView* ivValue;
    UILabel* lbValue;
}
@end

@implementation ECGResultValueView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        colorsview = [[UIView alloc]init];
        [self addSubview:colorsview];
        colorsview.layer.cornerRadius = 2.5;
        colorsview.layer.masksToBounds = YES;
        
        
        standandviews = [NSMutableArray array];
        NSArray* colors = @[[UIColor commonBlueColor], [UIColor commonGreenColor], [UIColor commonRedColor], [UIColor commonRedColor]];
        for (UIColor* bgColor in colors)
        {
            UIView* vStandand = [[UIView alloc]init];
            [colorsview addSubview:vStandand];
            [vStandand setBackgroundColor:bgColor];
            
            [standandviews addObject:vStandand];
        }
        
        standandLables = [NSMutableArray array];
        NSArray* standandNames = @[@"过缓", @"正常", @"过快"];
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
        NSArray* standandValues = @[@"0", @"60", @"100", @"200"];
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
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [colorsview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(@18);
        make.top.equalTo(self).with.offset(90);
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

- (void) setDetectResult:(HeartRateDetectResult*) result
{
    if (!result) {
        return;
    }

    NSInteger heartRate ;
    if (result.isXD) {
        [lbValue setText:[NSString stringWithFormat:@"%ld",result.heartRate]];
        heartRate = result.heartRate;
    }
    else{
        [lbValue setText:[NSString stringWithFormat:@"%ld",result.dataDets.XL_SUB]];
        heartRate = result.dataDets.XL_SUB;
    }
    
    //NSInteger index = 0;
    if (60 > heartRate)
    {
        [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_blue"]];
        UIView* standandview = standandviews[0];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
    }
    else if (100 > heartRate)
    {
        [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
        UIView* standandview = standandviews[1];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
        
    }
    else
    {
        [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_red"]];
        UIView* standandview = standandviews[2];
        
        [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(standandview);
        }];
        
    }
}

@end
