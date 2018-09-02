//
//  BodyWeightResultView.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightResultView.h"

@interface BodyWeightResultView ()
{
    UILabel* lbWeight;
    UILabel* lbBodyWeight;
    UILabel* lbHegiht;
    UILabel* lbBodyHeight;
    
    UIView* bmiview;
    UIImageView* ivBMI;
    UILabel* lbBMI;
    UILabel* lbBodyBMI;
    
    UIView* colorview;
    NSMutableArray* lbColors;
    NSMutableArray* numlables;
}
@end

@implementation BodyWeightResultView

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
        
        lbWeight = [[UILabel alloc]init];
        [self addSubview:lbWeight];
        [lbWeight setFont:[UIFont systemFontOfSize:13]];
        [lbWeight setTextColor:[UIColor commonGrayTextColor]];
        [lbWeight setText:@"体重:"];
        
        lbBodyWeight = [[UILabel alloc]init];
        [self addSubview:lbBodyWeight];
        [lbBodyWeight setFont:[UIFont boldSystemFontOfSize:20]];
        [lbBodyWeight setTextColor:[UIColor commonGreenColor]];
        [lbBodyWeight setText:@"0.0Kg"];
        
        lbHegiht = [[UILabel alloc]init];
        [self addSubview:lbHegiht];
        [lbHegiht setFont:[UIFont systemFontOfSize:13]];
        [lbHegiht setTextColor:[UIColor commonGrayTextColor]];
        [lbHegiht setText:@"身高:"];
        
        lbBodyHeight = [[UILabel alloc]init];
        [self addSubview:lbBodyHeight];
        [lbBodyHeight setFont:[UIFont boldSystemFontOfSize:20]];
        [lbBodyHeight setTextColor:[UIColor commonGreenColor]];
        [lbBodyHeight setText:@"0.0cm"];
        
        bmiview = [[UIView alloc]init];
        [self addSubview:bmiview];
        [bmiview setBackgroundColor:[UIColor clearColor]];
        
        ivBMI = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_weightbmi"]];
        [bmiview addSubview:ivBMI];

        lbBMI = [[UILabel alloc]init];
        [bmiview addSubview:lbBMI];
        [lbBMI setFont:[UIFont systemFontOfSize:10]];
        [lbBMI setTextColor:[UIColor whiteColor]];
        [lbBMI setText:@"BMI"];
        
        lbBodyBMI = [[UILabel alloc]init];
        [bmiview addSubview:lbBodyBMI];
        [lbBodyBMI setFont:[UIFont systemFontOfSize:16]];
        [lbBodyBMI setTextColor:[UIColor whiteColor]];
        
        colorview = [[UIView alloc]init];
        [self addSubview:colorview];
        colorview.layer.cornerRadius = 2.5;
        colorview.layer.masksToBounds = YES;
        
        [colorview setBackgroundColor:[UIColor grayColor]];
        
        lbColors = [NSMutableArray array];
        NSArray* conclusions = @[@"过轻", @"正常", @"过重", @"肥胖", @"非常肥胖"];
        NSArray* conclusionColor = @[[UIColor commonBlueColor], [UIColor commonGreenColor], [UIColor commonOrangeColor], [UIColor commonVioletColor], [UIColor commonRedColor]];
        
        for (NSInteger index = 0; index < conclusions.count; ++index)
        {
            NSString* conclusion = conclusions[index];
            UIColor* bgColor = conclusionColor[index];
            UILabel* lbConclusion = [[UILabel alloc]init];
            [lbConclusion setBackgroundColor:bgColor];
            [lbConclusion setTextColor:[UIColor whiteColor]];
            [lbConclusion setTextAlignment:NSTextAlignmentCenter];
            [lbConclusion setFont:[UIFont systemFontOfSize:10]];
            [lbConclusion setText:conclusion];
            [lbColors addObject:lbConclusion];
            
            [colorview addSubview:lbConclusion];
        }
        
        numlables = [NSMutableArray array];
        NSArray* numtexts = @[@"0", @"18.5", @"25", @"28", @"32", @"200"];
        for (NSInteger index = 0; index < numtexts.count; ++index)
        {
            NSString* numtext = numtexts[index];
            UILabel* lbtext = [[UILabel alloc]init];
            [lbtext setBackgroundColor:[UIColor clearColor]];
            [lbtext setTextColor:[UIColor commonLightGrayTextColor]];
            [lbtext setTextAlignment:NSTextAlignmentCenter];
            [lbtext setFont:[UIFont systemFontOfSize:10]];
            [lbtext setText:numtext];
            [self addSubview:lbtext];
            [numlables addObject:lbtext];
        }
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.height.mas_equalTo(@17);
        make.bottom.equalTo(self.mas_top).with.offset(32);
    }];
    
    [lbBodyWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbWeight.mas_right).with.offset(3);
        make.height.mas_equalTo(@26);
        make.bottom.equalTo(lbWeight).with.offset(3);
        make.right.lessThanOrEqualTo(lbHegiht.mas_left).with.offset(-8);
    }];
    
    [lbHegiht mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self).with.offset(115);
        make.height.mas_equalTo(@17);
        make.top.equalTo(lbWeight);
    }];
    
    [lbBodyHeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHegiht.mas_right).with.offset(3);
        make.height.mas_equalTo(@26);
        make.bottom.equalTo(lbWeight).with.offset(3);
        
    }];
    
    
    
    [colorview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.bottom.equalTo(self).with.offset(-36);
        make.height.mas_equalTo(@17.5);
    }];
    
    for (NSInteger index = 0; index < lbColors.count; ++index)
    {
        UILabel* lbConclusion = lbColors[index];
        NSInteger nextIndex = index + 1;
        if (nextIndex == lbColors.count)
        {
            nextIndex = 0;
        }
        UILabel* lbNext = lbColors[nextIndex];
        
        [lbConclusion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(colorview);
            make.width.equalTo(lbNext);
            if (0 == nextIndex) {
                make.right.equalTo(colorview);
            }
            else
            {
                make.right.equalTo(lbNext.mas_left);
                if (0 == index)
                {
                    make.left.equalTo(colorview);
                }
            }
        }];
    }
    
    for (NSInteger index = 0; index < numlables.count; ++index)
    {
        UILabel* lbNum = [numlables objectAtIndex:index];
        UILabel* lbConclusion = [lbColors lastObject];
        
        if (0 == index)
        {
            lbConclusion = [lbColors firstObject];
            [lbNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbConclusion.mas_bottom);
                make.left.equalTo(lbConclusion);
            }];
            continue;
        }
        
        if (index >= lbColors.count)
        {
            [lbNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbConclusion.mas_bottom);
                make.right.equalTo(lbConclusion);
            }];
            continue;
        }

        lbConclusion = [lbColors objectAtIndex:index];
        [lbNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbConclusion.mas_bottom);
            make.centerX.equalTo(lbConclusion.mas_left);
        }];
    }
    
    //UILabel* lbConclusion = [lbColors objectAtIndex:1];
    [bmiview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 70));
        //make.centerX.equalTo(lbConclusion);
        make.bottom.equalTo(colorview.mas_top).with.offset(-2.5);
    }];
    
    [ivBMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(bmiview);
        make.top.and.left.equalTo(bmiview);
    }];
    
    [lbBMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bmiview);
        make.top.equalTo(bmiview).with.offset(8);
    }];
    
    [lbBodyBMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bmiview);
        make.top.equalTo(lbBMI.mas_bottom).with.offset(3);
    }];
}

- (void) setDetectResult:(BodyWeightDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    [lbBodyWeight setText:[NSString stringWithFormat:@"%.1fKg", result.dataDets.TZ_SUB]];
    [lbBodyHeight setText:[NSString stringWithFormat:@"%.1fcm", result.bodyHeight * 100]];
    [lbBodyBMI setText:[NSString stringWithFormat:@"%.1f", result.bodyBMI]];
    
    UIImage* imgBMI = nil;
    NSInteger bmiIndex = 1;
   
    if (result.bodyBMI < 18.5)
    {
        bmiIndex = 0;
        imgBMI = [UIImage imageNamed:@"ic_weightbmi_blue"];
    }
    else if (result.bodyBMI < 25)
    {
        bmiIndex = 1;
        imgBMI = [UIImage imageNamed:@"ic_weightbmi_green"];
    }
    else if (result.bodyBMI < 28)
    {
        bmiIndex = 2;
        imgBMI = [UIImage imageNamed:@"ic_weightbmi_orange"];
    }
    else if (result.bodyBMI < 32)
    {
        bmiIndex = 3;
        imgBMI = [UIImage imageNamed:@"ic_weightbmi_violet"];
    }
    else
    {
        bmiIndex = 4;
        imgBMI = [UIImage imageNamed:@"ic_weightbmi_red"];
    }
    
    UILabel* lbConclusion = [lbColors objectAtIndex:bmiIndex];
    if (!lbConclusion) {
        return;
    }
    
    [ivBMI setImage:imgBMI];
    [bmiview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lbConclusion);
    }];
}

@end
