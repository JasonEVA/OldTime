//
//  BloodSugarResultView.m
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarResultView.h"

@interface BloodSugarResultView ()
{
    UIView* colorview;
    
    NSMutableArray* colorviews;
    
    UIView* valueView;
    UIImageView* ivValue;
    UILabel* lbUnit;
    UILabel* lbValue;
    NSMutableArray* standardLables;
    
    UILabel* lbConclusion;  //结论
}
@end

@implementation BloodSugarResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        colorview = [[UIView alloc]init];
        [self addSubview:colorview];
        [colorview.layer setCornerRadius:2.5];
        colorview.layer.masksToBounds = YES;
        
        [self subviewLayout];
        
        colorviews = [NSMutableArray array];
        
//        NSArray* colors = @[[UIColor commonBlueColor], [UIColor commonGreenColor], [UIColor commonOrangeColor], [UIColor commonVioletColor], [UIColor commonRedColor]];
//        NSArray* standands = @[@"偏低", @"正常", @"偏高", @"中度", @"重度"];
//        for (NSInteger index = 0; index < colors.count; ++index)
//        {
//            UIColor* color = [colors objectAtIndex:index];
//            UILabel* lbStandand = [[UILabel alloc]init];
//            [lbStandand setText:standands[index]];
//            [lbStandand setFont:[UIFont systemFontOfSize:9]];
//            [lbStandand setTextColor:[UIColor whiteColor]];
//            [lbStandand setTextAlignment:NSTextAlignmentCenter];
//            
//            [colorview addSubview:lbStandand];
//            [colorviews addObject:lbStandand];
//            [lbStandand setBackgroundColor:color];
//        }
        
        valueView = [[UIView alloc]init];
        [self addSubview:valueView];
        
        ivValue = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
        [valueView addSubview:ivValue];
        
        lbUnit = [[UILabel alloc]init];
        [valueView addSubview:lbUnit];
        [lbUnit setBackgroundColor:[UIColor clearColor]];
        [lbUnit setTextColor:[UIColor whiteColor]];
        [lbUnit setFont:[UIFont systemFontOfSize:9]] ;
        [lbUnit setText:@"mmol/L"];
        
        lbValue = [[UILabel alloc]init];
        [valueView addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setTextColor:[UIColor whiteColor]];
        [lbValue setFont:[UIFont boldSystemFontOfSize:18]] ;
        
        
        standardLables = [NSMutableArray array];
//        NSArray* standards = @[@"0", @"2.78", @"6.7", @"9.4", @"11.1", @"30"];
//        for (NSString* standand in standards)
//        {
//            UILabel* lbStandand = [[UILabel alloc]init];
//            [self addSubview:lbStandand];
//            [lbStandand setFont:[UIFont systemFontOfSize:9]];
//            [lbStandand setTextColor:[UIColor commonGrayTextColor]];
//            [lbStandand setText:standand];
//            [standardLables addObject:lbStandand];
//        }
        
        lbConclusion = [[UILabel alloc]init];
        [self addSubview:lbConclusion];
        [lbConclusion setBackgroundColor:[UIColor clearColor]];
        [lbConclusion setTextColor:[UIColor commonTextColor]];
        [lbConclusion setFont:[UIFont systemFontOfSize:14]] ;
        [lbConclusion setNumberOfLines:0];
        [lbConclusion setTextAlignment:NSTextAlignmentCenter];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [colorview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(@18.5);
        make.top.equalTo(self).with.offset(93);
    }];
    
    [valueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 70));
        //make.centerX.equalTo(self);
        make.bottom.equalTo(colorview.mas_top).with.offset(-2);
    }];
    
    [ivValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(valueView);
        make.size.equalTo(valueView);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(valueView);
        make.top.equalTo(valueView).with.offset(32);
        make.height.mas_equalTo(@12);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(valueView);
        make.bottom.equalTo(lbUnit.mas_top);
        make.height.mas_equalTo(@21);
    }];

    [lbConclusion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(colorview);
        make.top.equalTo(colorview.mas_bottom).with.offset(20);
        make.bottom.lessThanOrEqualTo(self);
    }];
}

- (void) setDetectResult:(BloodSugarDetectResult*) result
{
    [lbValue setText:[NSString stringWithFormat:@"%.1f", result.bloodSugar]];
    [lbConclusion setText:result.userAlertResult];
    
    NSArray* colors;
    NSArray* standands;
    NSArray* standards;
    
    NSInteger index = 0;
    //血糖两套规则
    // || [result.dataDets.kpiCode isEqualToString:@"XT_BKF_AFT"] || [result.dataDets.kpiCode isEqualToString:@"XT_LUNCH_AFT"] || [result.dataDets.kpiCode isEqualToString:@"XT_NIG_AFT"]
    if ([result.dataDets.kpiCode isEqualToString:@"XT_AFT"]) {
        //餐后对应规则
        colors = @[[UIColor colorWithHexString:@"6f8ae3"], [UIColor commonBlueColor], [UIColor commonGreenColor], [UIColor commonOrangeColor], [UIColor commonRedColor]];
        standands = @[@"过低", @"偏低", @"正常", @"偏高", @"过高"];
        standards = @[@"0", @"2.78", @"3.9", @"7.8", @"11.1"];
        
        if (result.bloodSugar <= [[standards objectAtIndex:1] floatValue])
        {
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_greyViolet"]];
            index = 0;
        }
        else if (result.bloodSugar <= [[standards objectAtIndex:2] floatValue])
        {
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_blue"]];
            index = 1;
        }
        else if (result.bloodSugar < [[standards objectAtIndex:3] floatValue])
        {
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
            index = 2;
        }
        else if (result.bloodSugar <= [[standards objectAtIndex:4] floatValue])
        {
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_orange"]];
            index = 3;
        }
        else
        {
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_red"]];
            index = 4;
        }
    }
    else{
        //空腹血糖规则
        colors = @[[UIColor colorWithHexString:@"6f8ae3"], [UIColor commonBlueColor], [UIColor commonGreenColor], [UIColor commonOrangeColor], [UIColor commonVioletColor], [UIColor commonRedColor]];
        standands = @[@"过低", @"偏低", @"正常", @"正常偏高", @"偏高", @"过高"];
        standards = @[@"0", @"2.78", @"3.9", @"6.1", @"6.7",@"11.1"];
        
        NSLog(@"%f %f",result.bloodSugar,[[standards objectAtIndex:5] floatValue]);
        if (result.bloodSugar <= [[standards objectAtIndex:1] floatValue]){
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_greyViolet"]];
            index = 0;
        }
        else if (result.bloodSugar <= [[standards objectAtIndex:2] floatValue]){
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_blue"]];
            index = 1;
        }
        else if (result.bloodSugar < [[standards objectAtIndex:3] floatValue]){
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
            index = 2;
        }
        else if (result.bloodSugar < [[standards objectAtIndex:4] floatValue]){
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_orange"]];
            index = 3;
        }
        else if (result.bloodSugar <= [[standards objectAtIndex:5] floatValue]){
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_violet"]];
            index = 4;
        }
        else{
            [ivValue setImage:[UIImage imageNamed:@"ic_weightbmi_red"]];
            index = 5;
        }
    }
    [self initWithColors:colors standands:standands standards:standards];
    
    
    UIView* vColor = [colorviews objectAtIndex:index];
    [valueView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vColor);
    }];
}

- (void)initWithColors:(NSArray *)colors standands:(NSArray *)standands standards:(NSArray *)standards
{
    
    for (NSInteger index = 0; index < colors.count; ++index)
    {
        UIColor* color = [colors objectAtIndex:index];
        UILabel* lbStandand = [[UILabel alloc]init];
        [lbStandand setText:standands[index]];
        [lbStandand setFont:[UIFont systemFontOfSize:9]];
        [lbStandand setTextColor:[UIColor whiteColor]];
        [lbStandand setTextAlignment:NSTextAlignmentCenter];
        
        [colorview addSubview:lbStandand];
        [colorviews addObject:lbStandand];
        [lbStandand setBackgroundColor:color];
    }
    
    for (NSString* standand in standards)
    {
        UILabel* lbStandand = [[UILabel alloc]init];
        [self addSubview:lbStandand];
        [lbStandand setFont:[UIFont systemFontOfSize:9]];
        [lbStandand setTextColor:[UIColor commonGrayTextColor]];
        [lbStandand setText:standand];
        [standardLables addObject:lbStandand];
    }
    
    [self updateLayout];
}

- (void)updateLayout
{
    for (NSInteger index = 0; index < colorviews.count; ++index)
    {
        UIView* vColor = colorviews[index];
        NSInteger nextIndex = index + 1;
        if (nextIndex >= colorviews.count)
        {
            nextIndex = 0;
        }
        UIView* nextView = colorviews[nextIndex];
        
        [vColor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(colorview);
            make.width.equalTo(nextView);
            if (0 == nextIndex) {
                make.right.equalTo(colorview);
            }
            else
            {
                make.right.equalTo(nextView.mas_left);
                if (0 == index)
                {
                    make.left.equalTo(colorview);
                }
            }
        }];
    }
    for (NSInteger index = 0; index < standardLables.count; ++index)
    {
        UILabel* lbStandand = [standardLables objectAtIndex:index];
        UIView* vColor = [colorviews lastObject];
        
        if (0 == index)
        {
            vColor = [colorviews firstObject];
            [lbStandand mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(vColor.mas_bottom);
                make.left.equalTo(vColor);
            }];
            continue;
        }
        
        if (index >= colorviews.count)
        {
            [lbStandand mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(vColor.mas_bottom);
                make.right.equalTo(vColor);
            }];
            continue;
        }
        
        vColor = [colorviews objectAtIndex:index];
        [lbStandand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vColor.mas_bottom);
            make.centerX.equalTo(vColor.mas_left);
        }];
    }
}

@end
