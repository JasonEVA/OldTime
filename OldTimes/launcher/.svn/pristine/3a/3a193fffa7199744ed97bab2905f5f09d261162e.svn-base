//
//  MeetingTimeandAddressSelectView.m
//  launcher
//
//  Created by 马晓波 on 15/8/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTimeandAddressSelectView.h"
#import "CalendarNewTimeDateSelectTableViewCell.h"
#import "MeetingSelectAddressBtnsView.h"
#import <DateTools/DateTools.h>
#import "UIView+Util.h"
#import "Masonry.h"
#import "Category.h"
#import "MyDefine.h"
#import "MeetingGetListRequest.h"
#import "NewMeetingModel.h"
#import "MeetingSmallRedMarkView.h"
#import "GetMeetingRoomRequest.h"
#import "GetUnfreeMeetingRoomListRequest.h"
#import "UnfreeMeetingRoomModel.h"
#import "CalendarLaunchrModel.h"
#import "UnifiedUserInfoManager.h"
#import "TTLoadingView.h"
#import <objc/runtime.h>

static NSString *timeAddCellIdentifier = @"timeAddCellIdentifier";
#define WhiteBlackSpace 108

@interface MeetingTimeandAddressSelectView()<UIScrollViewDelegate,UIActionSheetDelegate, BaseRequestDelegate, DatePickerDelegate, TTLoadingViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *btnDone;               //完成按钮
@property (nonatomic, strong) UIButton *btnCancel;             //取消按钮
@property (nonatomic, strong) UIScrollView *ScrollViewMark;      //事件时间条
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) DatePickView *datePicker;
@property (nonatomic, strong) NSDate *EventDate;            //用于比较datepicker是否划过一天
@property (nonatomic, strong) MeetingSelectAddressBtnsView *btnViews;   //两个选择会议室的btn
@property (nonatomic, strong) UIImageView *imgdisclosureIndicator;     //btn的箭头

@property (nonatomic, strong) MeetingSmallRedMarkView *SmallRedLine;
// Data
@property (nonatomic, strong) NSMutableArray *arrTimes;
@property (nonatomic, copy) NSArray *arrMeetingRooms;       // 可用会议室
@property (nonatomic, copy)  NSArray  *arrayAllMeetingRooms; // 全部会议室

@property (nonatomic, strong) MeetingRoomListModel *selectMeetingRoomModel;       // 选择的会议室Model

/** datepicker灰色地带（初始化时开始与结束一致） */
@property (nonatomic, strong) NSMutableArray *arraySlideStartDates;
@property (nonatomic, strong) NSMutableArray *arraySlideEndDates;


/** 查询非空闲时间请求 */
@property (nonatomic, strong) MeetingGetListRequest *getUnFreeRequest;

@property (nonatomic, strong) NewMeetingModel *meetingModel;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

/** 所有人的已有会议（calendarLaunchrModel） */
@property (nonatomic, strong) NSArray *arrayUnFreeMeeting;

@property (nonatomic, strong) TTLoadingView *loadingView;

@end

@implementation MeetingTimeandAddressSelectView

- (instancetype)initWithMeetingModel:(NewMeetingModel *)meetingModel timeList:(NSArray *)timeList
{
    if (self = [super init])
    {
        self.isInnerMeeting = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        UIView *dismissview = [[UIView alloc] init];
        [self addSubview:dismissview];
        [dismissview mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [dismissview addGestureRecognizer:recognizer];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
//            make.top.equalTo(self).offset(40);
            make.bottom.equalTo(self).offset(-10);
            make.right.equalTo(self).offset(-12);
			if (IOS_DEVICE_4) {
				make.height.equalTo(@(460));
			} else {
				make.height.equalTo(@(488));
			}

        }];
        
        
        [self.arrTimes addObjectsFromArray:timeList];
        self.firstDate = timeList[0];
        self.lastDate = timeList[1];
        
        [self.datePicker SetDate:self.firstDate];
        
        self.meetingModel = meetingModel;
        self.selectMeetingRoomModel = [[MeetingRoomListModel alloc] init];
        self.selectMeetingRoomModel.ID = meetingModel.try_rShowId;
        self.selectMeetingRoomModel.name = meetingModel.try_showName;
        if ([self.selectMeetingRoomModel.name length]) {
            self.lblbtnJumpToMap.text = self.selectMeetingRoomModel.name;
        }
        
        if ([[self.meetingModel place].name length]) {
            self.lblbtnJumpToMap.text = [self.meetingModel place].name;
        }
        
        [self initComponents];
        [self requestMeetingRoomList];
        
        self.getUnFreeRequest = [[MeetingGetListRequest alloc] initWithDelegate:self];
        [self requestUnfreeTime];
    }
    return self;
}

#pragma mark - Privite Methods
// 获取全部会议室
- (void)requestMeetingRoomList {
    GetMeetingRoomRequest *request = [[GetMeetingRoomRequest alloc] initWithDelegate:self];
    [request getMeetingRoomList];
}

// 获取非空闲会议室
- (void)requestUnfreeMeetingRoomList {
    GetUnfreeMeetingRoomListRequest *request = [[GetUnfreeMeetingRoomListRequest alloc] initWithDelegate:self];
    [request GetUnfreeRoomListWithStartTime:[self timeIntervalWithDate:self.firstDate] endTime:[self timeIntervalWithDate:self.lastDate]];
}

/** 获取非空闲时间数组 */
- (void)requestUnfreeTime {
    [self.getUnFreeRequest meetingListWithUser:self.meetingModel.try_requireJoin startTime:self.datePicker.SelectedDate endTime:self.datePicker.SelectedDate];
}

// 格式化时间
- (long long)timeIntervalWithDate:(NSDate *)date {
    return [date timeIntervalSince1970] * 1000;
}

- (void)SelectedAddress:(UIButton *)btn
{
    BOOL isRoom = btn.tag == 1;
    if (([[self btnViews] btnMeetingRoom] == btn && [[self btnViews] btnMeetingRoom].selected ) || ([[self btnViews] btnMeetingOutSide] == btn && [[self btnViews] btnMeetingOutSide].selected))
    {
        return;
    }
    [[self btnViews] btnMeetingRoom].selected = isRoom;
    [[self btnViews] btnMeetingOutSide].selected = !isRoom;
    self.isInnerMeeting = isRoom;
    
    [self lblbtnJumpToMap].text = (isRoom ? LOCAL(CALENDAR_PLEASE_SELECTE_MEETINGROOM) : LOCAL(CALENDAR_OTHER_PLACE));
    
    if ([[self btnViews] btnMeetingRoom].selected)
    {
        self.strAddress = @"";
    }
    else
    {
        self.selectMeetingRoomModel = nil;
    }
    
//    // 有会议室显示会议室
//    if ([self.selectMeetingRoomModel.ID length]) {
//        [self lblbtnJumpToMap].text = [self selectMeetingRoomModel].name;
//    }
//    
//    // 有场所显示场所，优先级最高
//    if ([self.meetingModel.place.name length]) {
//        [self lblbtnJumpToMap].text = [self.meetingModel place].name;
//    }
    
}

// 谓词筛选会议室
- (void)filterWithFilterArray:(NSArray *)filterArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:filterArray.count];
    for (UnfreeMeetingRoomModel *model in filterArray) {
        [array addObject:model.MeetingRoomNo];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(ID IN %@)",array];
    self.arrMeetingRooms = [self.arrayAllMeetingRooms filteredArrayUsingPredicate:predicate];
    [self.MeetingActionSheetView setArrRoomList:self.arrMeetingRooms];
    
    BOOL hasRoom = [self.arrMeetingRooms count];
    
    self.btnViews.hidden = !hasRoom;
    self.lblSelectOutside.hidden = hasRoom;
    self.lblWithNoMeetingRoom.hidden = hasRoom;

    if (!hasRoom)
    {
        self.selectMeetingRoomModel.ID = @"";
        self.selectMeetingRoomModel.name = @"";
        [self SelectedAddress:self.btnViews.btnMeetingOutSide];
    }
}

- (void)initComponents
{
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.scrollView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.scrollView).offset(16);
         make.height.equalTo(@30);
         make.width.equalTo(@(140)).priorityLow();
         make.centerX.equalTo(self.scrollView);
     }];
    
    [self.contentView addSubview:self.btnDone];
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.segmentedControl.mas_right);
        make.top.equalTo(self.contentView).offset(16);
        make.height.equalTo(@(34.5));
        make.width.equalTo(@60.5);
    }];
    
    [self.contentView addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.segmentedControl.mas_left).offset(-5);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.segmentedControl.mas_left);
        make.top.equalTo(self.contentView).offset(16);
        make.height.equalTo(@(34.5));
        make.width.equalTo(@60.5);
    }];
    
    [self.scrollView addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.segmentedControl.mas_bottom).offset(5);
         make.left.equalTo(self.contentView).offset(-10);
         make.width.lessThanOrEqualTo(self.contentView).offset(-40);
     }];
    
    [self.scrollView addSubview:self.ScrollViewMark];
    [self.ScrollViewMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_right).offset(-30);
        make.width.equalTo(@(15));
        make.height.equalTo(self.datePicker);
    }];
    
    [self.scrollView addSubview:self.btnDetailEvent];
    [self.btnDetailEvent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ScrollViewMark.mas_bottom).offset(0);
        make.right.equalTo(self.contentView).offset(-13);
        make.height.equalTo(@30);
        make.width.equalTo(@(110));
    }];
    
    [self.scrollView addSubview:self.lblArrangedEvent];
    [self.lblArrangedEvent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.ScrollViewMark.mas_bottom).offset(5);
        make.height.equalTo(@(25));
        make.right.equalTo(self.btnDetailEvent.mas_left);
    }];
    
    [self.scrollView addSubview:self.btnViews];
    [self.btnViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnDetailEvent.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(40));
    }];
    
    [self.scrollView addSubview:self.btnJumpToMap];
    
    [self.btnJumpToMap mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(-1);
        make.right.equalTo(self.contentView).offset(1);
        make.top.equalTo(self.btnViews.mas_bottom).offset(50);
        make.height.equalTo(@(43));
    }];
    
    [self.btnJumpToMap addSubview:self.lblbtnJumpToMap];
    
    [self.lblbtnJumpToMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.btnJumpToMap);
        make.left.equalTo(self.btnJumpToMap).offset(20);
        make.right.equalTo(self.btnJumpToMap.mas_right).offset(-25);
    }];
    
    [self.btnJumpToMap addSubview:self.imgdisclosureIndicator];
    
    [self.imgdisclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnJumpToMap).offset(14);
        make.right.equalTo(self.btnJumpToMap).offset(-10);
        make.width.equalTo(@(10));
        make.height.equalTo(@(17));
    }];
    
    [self.scrollView addSubview:self.lblWithNoMeetingRoom];
    [self.lblWithNoMeetingRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.btnViews).offset(20);
        make.height.equalTo(@(34));
    }];
    
    [self.scrollView addSubview:self.lblSelectOutside];
    [self.lblSelectOutside mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lblWithNoMeetingRoom.mas_bottom).offset(-8);
        make.height.equalTo(@(50));
    }];
    
    [self.scrollView addSubview:self.SmallRedLine];
    [self.SmallRedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ScrollViewMark).offset(-15);
        make.top.equalTo(self.ScrollViewMark).offset(105);
        make.width.equalTo(@(30));
        make.height.equalTo(@(6));
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 480);
}

- (TTLoadingView *)loadingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingView:(TTLoadingView *)loadingView {
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - TTLoadingView Delegate
- (void)TTLoadingViewDelgateCallHubWasHidden {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
}

- (BOOL)isLoading {
    return self.loadingView && !self.loadingView.hidden;
}

- (void)configureLoading {
    if (!self.loadingView) {
        self.loadingView = [[TTLoadingView alloc] initWithFrame:self.bounds];
        self.loadingView.delegate = self;
        [self addSubview:self.loadingView];
    }
    [self bringSubviewToFront:self.loadingView];
}

#pragma mark - TTLoadingView Success
- (void)postSuccess                     { [self postSuccess:@""];}
- (void)postSuccess:(NSString *)message { [self postSuccess:message overTime:TipNormalOverTime];}
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second {
    [self configureLoading];
    [self.loadingView postSuccess:message overTime:second];
}

#pragma mark - TTLoadingView Error
- (void)postError:(NSString *)message                            { [self postError:message detailMessage:@"" duration:TipNormalOverTime];}
- (void)postError:(NSString *)message duration:(CGFloat)duration { [self postError:message detailMessage:@"" duration:duration];}
- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration {
    [self configureLoading];
    [self.loadingView postError:message detailMessage:detailMessage duration:duration];
}

#pragma mark - TTLoadingView Loading
- (void)postProgress:(float)progress {
    [self.loadingView postProgress:progress];
}

- (void)postLoading                                               { [self postLoading:@""];}
- (void)postLoading:(NSString *)message                           { [self postLoading:message message:@""];}
- (void)postLoading:(NSString *)title message:(NSString *)message { [self postLoading:title message:message overTime:TipLoadingOverTime];}
- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second {
    [self configureLoading];
    [self.loadingView postLoading:title message:message overTime:second];
}


#pragma mark - TTLoadingView Hide
- (void)hideLoading {
    if (self.loadingView) {
        [self.loadingView hide:NO];
        [self TTLoadingViewDelgateCallHubWasHidden];
    }
}

//设置事件时间条，传入一个时间数组，必须成对出现
- (void)setGraySlideWithTimeArray:(NSArray *)arrTime
{
    for (id view in self.ScrollViewMark.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < arrTime.count; i = i + 2)
    {
        NSDate *StartDate = [arrTime objectAtIndex:i];
        NSDate *EndDate = [arrTime objectAtIndex:i + 1];
        
        NSInteger Starthour   = StartDate.hour;
        NSInteger StartMinute = StartDate.minute;
        
        NSInteger Endhour   = EndDate.hour;
        NSInteger EndMinute = EndDate.minute;
        
        NSInteger DistanceStart = (Starthour * 60 * 60 + StartMinute * 60.0)/(24.0*60*60) * self.ScrollViewMark.frame.size.height;
        NSInteger DistanceEnd = (Endhour * 60 * 60 + EndMinute * 60.0)/(24.0*60*60) * self.ScrollViewMark.frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, DistanceStart , 15, (DistanceEnd - DistanceStart))];
        label.backgroundColor = [UIColor grayBackground];
        
        [self.ScrollViewMark addSubview:label];
    }
}

//设置当前时刻，改变scrolview的contentoffset
- (void)SetCurrentDate:(NSDate *)date
{
    NSDateComponents *Components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSInteger hour = Components.hour;
    NSInteger Minute = Components.minute;
    
    NSInteger offset = ((int)hour * 60 * 60.0 + (int)Minute *60.0)/(24 *60 * 60.0) * self.ScrollViewMark.frame.size.height;
    
    
     [UIView animateWithDuration:0.4f animations:^{
         CGRect  rect = self.SmallRedLine.frame;
         rect.origin.y =  offset;
         self.SmallRedLine.frame = rect;
     }];
}

//设置几名成员已有事件安排
- (void)setLblArrangedEventWithNo:(NSInteger)Count {
    self.lblArrangedEvent.text = [NSString stringWithFormat:LOCAL(CALENDAR_OTHERSHADARRANGED_EVENT),(long)Count];
}

- (void)showWithMeetingRoom:(BOOL)HaveMeetingRoom
{
    if (HaveMeetingRoom)
    {
        self.btnViews.hidden = NO;
        self.lblSelectOutside.hidden = YES;
        self.lblWithNoMeetingRoom.hidden = YES;
    }
    else
    {
        self.btnViews.hidden = YES;
        self.lblArrangedEvent.hidden = NO;
        self.lblWithNoMeetingRoom.hidden = NO;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

/** 计算无时间人员数 */
- (void)calculatorNoTimePeople {
    // 存储无时间人员名字以防重复
    NSMutableArray *arrayNoTimeName = [NSMutableArray array];
    NSDate *currentSelectDate = self.datePicker.SelectedDate;
    
    for (CalendarLaunchrModel *model in self.arrayUnFreeMeeting) {
        NSDate *startDate = model.time[0];
        NSDate *endDate   = model.time[1];
        
        if ([startDate secondsEarlierThan:currentSelectDate] && [endDate secondsLaterThan:currentSelectDate]) {
            NSString *createUser = model.createUser;
            if ([arrayNoTimeName containsObject:createUser]) {
                continue;
            }
            
            [arrayNoTimeName addObject:createUser];
        }
    }
    
    [self setLblArrangedEventWithNo:[arrayNoTimeName count]];
    if ([arrayNoTimeName count] > 0)
    {
        self.lblArrangedEvent.hidden = NO;
    }
    else
    {
        self.lblArrangedEvent.hidden = YES;
    }
}

/** 时间选择器时间变化 */
#pragma mark - datepickdelegate
- (void)getNewDateWhenPickViewValueChanged:(NSDate *)date
{
    NSDate *currentDate = [[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil];
    if ([date isEarlierThan:currentDate]) {
        if (self.segmentedControl.selectedSegmentIndex) {
            [self.datePicker SetDate:[currentDate dateByAddingHours:1]];
            self.lastDate = [currentDate dateByAddingHours:1];
            self.firstDate = currentDate;
        } else {
            [self.datePicker SetDate:currentDate];
        }

		[self requestUnfreeTime];
        
    } else {
        NSDate *dateJustNow = self.segmentedControl.selectedSegmentIndex ? self.lastDate : self.firstDate;
        
        NSDate *dateFromPicker = self.datePicker.SelectedDate;
        if (dateFromPicker.day != dateJustNow.day || dateFromPicker.month != dateJustNow.month) {
            [self requestUnfreeTime];
        }
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            self.firstDate = dateFromPicker;
            if ([self.firstDate secondsFrom:self.lastDate] >= 0)
            {
                // 终止时间不能小于开始时间，默认加1小时
                self.lastDate = [self.firstDate dateByAddingHours:1];
            }
        } else {
            self.lastDate = dateFromPicker;
            if ([self.firstDate secondsFrom:self.lastDate] >= 0)
            {
                self.firstDate = [self.lastDate dateByAddingHours:-1];
            }
        }
        
        
        NSInteger Day = dateFromPicker.day;
        NSInteger Month = dateFromPicker.month;
        
        if (!self.EventDate)
        {
            self.EventDate = dateFromPicker;
        }
        
        NSInteger EventDay = self.EventDate.day;
        NSInteger EventMonth = self.EventDate.month;
        
        if (Month != EventMonth && Day != EventDay)
        {
            //获取当天事件时刻表传递给scrollviewmark
        }
        //传递当前时刻改变scrollviewmark的contentoffset
        [self SetCurrentDate:dateFromPicker];
        
        //储存date
        self.EventDate = dateFromPicker;
        
        //获取网络数据，是否有会议室
        
        // 请求会议室
        [self requestMeetingRoomList];
        [self calculatorNoTimePeople];
    }
    
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([response isKindOfClass:[MeetingGetListResponse class]]) {
        // 人员非空闲时间
        NSArray *arrayMeetingList = [(MeetingGetListResponse *)response meetingList];
        
        if (!self.arraySlideStartDates) {
            self.arraySlideStartDates = [NSMutableArray array];
            self.arraySlideEndDates = self.arraySlideStartDates;
        }
        
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            self.arraySlideEndDates = [NSMutableArray array];
        }
        
        NSMutableArray *arrayRefreshIfNeed = self.segmentedControl.selectedSegmentIndex ? self.arraySlideEndDates : self.arraySlideStartDates;
        [arrayRefreshIfNeed removeAllObjects];
        
        for (CalendarLaunchrModel *model in arrayMeetingList) {
            [arrayRefreshIfNeed addObject:model.time[0]];
            [arrayRefreshIfNeed addObject:model.time[1]];
        }
        
        [self setGraySlideWithTimeArray:arrayRefreshIfNeed];
        
        [self SetCurrentDate:self.datePicker.SelectedDate];
        
        // 判断一下有几名人员有安排
        self.arrayUnFreeMeeting = [NSArray arrayWithArray:arrayMeetingList];
        [self calculatorNoTimePeople];
    }
    else if ([response isKindOfClass:[GetMeetingRoomResponse class]]) {
        GetMeetingRoomResponse *result = (GetMeetingRoomResponse *)response;
        self.arrayAllMeetingRooms = result.arrayRoomList;
        
        // 获取非空闲会议室
        [self requestUnfreeMeetingRoomList];
    } else if ([response isKindOfClass:[GetUnfreeMeetingRoomListResponse class]]) {
        GetUnfreeMeetingRoomListResponse *result = (GetUnfreeMeetingRoomListResponse *)response;
        NSArray *arrayUnfree = result.arrayUnfreeRoomList;
        // 筛选
        [self filterWithFilterArray:arrayUnfree];
    }

}

#pragma mark - Button Click
- (void)clickToDone
{
    //按钮暴力点击防御
    [self.btnDone mtc_deterClickedRepeatedly];
    
    if ((![self.selectMeetingRoomModel.ID isEqualToString:@""] && self.selectMeetingRoomModel.ID != nil) || self.strAddress.length > 0)
    {
        self.arrTimes = [[NSMutableArray alloc]initWithArray:@[self.firstDate,self.lastDate]];
        [self dismiss];
        if (self.delegate && [self.delegate respondsToSelector:@selector(MeetingTimeandAddressSelectViewDelegateCallBack_SelectTimes:address:)])
        {
            [self.delegate MeetingTimeandAddressSelectViewDelegateCallBack_SelectTimes:self.arrTimes address:self.selectMeetingRoomModel];
        }
    }
    else
    {
        [self postError:LOCAL(MEETING_INPUT_MEETINGADDRESS)];
    }
}

- (void)clickToCancel
{
    [self removeFromSuperview];
}

- (void)btnDetailEventClick
{
    //按钮暴力点击防御
    [self.btnDetailEvent mtc_deterClickedRepeatedly];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(MeetingTimeandAddressSelectViewDelegateCallBack_ShowDetailTimeArrange:)])
    {
        self.hidden = YES;
        [self.delegate MeetingTimeandAddressSelectViewDelegateCallBack_ShowDetailTimeArrange:self.datePicker.SelectedDate];
    }
}

- (void)PickViewbtnDoneClick
{
    self.strAddress = self.MeetingActionSheetView.PickView.meetingRoomModel.name;
    self.selectMeetingRoomModel = self.MeetingActionSheetView.PickView.meetingRoomModel;
    self.lblbtnJumpToMap.text = self.strAddress;
    
    self.meetingModel.place = [[PlaceModel alloc] initWithName:@""];
    [self.MeetingActionSheetView dismiss];
}

/** segment选择 */
- (void)segmentValueChanged:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        [self.datePicker SetDate:self.firstDate];
        [self requestUnfreeTime];
    } else {
        [self.datePicker SetDate:self.lastDate];
        [self requestUnfreeTime];
    }
}

#pragma mark - Setter
- (void)setStrAddress:(NSString *)strAddress {
    _strAddress = strAddress;
//    self.selectMeetingRoomModel = [[MeetingRoomListModel alloc] initWithDict:@{}];
}

#pragma mark - Initializer
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [[UIButton alloc] init];
//        _btnDone.expandSize = CGSizeMake(15, 15);
//        [_btnDone setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_btnDone setTitle:LOCAL(CERTAIN) forState:UIControlStateNormal];
        [_btnDone.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnDone setTitleColor:[UIColor mtc_colorWithHex:0x2e9efb] forState:UIControlStateNormal];
        [_btnDone addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] init];
        //        _btnDone.expandSize = CGSizeMake(15, 15);
        //        [_btnDone setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _btnCancel.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [_btnCancel setTitleColor:[UIColor mtc_colorWithHex:0x2e9efb] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (NSMutableArray *)arrTimes
{
    if (!_arrTimes) {
        _arrTimes = [NSMutableArray array];
    }
    return _arrTimes;
}

- (UILabel *)lblArrangedEvent
{
    if (!_lblArrangedEvent)
    {
        _lblArrangedEvent = [[UILabel alloc] init];
        _lblArrangedEvent.textColor = [UIColor themeRed];
        _lblArrangedEvent.font = [UIFont systemFontOfSize:9];
        _lblArrangedEvent.numberOfLines = 2;
        _lblArrangedEvent.text = [NSString stringWithFormat:LOCAL(CALENDAR_OTHERSHADARRANGED_EVENT),0];
    }
    return _lblArrangedEvent;
}

- (UIButton *)btnDetailEvent
{
    if (!_btnDetailEvent)
    {
        _btnDetailEvent = [[UIButton alloc] init];
        _btnDetailEvent.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnDetailEvent.layer.borderWidth = 1.0f;
        _btnDetailEvent.layer.cornerRadius = 6.0f;
        [_btnDetailEvent setTitle:LOCAL(CALENDAR_EVENT_DETAIL) forState:UIControlStateNormal];
        _btnDetailEvent.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnDetailEvent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnDetailEvent addTarget:self action:@selector(btnDetailEventClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDetailEvent;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[LOCAL(CALENDAR_TIMEPICKER_STARTTIME), LOCAL(CALENDAR_TIMEPICKER_ENDTIME)]];
        [_segmentedControl setTintColor:[UIColor themeBlue]];
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

//- (UIDatePicker *)datePicker
//{
//    if (!_datePicker)
//    {
//        _datePicker = [[UIDatePicker alloc] init];
//        _datePicker.frame = CGRectMake(0, 0, 300, 216);
//        NSLocale *locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
//        [_datePicker setLocale:locale];
//        _datePicker.minuteInterval = 5;
//        [_datePicker setDate:self.firstDate animated:NO];
//        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//        [_datePicker addTarget:self action:@selector(dateValueChange) forControlEvents:UIControlEventValueChanged];
//    }
//    return _datePicker;
//}

- (DatePickView *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[DatePickView alloc] init];
        _datePicker.Valuedelegate = self;
        [_datePicker SetDate:self.firstDate];
    }
    return _datePicker;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
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

- (UIScrollView *)ScrollViewMark
{
    if (!_ScrollViewMark)
    {
        _ScrollViewMark = [[UIScrollView alloc] init];
        _ScrollViewMark.clipsToBounds = YES;
        _ScrollViewMark.directionalLockEnabled = NO; //只能一个方向滑动
        _ScrollViewMark.pagingEnabled = NO;           //是否翻页
        _ScrollViewMark.scrollEnabled = NO;
        _ScrollViewMark.backgroundColor = [UIColor clearColor];
        _ScrollViewMark.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _ScrollViewMark.showsHorizontalScrollIndicator = NO;
        _ScrollViewMark.delegate = self;
        _ScrollViewMark.backgroundColor = [UIColor whiteColor];
        _ScrollViewMark.contentSize = CGSizeMake(15, 40*24 + WhiteBlackSpace *2);
    }
    return _ScrollViewMark;
}

- (MeetingSelectAddressBtnsView *)btnViews
{
    if (!_btnViews)
    {
        _btnViews = [[MeetingSelectAddressBtnsView alloc] init];
        [_btnViews.btnMeetingRoom addTarget:self action:@selector(SelectedAddress:) forControlEvents:UIControlEventTouchUpInside];
        [_btnViews.btnMeetingOutSide addTarget:self action:@selector(SelectedAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnViews;
}

- (UIButton *)btnJumpToMap
{
    if (!_btnJumpToMap)
    {
        _btnJumpToMap = [[UIButton alloc] init];
        _btnJumpToMap.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnJumpToMap.layer.borderWidth = 1.0f;
    }
    return _btnJumpToMap;
}

- (UILabel *)lblbtnJumpToMap
{
    if (!_lblbtnJumpToMap)
    {
        _lblbtnJumpToMap = [[UILabel alloc] init];
        _lblbtnJumpToMap.textAlignment = NSTextAlignmentLeft;
        _lblbtnJumpToMap.textColor = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1];
        _lblbtnJumpToMap.text = LOCAL(CALENDAR_PLEASE_SELECTE_MEETINGROOM);
        _lblbtnJumpToMap.font = [UIFont systemFontOfSize:16];
    }
    return _lblbtnJumpToMap;
}

- (UIImageView *)imgdisclosureIndicator
{
    if (!_imgdisclosureIndicator)
    {
        _imgdisclosureIndicator = [[UIImageView alloc] init];
        [_imgdisclosureIndicator setImage:[UIImage imageNamed:@"disclosureIndicator"]];
    }
    return _imgdisclosureIndicator;
}

- (NSArray *)arrMeetingRooms
{
    if (!_arrMeetingRooms)
    {
        _arrMeetingRooms = [[NSArray alloc] init];
    }
    return _arrMeetingRooms;
}

- (MeetingActionSheetView *)MeetingActionSheetView
{
    if (!_MeetingActionSheetView)
    {
        _MeetingActionSheetView = [[MeetingActionSheetView alloc] initWithRoomList:self.arrMeetingRooms];
//        [_MeetingActionSheetView.PickView.btnDone addTarget:self action:@selector(PickViewbtnDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [_MeetingActionSheetView.PickView.btnBigDone addTarget:self action:@selector(PickViewbtnDoneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MeetingActionSheetView;
}

- (UILabel *)lblWithNoMeetingRoom
{
    if (!_lblWithNoMeetingRoom)
    {
        _lblWithNoMeetingRoom = [[UILabel alloc] init];
        [_lblWithNoMeetingRoom setTextColor:[UIColor themeBlue]];
        [_lblWithNoMeetingRoom setFont:[UIFont systemFontOfSize:16]];
        [_lblWithNoMeetingRoom setText:LOCAL(CALENDAR_NO_MEETING_ROOM)];
        [_lblWithNoMeetingRoom setTextAlignment:NSTextAlignmentCenter];
        _lblWithNoMeetingRoom.adjustsFontSizeToFitWidth = YES;
    }
    return _lblWithNoMeetingRoom;
}

- (UILabel *)lblSelectOutside
{
    if (!_lblSelectOutside)
    {
        _lblSelectOutside = [[UILabel alloc] init];
        [_lblSelectOutside setTextColor:[UIColor mtc_colorWithW:149]];
        [_lblSelectOutside setFont:[UIFont systemFontOfSize:14]];
        [_lblSelectOutside setText:LOCAL(CALENDAR_NO_MEETING_ROOM_OTHER)];
        [_lblSelectOutside setTextAlignment:NSTextAlignmentCenter];
        _lblSelectOutside.numberOfLines = 2;
    }
    return _lblSelectOutside;
}

- (MeetingSmallRedMarkView *)SmallRedLine
{
    if (!_SmallRedLine)
    {
        _SmallRedLine = [[MeetingSmallRedMarkView alloc] init];
    }
    return _SmallRedLine;
}
@end
