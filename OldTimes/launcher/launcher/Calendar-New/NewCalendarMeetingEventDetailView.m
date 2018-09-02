//
//  NewCalendarMeetingEventDetailView.m
//  launcher
//
//  Created by kylehe on 16/5/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  会议室时间冲突详情 － 日程详情 －> 复制并更改了MeetingPersonalDetailEventView

#import "NewCalendarMeetingEventDetailView.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "CalendarLaunchrModel.h"
#import "PlaceModel.h"
#import "NewCalendarMeetingDetailCell.h"

@interface NewCalendarMeetingEventDetailView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView  *tableView;
@property(nonatomic, strong) UIView  *contentView;
@property(nonatomic, strong) UIView *grayLine;
@property(nonatomic, strong) UILabel  *titleLabel;
@property(nonatomic, strong) NSArray  *modelArray;
@end

@implementation NewCalendarMeetingEventDetailView
- (instancetype)initWithModelArray:(NSArray *)modelArray
{
    if (self = [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        CalendarLaunchrModel *model = modelArray[0];
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",model.createUserName,LOCAL(MEETING_PERSONAL_SCHEDULE_DETAIL)];
        self.modelArray = modelArray;
        [self createFrame];
        
        UITapGestureRecognizer *TapGestureRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:TapGestureRecgnizer];
    }
    return self;
}

#pragma mark - interfaceMethod
-(void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewCalendarMeetingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewCalendarMeetingDetailCell identifier]];
    if (self.modelArray.count)
    {
        [cell setDateWithModel:self.modelArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 115;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 0.1;}

#pragma mark - privateMethod
- (void)singleTap:(UITapGestureRecognizer*)tap
{
    [self dismiss];
}

- (void)createFrame
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //上／左／下／右
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(154);
        make.height.equalTo(@(350));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(12);
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.grayLine];
    [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayLine.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma makr - setterAndGetter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor whiteColor];
        [_tableView registerClass:[NewCalendarMeetingDetailCell class] forCellReuseIdentifier:[NewCalendarMeetingDetailCell identifier]];
    }
    return _tableView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UIView *)grayLine
{
    if (!_grayLine)
    {
        _grayLine = [[UIView alloc] init];
        _grayLine.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _grayLine;
}
@end


