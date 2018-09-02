//
//  BreathingResultView.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingResultView.h"

@interface BreathingResultView ()
{
    UIView* conclusionview;
    UIImageView* ivIcon;
    UILabel* lbTitle;
    
    UILabel* lbResult;
}

@end

@implementation BreathingResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        conclusionview = [[UIView alloc]init];
        [self addSubview:conclusionview];
        
        /*ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_s"]];
        [conclusionview addSubview:ivIcon];*/
        
        lbTitle = [[UILabel alloc]init];
        [conclusionview addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor mainThemeColor]];
        [lbTitle setFont:[UIFont boldFont_32]];
        [lbTitle setText:@"健康评估"];
        
        lbResult = [[UILabel alloc]init];
        [conclusionview addSubview:lbResult];
        [lbResult setTextColor:[UIColor commonTextColor]];
        [lbResult setFont:[UIFont font_28]];
        [lbResult setNumberOfLines:0];
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [conclusionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);
    }];
    
    /*[ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(conclusionview);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.and.bottom.equalTo(conclusionview);
    }];*/
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(conclusionview);
        make.centerY.equalTo(conclusionview);
        make.height.equalTo(conclusionview);
    }];
    
    [lbResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(conclusionview.mas_bottom).with.offset(7.5);
        make.bottom.lessThanOrEqualTo(self).with.offset(-7.5);
    }];
}

- (void) setDetectResult:(DetectResult*) detectResult
{
    if (!detectResult || ![detectResult isKindOfClass:[BreathingDetctResult class]]) {
        return;
    }
    BreathingDetctResult* breathResult = (BreathingDetctResult*) detectResult;
    
    [lbResult setText:breathResult.userAlertResult];
}

@end
