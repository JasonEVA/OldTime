//
//  SurveyPlansTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyPlansTableViewCell.h"

@interface SurveyPlansView : UIView
{
    UILabel* lbName;
    UILabel* lbValue;
}

- (void)setName:(NSString *)name;
- (void)setNameValue:(NSString *)value;
@end

@implementation SurveyPlansView

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

@interface SurveyPlansTableViewCell ()
{
    SurveyPlansView* staffView;
    SurveyPlansView* planTimeView;
    SurveyPlansView* frequeryView;
    SurveyPlansView* surveyView;
}
@end

@implementation SurveyPlansTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        staffView = [[SurveyPlansView alloc] init];
        [self addSubview:staffView];
        [staffView setName:@"医      生:"];

        planTimeView = [[SurveyPlansView alloc] init];
        [self addSubview:planTimeView];
        [planTimeView setName:@"计划期限:"];
        
        frequeryView = [[SurveyPlansView alloc] init];
        [self addSubview:frequeryView];
        [frequeryView setName:@"频      率:"];
        
        surveyView = [[SurveyPlansView alloc] init];
        [self addSubview:surveyView];
        [surveyView setName:@"随 访  表:"];
        
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
    
    [frequeryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(planTimeView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [surveyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(frequeryView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
}

- (void)setSurveyPlanInfo:(SurveyPlanInfo *)surveyInfo
{
    [staffView setNameValue:surveyInfo.staffName];
    [planTimeView setNameValue:surveyInfo.planTime];
    [frequeryView setNameValue:surveyInfo.planRate];
    [surveyView setNameValue:surveyInfo.planName];
}

@end
