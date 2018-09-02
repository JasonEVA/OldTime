//
//  BloodOxygenSuggestView.m
//  HMClient
//
//  Created by lkl on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenSuggestView.h"

@interface BloodOxygenSuggestView ()
{
    UIView* conclusionview;
    UIImageView* ivIcon;
    UILabel* lbConclusion;
    
    UILabel* lbSuggestion;
    
    UILabel* lbResponsibility;
}
@end

@implementation BloodOxygenSuggestView


- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        conclusionview = [[UIView alloc]init];
        [self addSubview:conclusionview];
        
        ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_s"]];
        [conclusionview addSubview:ivIcon];
        
        lbConclusion = [[UILabel alloc]init];
        [conclusionview addSubview:lbConclusion];
        [lbConclusion setTextColor:[UIColor mainThemeColor]];
        [lbConclusion setFont:[UIFont boldFont_28]];
        [lbConclusion setText:@"测量结果"];
        
        lbSuggestion = [[UILabel alloc]init];
        [self addSubview:lbSuggestion];
        [lbSuggestion setTextColor:[UIColor commonTextColor]];
        [lbSuggestion setFont:[UIFont font_26]];
        [lbSuggestion setTextAlignment:NSTextAlignmentCenter];
        [lbSuggestion setNumberOfLines:0];
        
        lbResponsibility = [[UILabel alloc]init];
        [self addSubview:lbResponsibility];
        [lbResponsibility setTextColor:[UIColor commonLightGrayTextColor]];
        [lbResponsibility setFont:[UIFont font_22]];
        [lbResponsibility setNumberOfLines:0];
        [lbResponsibility setText:@"*小知识：灌注指数反映了脉动血流情况，可能受气温，精神状态影响。"];
        
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
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(conclusionview);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.and.bottom.equalTo(conclusionview);
    }];
    
    [lbConclusion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(4);
        make.right.equalTo(conclusionview);
        make.centerY.equalTo(conclusionview);
    }];
    
    [lbSuggestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        
        make.top.equalTo(conclusionview.mas_bottom).with.offset(6);
    }];
    
    
    [lbResponsibility mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(46);
        make.right.equalTo(self).with.offset(-46);
        make.bottom.equalTo(self).with.offset(-33);
    }];
}

- (void) setDetectResult:(BloodOxygenationResult*) result
{
    if (!result)
    {
        return;
    }
    
    [lbSuggestion setText:result.userAlertResult];
}

@end
