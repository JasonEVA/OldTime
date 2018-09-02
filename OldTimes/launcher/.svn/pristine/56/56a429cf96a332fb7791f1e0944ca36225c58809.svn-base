//
//  MeetingTimeDetailViewController.m
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTimeDetailViewController.h"
#import "MeetingCurrentMeetTimeMarkView.h"
#import "MeetingNameListLabelsView.h"
#import "MeetingTimeDetailTimeMarkView.h"
#import "MeetingNameListBtn.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "Category.h"
#import "MeetingEventBtn.h"
#import "MeetingPersonalDetailEventView.h"
#import "MeetingGetListRequest.h"
#import <DateTools/DateTools.h>
#import "CalendarLaunchrModel.h"
#import "NewCalendarMeetingEventDetailView.h"
/*
 两个竖线之间的距离是：53  cell之间的距离是17 cell从高度为50开始 cell高度为37  cell在scrollview中是从15开始 竖线的宽度为1  (不包含分割线的宽度)
 */

#define TimeLineSpace 28

@interface MeetingTimeDetailViewController ()<UIScrollViewDelegate,MeetingNameListLabelsViewDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MeetingCurrentMeetTimeMarkView *RedmarkView;
@property (nonatomic, strong) MeetingNameListLabelsView *NameListView;
@property (nonatomic, strong) UIScrollView *MainScrollView;
@property (nonatomic, strong) UIScrollView *TitleScrollView;
@property (nonatomic, strong) UIScrollView *RedLineScrollView;
@property (nonatomic, strong) NSDate *PassDate;

/** 会议非空闲列表 */
@property (nonatomic, strong) NSMutableArray *arrayMeetingList;

/** 会议详情View */
@property (nonatomic, strong) NewCalendarMeetingEventDetailView *eventDetailView;

@property (nonatomic, strong) NSArray *arrPersonList;

@end

@implementation MeetingTimeDetailViewController
-(instancetype)initWithDate:(NSDate *)date
{
    if (self == [super init])
    {
        self.PassDate = date;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@%@",[self.PassDate mtc_getStringWithDateWholeDay:YES showWeekDay:YES] ,LOCAL(MEETING_EVENTCONFIRM)];
    
    self.view.backgroundColor = [UIColor grayBackground];
    
    [self.view addSubview:self.RedLineScrollView];
    [self.view addSubview:self.MainScrollView];
    [self.view addSubview:self.TitleScrollView];
    
    [self.MainScrollView addSubview:self.NameListView];
    [self.MainScrollView addSubview:self.scrollView];

    [self createFrame];
    
    [self addRedLineWithDate:self.PassDate];
    
    [self postLoading];
}

- (void)dealloc {
    if (self.eventDetailView) {
        [self.eventDetailView removeFromSuperview];
        self.eventDetailView = nil;
    }
}

#pragma mark - Setter
- (void)setRequired:(NSString *)required {
    _required = required;
    [self requestList];
}

- (void)setRequiredName:(NSString *)requiredName {
    _requiredName = requiredName;
    
    NSArray *arrTmp = [requiredName componentsSeparatedByString:@"●"];
    self.arrPersonList = arrTmp;
}

#pragma mark - Privite Method
- (void)requestList {
    NSDate *startDate = [NSDate dateWithYear:self.PassDate.year month:self.PassDate.month day:self.PassDate.day hour:0 minute:0 second:0];
    NSDate *endDate   = [[startDate dateByAddingDays:1] dateBySubtractingSeconds:1];
    
    MeetingGetListRequest *listRequest = [[MeetingGetListRequest alloc] initWithDelegate:self];
    [listRequest meetingListWithUser:self.required startTime:startDate endTime:endDate];
}

- (void)createFrame
{
    //划竖线
    for (int i = 0; i<25; i++)
    {
        MeetingTimeDetailTimeMarkView *TimeMarkView = [[MeetingTimeDetailTimeMarkView alloc] initWithFrame:CGRectMake(i * 26 + TimeLineSpace * i + 15, 0, 1, self.NameListView.frame.origin.y + self.NameListView.frame.size.height + 15)];
        [self.scrollView addSubview:TimeMarkView];
    }
    
    //划横线
    for (int i = 0; i < self.arrPersonList.count -1; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 65 + 54 *i,24 * 26 + TimeLineSpace * 24 + 1 , 1)];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:label];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 65 + 54 *(self.arrPersonList.count -1) + 6,24 * 26 + TimeLineSpace * 24 + 1 , 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:label];
    
    //设置蓝色标签
    MeetingNameListBtn *btn = [self.NameListView.arrBtns objectAtIndex:0];
    [btn SetBtnBlue];
}
//需要提供服务器返回的到底是什么
- (void)addRedLineWithDate:(NSDate *)date;
{
    //两个竖线之间的距离是：53  cell竖直放向间距17 cell从高度为50开始 cell高度为37  cell在scrollview中是从15开始 竖线的宽度为1
    NSDateComponents *Components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSInteger hour = Components.hour;
    NSInteger Minute = Components.minute;
    
    float distance = 54 * hour + 54/60.0 *Minute;
    self.RedmarkView = [[MeetingCurrentMeetTimeMarkView alloc] initWithFrame:CGRectMake(-4.5 + distance, 0, 40, self.RedLineScrollView.frame.size.height)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.RedmarkView.lblTitle.text = [formatter stringFromDate:date];
    
    [self.RedLineScrollView addSubview:self.RedmarkView];
    
    //拿到model后解析model批量创建btn
}

- (void)CreatLabelsWithModel:(CalendarLaunchrModel *)model
{
    //两个竖线之间的距离是：53(不包含分割线的宽度) cell高度为37  cell在scrollview中是从20开始 竖线的宽度为1
    NSString *nameAppear = model.createUserName;
    
    NSDate *startDate = model.time[0];
    NSDate *endDate   = model.time[1];
    
    float distanceToStart;
    float width;
    
    if (self.PassDate.day == startDate.day && self.PassDate.month == startDate.month && self.PassDate.year == startDate.year)
    {
        distanceToStart = 54 * startDate.hour + 54/60.0 * startDate.minute;
        if (self.PassDate.day == endDate.day && self.PassDate.month == endDate.month && self.PassDate.year == endDate.year)
        {
            width = (endDate.hour - startDate.hour) * 54 + (endDate.minute - startDate.minute) * 54/60.0;
        }
        else
        {
            width = (24 - startDate.hour) * 54 + (0 - startDate.minute) * 54/60.0;
        }
    }
    else
    {
        distanceToStart = 0;
        
        if (self.PassDate.day == endDate.day && self.PassDate.month == endDate.month && self.PassDate.year == endDate.year)
        {
            width = (endDate.hour - 0) * 54 + (endDate.minute - 0) * 54/60.0;
        }
        else
        {
            width = (24 - 0) * 54 + (0 - 0) * 54/60.0;
        }
    }
    
    for (int i = 0; i < self.arrPersonList.count; i++)
    {
        NSInteger Count;
        NSString *strName = [self.arrPersonList objectAtIndex:i];
        if ([strName isEqualToString:nameAppear])
        {
            Count = i + 1;
            MeetingEventBtn *btn = [[MeetingEventBtn alloc] initWithFrame:CGRectMake(16 + distanceToStart, (17 +37) * i + 27.5, width, 22)];
            btn.modelMeeting = model;
            
            [btn setTitle:model.title forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn addTarget:self action:@selector(btnEventClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIColor *colorBG = [UIColor mtc_colorWithW:204];
            UIColor *colorTitle = [UIColor mtc_colorWithW:125];
            if ([startDate isEarlierThanOrEqualTo:self.PassDate] && [endDate isLaterThanOrEqualTo:self.PassDate])
            {
                // 高亮
                colorBG = [UIColor themeBlue];
                colorTitle = [UIColor whiteColor];
            }

            [btn setBackgroundColor:colorBG];
            [btn setTitleColor:colorTitle forState:UIControlStateNormal];
            
            [self.scrollView addSubview:btn];
        }
    }
}

- (void)btnEventClick:(MeetingEventBtn *)btn
{
//    取出btn的属性（name 开始时间  结束时间  获取事件）
//    NSDate *startDate = btn.modelMeeting.time[0];
//    NSDate *endDate   = btn.modelMeeting.time[1];
//    
//    NSArray *arr = @[btn.modelMeeting.createUserName , btn.modelMeeting.title ,[startDate mtc_startToEndDate:endDate] ,btn.modelMeeting.place];
//
//    if (self.eventDetailView) {
//        [self.eventDetailView removeFromSuperview];
//        self.eventDetailView = nil;
//    }
//    self.eventDetailView = [[MeetingPersonalDetailEventView alloc] initWithArray:arr];
//    [self.eventDetailView show];
    self.eventDetailView = [[NewCalendarMeetingEventDetailView alloc] initWithModelArray:self.arrayMeetingList];
    [self.eventDetailView show];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    
    if ([response isKindOfClass:[MeetingGetListResponse class]]) {
        // 会议列表,目前只有一条
        NSArray *meetingList = [(MeetingGetListResponse *)response meetingList];
        self.arrayMeetingList = [NSMutableArray arrayWithArray:meetingList];
        
        for (CalendarLaunchrModel *model in self.arrayMeetingList) {
            [self CreatLabelsWithModel:model];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.scrollView)
    {
        self.TitleScrollView.contentOffset = self.scrollView.contentOffset;
        self.RedLineScrollView.contentOffset = self.scrollView.contentOffset;
    }
    
    if (scrollView == self.TitleScrollView)
    {
        self.scrollView.contentOffset = self.TitleScrollView.contentOffset;
        self.RedLineScrollView.contentOffset = self.TitleScrollView.contentOffset;
    }
}

#pragma mark - MeetingNameListLabelsViewDelegate   貌似做错了  据说要跳到聊天窗口留着
- (void)MeetingNameListLabelsViewCallback_delegateWithbtn:(MeetingNameListBtn *)btn
{
//    NSString *str = [self.arrPersonList objectAtIndex:btn.tag];
}

#pragma mark - init
- (MeetingNameListLabelsView *)NameListView
{
    if (!_NameListView)
    {
        _NameListView = [[MeetingNameListLabelsView alloc] initWithFrame:CGRectMake(10, 20, 0, 0) ArrNameLsit:self.arrPersonList];
        _NameListView.delegate = self;
    }
    return _NameListView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.NameListView.frame.size.width + self.NameListView.frame.origin.x, 0, self.view.frame.size.width - self.NameListView.frame.size.width - 2, self.NameListView.frame.origin.y + self.NameListView.frame.size.height + 15)];
        _scrollView.contentSize = CGSizeMake(25*26 + TimeLineSpace *24 + 15, self.scrollView.frame.size.height);
        
        _scrollView.clipsToBounds = YES;
        _scrollView.directionalLockEnabled = NO; //只能一个方向滑动
        _scrollView.pagingEnabled = NO;           //是否翻页
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIScrollView *)MainScrollView
{
    if (!_MainScrollView)
    {
        _MainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 33, self.view.frame.size.width, self.view.frame.size.height - 97)];
        _MainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.frame.size.height);
        _MainScrollView.clipsToBounds = YES;
        _MainScrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _MainScrollView.pagingEnabled = NO;           //是否翻页
        _MainScrollView.scrollEnabled = YES;
        _MainScrollView.backgroundColor = [UIColor grayBackground];
        _MainScrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _MainScrollView.showsHorizontalScrollIndicator = NO;
        _MainScrollView.delegate = self;
        _MainScrollView.backgroundColor = [UIColor clearColor];
    }
    return _MainScrollView;
}

- (UIScrollView *)TitleScrollView
{
    if (!_TitleScrollView)
    {
        _TitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.NameListView.frame.size.width + self.NameListView.frame.origin.x, 0, self.view.frame.size.width - self.NameListView.frame.size.width - 10, 33)];
        _TitleScrollView.contentSize = CGSizeMake(25*26 + TimeLineSpace *24 + 10, 33);
        _TitleScrollView.clipsToBounds = YES;
        _TitleScrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _TitleScrollView.pagingEnabled = NO;           //是否翻页
        _TitleScrollView.scrollEnabled = YES;
        _TitleScrollView.backgroundColor = [UIColor grayBackground];
        _TitleScrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _TitleScrollView.showsHorizontalScrollIndicator = NO;
        _TitleScrollView.delegate = self;
        _TitleScrollView.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i <=24; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7 + i*26 + TimeLineSpace * i, 15, 30, 18)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor lightGrayColor];
            label.text = [NSString stringWithFormat:@"%d%@",i,LOCAL(MEETING_HOUR)];
            [_TitleScrollView addSubview:label];
        }
    }
    return _TitleScrollView;
}

- (UIScrollView *)RedLineScrollView
{
    if (!_RedLineScrollView)
    {
        _RedLineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.NameListView.frame.size.width + self.NameListView.frame.origin.x, 0, self.view.frame.size.width - self.NameListView.frame.size.width -10, self.scrollView.frame.size.height + 33)];
        _RedLineScrollView.contentSize = CGSizeMake(25*26 + TimeLineSpace *24 + 10, self.scrollView.frame.size.height);
        _RedLineScrollView.clipsToBounds = YES;
        _RedLineScrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _RedLineScrollView.pagingEnabled = NO;           //是否翻页
        _RedLineScrollView.scrollEnabled = YES;
        _RedLineScrollView.backgroundColor = [UIColor grayBackground];
        _RedLineScrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _RedLineScrollView.showsHorizontalScrollIndicator = NO;
        _RedLineScrollView.delegate = self;
        _RedLineScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _RedLineScrollView;
}
@end
