//
//  MainConsoleStaffView.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleStaffView.h"

@interface MainConsoleStaffView ()

@property (nonatomic, readonly) UILabel* staffNameLable;
@property (nonatomic, readonly) UILabel* staffRoleLable;
@end

@implementation MainConsoleStaffView

@synthesize staffNameLable = _staffNameLable;
@synthesize staffRoleLable = _staffRoleLable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.staffNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(28);
    }];
    
    [self.staffRoleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.staffNameLable.mas_bottom).with.offset(3);
    }];
}

- (void) setStaffModel:(StaffInfo*) staff
{
    [self.staffNameLable setText:staff.staffName];
    //    [self.staffTypeLable setText:staff.staffTypeName];
}

- (void) setStaffRole:(NSString*) staffRole
{
    [self.staffRoleLable setText:staffRole];
}

#pragma mark - settingAndGetting
- (UILabel*) staffNameLable
{
    if (!_staffNameLable) {
        _staffNameLable = [[UILabel alloc] init];
        [self addSubview:_staffNameLable];
        [_staffNameLable setFont:[UIFont boldSystemFontOfSize:20]];
        [_staffNameLable setTextColor:[UIColor whiteColor]];
    }
    return _staffNameLable;
}

- (UILabel*) staffRoleLable
{
    if (!_staffRoleLable) {
        _staffRoleLable = [[UILabel alloc] init];
        [self addSubview:_staffRoleLable];
        [_staffRoleLable setFont:[UIFont systemFontOfSize:14]];
        [_staffRoleLable setTextColor:[UIColor whiteColor]];
    }
    return _staffRoleLable;
}


@end
