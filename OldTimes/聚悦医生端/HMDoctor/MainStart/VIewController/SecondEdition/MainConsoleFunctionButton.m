//
//  MainConsoleFunctionButton.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionButton.h"

@interface MainConsoleFunctionModel (IconName)

- (NSString*) iconImageName;

@end

@implementation MainConsoleFunctionModel (IconName)

- (NSString*) iconImageName
{
    NSString* functionCode = self.functionCode;
    
    if (!functionCode || functionCode.length == 0) {
        return nil;
    }
    
    if ([functionCode isEqualToString:@"testAlert"])
    {
        //预警
        return @"mainconsole_icon_warnning";
    }
    
    if ([functionCode isEqualToString:@"archives"]) {
        //建档
        return @"mainconsole_icon_archives";
    }
    
    if ([functionCode isEqualToString:@"evaluate"]) {
        //评估
        return @"mainconsole_icon_assessment";
    }
    
    if ([functionCode isEqualToString:@"survey"]) {
        //随访
        return @"mainconsole_icon_survey";
    }
    
    if ([functionCode isEqualToString:@"rounds"]) {
        //查房
        return @"mainconsole_icon_round";
    }
    
    
    if ([functionCode isEqualToString:@"appoint"]) {
        //约诊
        return @"mainconsole_icon_appointment";
    }
    
    if ([functionCode isEqualToString:@"healthyPlan"]) {
        //健康计划
        return @"mainconsole_icon_healthplan";
    }
    
    if ([functionCode isEqualToString:@"healthyReport"]) {
        //健康报告
        return @"mainconsole_icon_healthreport";
    }
    
    if ([functionCode isEqualToString:@"workTask"]) {
        //协调任务
        return @"mainconsole_icon_worktask";
    }
    
    if ([functionCode isEqualToString:@"userSchedule"]) {
        //自定义任务
        return @"mainconsole_icon_schedule";
    }
    
    if ([functionCode isEqualToString:@"freePatient"]) {
        //随访用户
        return @"mainconsole_icon_freepatient";
    }
    
    if ([functionCode isEqualToString:@"chargePatient"]) {
        //收费用户
        return @"mainconsole_icon_chargepatient";
    }
    
    if ([functionCode isEqualToString:@"advice"]) {
        //用药建议
        return @"mainconsole_icon_medicationrecommendations";
    }
    
    if ([functionCode isEqualToString:@"solicitude"]) {
        //医生关怀
        return @"mainconsole_icon_care";
    }
    if ([functionCode isEqualToString:@"more"]) {
        //医生关怀
        return @"mainconsole_icon_more";
    }
    if ([functionCode isEqualToString:@"noticeWindow"]) {
        // 公告窗
        return @"ic_gonggao";
    }
    if ([functionCode isEqualToString:@"fastInGroup"]) {
        // 快速入组
        return @"ic_enrollment";
    }
    return nil;
}

@end

@implementation MainConsoleFunctionButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = CGRectMake((contentRect.size.width - 50)/2, 20, 50, 50);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = CGRectMake(4, 70 + 4, contentRect.size.width - 8, 21);
    return titleRect;
}

- (void) setFunctionModel:(MainConsoleFunctionModel*) functionModel
{
    [self setTitle:functionModel.functionName forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:[functionModel iconImageName]] forState:UIControlStateNormal];
}


@end

@interface MainConsoleStartFunctionButton ()

@property (nonatomic, readonly) UILabel* badgeLable;
@end

@implementation MainConsoleStartFunctionButton
@synthesize badgeLable = _badgeLable;

- (void) setFunctionModel:(MainConsoleFunctionModel*) functionModel
{
    [super setFunctionModel:functionModel];
    
    if (![functionModel.functionCode isEqualToString:@"rounds"])
    {
        [self setBadge:functionModel.numInfo];
    }

}

- (void) setBadge:(NSInteger) badge
{
    [self.badgeLable setText:[NSString stringWithFormat:@"%ld", badge]];
    [self.badgeLable  setHidden:(badge == 0)];
    CGFloat badgeWidth = [self.badgeLable.text widthSystemFont:self.badgeLable.font] + 6;
    [self.badgeLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(@(badgeWidth));
    }];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.badgeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-13);
        make.width.mas_greaterThanOrEqualTo(@20);
        make.height.mas_offset(@20);
    }];
}

- (UILabel*) badgeLable
{
    if (!_badgeLable) {
        _badgeLable = [[UILabel alloc] init];
        [self addSubview:_badgeLable];
        
        [_badgeLable setBackgroundColor:[UIColor colorWithHexString:@"EE2C4C"]];
        [_badgeLable setFont:[UIFont systemFontOfSize:10]];
        [_badgeLable setTextColor:[UIColor whiteColor]];
        _badgeLable.layer.cornerRadius = 10;
        _badgeLable.layer.masksToBounds = YES;
        [_badgeLable setTextAlignment:NSTextAlignmentCenter];
        
        [_badgeLable setHidden:YES];
    }
    return _badgeLable;
}
@end

@implementation MainConsoleDisplayFunctionButton

- (void) setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:UIControlStateNormal];
    [super setImage:image forState:UIControlStateDisabled];
    [super setImage:image forState:UIControlStateHighlighted];
}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:UIControlStateNormal];
    [super setTitleColor:color forState:UIControlStateDisabled];
    [super setTitleColor:color forState:UIControlStateHighlighted];
}

@end

@interface MainConsoleEditSelectedFunctionButton ()

@end

@implementation MainConsoleEditSelectedFunctionButton

@synthesize minusButton = _minusButton;

- (void) setFunctionModel:(MainConsoleFunctionModel*) functionModel
{
    [super setFunctionModel:functionModel];
    if (functionModel.status == 0) {
        
        [self.minusButton setHidden:YES];
    }
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.top.equalTo(self).with.offset(4);
        make.right.equalTo(self).with.offset(-4);
    }];
    
}

#pragma mark - settingAndGetting
-(UIButton*) minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_minusButton];
        [_minusButton setImage:[UIImage imageNamed:@"main_console_button_delete"] forState:UIControlStateNormal];
    }
    
    return _minusButton;
}

@end

@interface MainConsoleEditUnSelectedFunctionButton ()


@end

@implementation MainConsoleEditUnSelectedFunctionButton

@synthesize plusButton = _plusButton;



- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.top.equalTo(self).with.offset(4);
        make.right.equalTo(self).with.offset(-4);
    }];
    
}

#pragma mark - settingAndGetting
-(UIButton*) plusButton
{
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_plusButton];
        [_plusButton setImage:[UIImage imageNamed:@"main_console_button_add"] forState:UIControlStateNormal];
        
    }
    
    return _plusButton;
}


@end
