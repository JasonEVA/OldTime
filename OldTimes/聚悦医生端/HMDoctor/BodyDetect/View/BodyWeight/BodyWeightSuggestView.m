//
//  BodyWeightSuggestView.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightSuggestView.h"

@interface BodyWeightSuggestView ()
{
    UIView* conclusionview;
    UIImageView* ivIcon;
    UILabel* lbConclusion;
    
    UILabel* lbSuggestion;
    
    UILabel* lbResponsibility;
}
@end

@implementation BodyWeightSuggestView

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
        
        conclusionview = [[UIView alloc]init];
        [self addSubview:conclusionview];
        
        ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_s"]];
        [conclusionview addSubview:ivIcon];
        
        lbConclusion = [[UILabel alloc]init];
        [conclusionview addSubview:lbConclusion];
        [lbConclusion setTextColor:[UIColor mainThemeColor]];
        [lbConclusion setFont:[UIFont boldSystemFontOfSize:14]];
        [lbConclusion setText:@"测量结果"];
        
        lbSuggestion = [[UILabel alloc]init];
        [self addSubview:lbSuggestion];
        [lbSuggestion setTextColor:[UIColor commonTextColor]];
        [lbSuggestion setFont:[UIFont systemFontOfSize:13]];
        [lbSuggestion setTextAlignment:NSTextAlignmentCenter];
        [lbSuggestion setNumberOfLines:0];
        
        lbResponsibility = [[UILabel alloc]init];
        [self addSubview:lbResponsibility];
        [lbResponsibility setTextColor:[UIColor commonLightGrayTextColor]];
        [lbResponsibility setFont:[UIFont systemFontOfSize:11]];
        [lbResponsibility setNumberOfLines:0];
        [lbResponsibility setText:@"*任何关于疾病的建议都不能替代执业医师的面对面诊断。请谨慎参阅，本应用不承担由此引起的法律责任。"];
        
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

- (void) setDetectResult:(BodyWeightDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    [lbSuggestion setText:result.userAlertResult];
}

@end
