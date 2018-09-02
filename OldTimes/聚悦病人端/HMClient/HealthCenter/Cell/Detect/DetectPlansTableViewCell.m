//
//  DetectPlansTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectPlansTableViewCell.h"

@interface DetectPlansView : UIView
{
    UILabel* lbName;
    UILabel* lbValue;
}

- (void)setName:(NSString *)name;
- (void)setNameValue:(NSString *)value;
@end

@implementation DetectPlansView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont font_28]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(OBJWidth(75), 20));
        }];
        
        lbValue = [[UILabel alloc] init];
        [self addSubview:lbValue];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setFont:[UIFont font_28]];
        
        [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setName:(NSString *)name
{
    [lbName setText:name];
}

- (void)setNameValue:(NSString *)value
{
    [lbValue setText:value];
}

@end

@interface DetectPlansTableViewCell ()
{
    DetectPlansView* staffView;
    DetectPlansView* planTimeView;
    DetectPlansView* frequencyView;
    DetectPlansView* periodView;
    DetectPlansView* detectItemView;
}
@end

@implementation DetectPlansTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        staffView = [[DetectPlansView alloc] init];
        [self addSubview:staffView];
        [staffView setName:@"医      生:"];
        
        planTimeView = [[DetectPlansView alloc] init];
        [self addSubview:planTimeView];
        [planTimeView setName:@"计划期限:"];
        
        frequencyView = [[DetectPlansView alloc] init];
        [self addSubview:frequencyView];
        [frequencyView setName:@"频      率:"];
        
        periodView = [[DetectPlansView alloc] init];
        [self addSubview:periodView];
        [periodView setName:@"时      段:"];
 
        detectItemView = [[DetectPlansView alloc] init];
        [self addSubview:detectItemView];
        [detectItemView setName:@"监测项目:"];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [staffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [planTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(staffView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [frequencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(planTimeView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [periodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(frequencyView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [detectItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(periodView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
}

- (void)setDetctPlansInfo:(DetectHealthPlanInfo *)detectPlanInfo
{
    [staffView setNameValue:detectPlanInfo.staffName];
    [planTimeView setNameValue:detectPlanInfo.planTime];
    [frequencyView setNameValue:detectPlanInfo.planRate];
    [periodView setNameValue:detectPlanInfo.periodTime];
    [detectItemView setNameValue:detectPlanInfo.planName];
}

@end
