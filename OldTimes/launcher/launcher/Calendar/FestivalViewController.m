//
//  FestivalViewController.m
//  launcher
//
//  Created by conanma on 15/10/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "FestivalViewController.h"
#import "CalendarLaunchrModel.h"
#import "Category.h"
#import "MyDefine.h"
#import <Masonry.h>

@interface FestivalViewController ()

@property (nonatomic, strong) UIView *viewMain;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) CalendarLaunchrModel *model;

@end

@implementation FestivalViewController

- (instancetype)initWithModel:(CalendarLaunchrModel *)Model
{
    if (self = [super init])
    {
        self.model = Model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCAL(CALENDAR_CONFIRM_DETAILTITLE);
    self.view.backgroundColor = [UIColor grayBackground];
    [self initComponents];
    [self setData:self.model];
}

- (void)initComponents
{
    [self.view addSubview:self.viewMain];
    [self.viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@(90));
    }];
    
    [self.viewMain addSubview:self.lblName];
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewMain).offset(13);
        make.top.equalTo(self.viewMain).offset(10);
        make.height.equalTo(@(30));
    }];
    
    [self.viewMain addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewMain).offset(-10);
        make.left.equalTo(self.lblName);
    }];
    
    [self.viewMain addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle.mas_right).offset(8);
        make.top.height.equalTo(self.lblTitle);
    }];
}

- (void)setData:(CalendarLaunchrModel *)model
{
    self.lblName.text = model.title;
    self.lblTitle.text = LOCAL(CALENDAR_TIME);
    self.lblTime.text = [model.time[0] mtc_startToEndDate:model.time[1] wholeDay:model.wholeDay];
}

#pragma mark - init
- (UIView *)viewMain
{
    if (!_viewMain)
    {
        _viewMain = [[UIView alloc] init];
        _viewMain.backgroundColor = [UIColor whiteColor];
    }
    return _viewMain;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        _lblName.font = [UIFont mtc_font_30];
        [_lblName setTextColor:[UIColor themeBlue]];
    }
    return _lblName;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.font = [UIFont mtc_font_26];
        [_lblTime setTextColor:[UIColor blackColor]];
    }
    return _lblTime;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont mtc_font_26];
        [_lblTitle setTextColor:[UIColor blackColor]];
    }
    return _lblTitle;
}

@end
