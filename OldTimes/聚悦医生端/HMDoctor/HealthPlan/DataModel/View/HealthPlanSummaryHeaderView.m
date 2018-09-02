//
//  HealthPlanSummaryHeaderView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryHeaderView.h"

@interface HealthPlanTemplateButton : UIButton

@end

@implementation HealthPlanTemplateButton

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, 0, contentRect.size.width - 25, contentRect.size.height);
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width - 15, (contentRect.size.height - 13)/2, 8, 13);
}

@end

@interface HealthPlanSummaryHeaderView ()

@property (nonatomic, strong) UILabel* templeteNameLabel;

@property (nonatomic, strong) UILabel* execTimeLable;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, strong) UILabel* layDonwLabel;    //制定者
@property (nonatomic, strong) UILabel* examineLabel;    //审核者

@end

@implementation HealthPlanSummaryHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self layoutElements];
        [self showBottomLine];
    }
    return self;
}

- (void) layoutElements
{
    [self.templeteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).offset(15);
    }];
    
    [self.templateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.5);
        make.centerY.equalTo(self.templeteNameLabel);
        make.size.mas_equalTo(CGSizeMake(53, 25));
    }];
    
    [self.execTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.templeteNameLabel);
        make.top.equalTo(self.templeteNameLabel.mas_bottom).offset(12);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.5);
        make.top.equalTo(self.execTimeLable);
    }];
    
    [self.layDonwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.top.equalTo(self.execTimeLable.mas_bottom).offset(7);
    }];
    
    [self.examineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.top.equalTo(self.layDonwLabel.mas_bottom).offset(7);
    }];
}

- (void) setHealthPlanDet:(HealthPlanDetailModel*) model
{
    [self.templeteNameLabel setText:model.templateName];
    [self.execTimeLable setText:[NSString stringWithFormat:@"执行日期:%@～%@", model.beginTime, model.endTime]];
    [self.statusLabel setText:model.statusName];
    
    NSString* layDonw = @"--";
    if (model.createUserName && model.createUserName.length > 0)
    {
        layDonw = [NSString stringWithFormat:@"%@", model.createUserName];
        if (model.createTime && model.createTime.length > 0)
        {
//            NSString* dateStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
            layDonw = [layDonw stringByAppendingFormat:@"(%@)", model.createTime];
        }
    }
    
    [self.layDonwLabel setText:[NSString stringWithFormat:@"制定:%@", layDonw]];
    
    NSString* examine = @"--";
    if (model.approveStaffName && model.approveStaffName.length > 0)
    {
        examine = [NSString stringWithFormat:@"%@", model.approveStaffName];
        if (model.approveTime && model.approveTime.length > 0) {
            
            examine = [examine stringByAppendingFormat:@"(%@)", model.approveTime];
        }
    }
    [self.examineLabel setText:[NSString stringWithFormat:@"审核:%@", examine]];
}

#pragma mark - settingAndGetting
- (UILabel*) templeteNameLabel
{
    if (!_templeteNameLabel) {
        _templeteNameLabel = [[UILabel alloc] init];
        [self addSubview:_templeteNameLabel];
        
        [_templeteNameLabel setFont:[UIFont systemFontOfSize:14]];
        [_templeteNameLabel setTextColor:[UIColor mainThemeColor]];
    }
    return _templeteNameLabel;
}

- (UIButton*) templateButton
{
    if (!_templateButton) {
        _templateButton = [HealthPlanTemplateButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_templateButton];
        
        [_templateButton setTitle:@"模版" forState:UIControlStateNormal];
        [_templateButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [_templateButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_templateButton setImage:[UIImage imageNamed:@"ic_right_arrow"] forState:UIControlStateNormal];
    }
    return _templateButton;
}

- (UILabel*) execTimeLable
{
    if (!_execTimeLable) {
        _execTimeLable = [[UILabel alloc] init];
        [self addSubview:_execTimeLable];
        
        [_execTimeLable setFont:[UIFont systemFontOfSize:13]];
        [_execTimeLable setTextColor:[UIColor commonGrayTextColor]];
    }
    return _execTimeLable;
}

- (UILabel*) statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [self addSubview:_statusLabel];
        
        [_statusLabel setFont:[UIFont systemFontOfSize:13]];
        [_statusLabel setTextColor:[UIColor mainThemeColor]];
    }
    return _statusLabel;
}

- (UILabel*) layDonwLabel
{
    if (!_layDonwLabel) {
        _layDonwLabel = [[UILabel alloc] init];
        [self addSubview:_layDonwLabel];
        
        [_layDonwLabel setFont:[UIFont systemFontOfSize:13]];
        [_layDonwLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _layDonwLabel;
}

- (UILabel*) examineLabel
{
    if (!_examineLabel) {
        _examineLabel = [[UILabel alloc] init];
        [self addSubview:_examineLabel];
        
        [_examineLabel setFont:[UIFont systemFontOfSize:13]];
        [_examineLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _examineLabel;
}

@end
