//
//  DetailECGResultView.m
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetailECGResultView.h"

@interface DetailECGResultView ()
{
    UILabel *lbHR;
    UILabel *lbHRValue;
    UILabel *lbRR;
    UILabel *lbRRValue;
    UILabel *lbQRS;
    UILabel *lbQRSValue;
    UILabel *lbtestTime;
    
    UIView *lineView;
    UIImageView *ivIcon;
    UILabel *lbConclusion;
    UILabel *lbResult;
}
@end

@implementation DetailECGResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbHR = [[UILabel alloc] init];
        [self addSubview:lbHR];
        [lbHR setText:@"心率:"];
        [lbHR setTextColor:[UIColor commonGrayTextColor]];
        [lbHR setFont:[UIFont systemFontOfSize:13]];
        
        lbHRValue = [[UILabel alloc] init];
        [self addSubview:lbHRValue];
        //[lbHRValue setText:@"100次/分"];
        [lbHRValue setTextColor:[UIColor commonGrayTextColor]];
        [lbHRValue setFont:[UIFont systemFontOfSize:13]];
        
        lbRR = [[UILabel alloc] init];
        [self addSubview:lbRR];
        [lbRR setText:@"RR:"];
        [lbRR setTextColor:[UIColor commonGrayTextColor]];
        [lbRR setFont:[UIFont systemFontOfSize:13]];
        
        lbRRValue = [[UILabel alloc] init];
        [self addSubview:lbRRValue];
        //[lbRRValue setText:@"600ms"];
        [lbRRValue setTextColor:[UIColor commonGrayTextColor]];
        [lbRRValue setFont:[UIFont systemFontOfSize:13]];
        
        lbQRS = [[UILabel alloc] init];
        [self addSubview:lbQRS];
        [lbQRS setText:@"QRS:"];
        [lbQRS setTextColor:[UIColor commonGrayTextColor]];
        [lbQRS setFont:[UIFont systemFontOfSize:13]];
        
        lbQRSValue = [[UILabel alloc] init];
        [self addSubview:lbQRSValue];
        //[lbQRSValue setText:@"80ms"];
        [lbQRSValue setTextColor:[UIColor commonGrayTextColor]];
        [lbQRSValue setFont:[UIFont systemFontOfSize:13]];
        
        lbtestTime = [[UILabel alloc] init];
        [self addSubview:lbtestTime];
        [lbtestTime setText:@"2016-05-04 15:13:20"];
        [lbtestTime setTextColor:[UIColor commonGrayTextColor]];
        [lbtestTime setFont:[UIFont systemFontOfSize:13]];
        
        lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        
        ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_s"]];
        [self addSubview:ivIcon];
        
        lbConclusion = [[UILabel alloc]init];
        [self addSubview:lbConclusion];
        [lbConclusion setTextColor:[UIColor mainThemeColor]];
        [lbConclusion setFont:[UIFont boldSystemFontOfSize:14]];
        [lbConclusion setText:@"测量结果:"];

        lbResult = [[UILabel alloc]init];
        [self addSubview:lbResult];
        [lbResult setText:@"长间歇"];
        [lbResult setTextColor:[UIColor commonTextColor]];
        [lbResult setFont:[UIFont systemFontOfSize:14]];
        [lbResult setTextAlignment:NSTextAlignmentLeft];
        [lbResult setNumberOfLines:0];

        [self subViewsLayout];
    }
    
    return self;
}

- (void)subViewsLayout
{
    [lbHR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(30, 18));
    }];
    
    [lbHRValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHR.mas_right).with.offset(2);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(63, 18));
    }];
    
    [lbRR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHRValue.mas_right).with.offset(10);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(26, 18));
    }];
    
    [lbRRValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbRR.mas_right).with.offset(2);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(63, 18));
    }];
    
    [lbQRS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbRRValue.mas_right).with.offset(10);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(35, 18));
    }];
    
    [lbQRSValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbQRS.mas_right).with.offset(2);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(63, 18));
    }];
    
    [lbtestTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbQRSValue.mas_right).with.offset(50);
        make.top.equalTo(lbHR.mas_top);
        make.size.mas_equalTo(CGSizeMake(200, 18));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbHR.mas_bottom).with.offset(15);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(lineView.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [lbConclusion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(4);
        make.top.equalTo(ivIcon.mas_top);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [lbResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbConclusion.mas_right).with.offset(5);
        make.top.equalTo(ivIcon.mas_top);
        make.size.mas_equalTo(CGSizeMake(200, 20));

    }];

}

- (void)setTestTime:(NSString *)testTime
{
    [lbtestTime setText:testTime];
}

- (void)setReslut:(NSString *)result
{
    [lbResult setText:result];
}

- (void)setHR:(NSString*)hr RR:(NSString*)rr QRS:(NSString*)qrs Result:(NSString*)result
{
    [lbHRValue setText:[NSString stringWithFormat:@"%@次/分",hr]];
    [lbRRValue setText:[NSString stringWithFormat:@"%@ms",rr]];
    [lbQRSValue setText:[NSString stringWithFormat:@"%@ms",qrs]];
    [lbResult setText:result];
}

@end
