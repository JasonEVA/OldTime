//
//  ECGResultView.m
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGResultView.h"

@interface ECGResultView ()
{
    UIView* conclusionview;
    UIImageView* ivIcon;
    UILabel* lbConclusion;
    
    UILabel* lbSuggestion;
    
    UILabel* lbResponsibility;
}
@end

@implementation ECGResultView

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
        [lbResponsibility setText:@"*任何关于疾病的建议都不能替代执业医师的面对面诊断。请谨慎参阅，本应用不承担由此引起的法律责任。"];
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn.layer setMasksToBounds:YES];
        [_detailBtn.layer setCornerRadius:5.0];
        [_detailBtn setTitle:@"详细心电图" forState:UIControlStateNormal];
        [_detailBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_detailBtn.titleLabel setFont: [UIFont font_30]];
        [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_detailBtn];
        
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
    
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(45);
        make.top.equalTo(lbResponsibility.mas_top).with.offset(-80);
    }];
}

- (void) setDetectResult:(HeartRateDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    if (result.isXD) {
        [lbSuggestion setText:result.symptom];
    }
    else{
        [lbSuggestion setText:result.userAlertResult];
    }
}

@end
