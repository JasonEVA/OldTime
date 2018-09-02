//
//  NewCalendarViewController.m
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarViewController.h"
#import "NewCalendarMonthView.h"
#import "NewCalendarAlertView.h"
#import "NewCalendarWeekView.h"
#import "ApplicationViewController.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"
#import "NomarlDealWithEventView.h"
#import "NewCalendarYearAndMonthNumberView.h"
#import "NSDate+CalendarTool.h"
#import "NewCalendarDataHelper.h"
#import "NewCalendarMonthDataModel.h"
#import "NewCalendarAddNewEventViewController.h"
#import "NewCalendarAddMeetingViewController.h"

#import "NewCalendarWeeksEventRequest.h"
#import "NewCalendarMonthTableViewCell.h"
#import <NSDate+DateTools.h>
#import "UnifiedUserInfoManager.h"
#import "NewCalendarMonthEventListViewController.h"
#import "NewCalendarWeeksModel.h"
#import "NewPopUpCalendarListView.h"
#import "NewCalendarWeeksModel.h"
#import "NewCalendarGetRequest.h"
#import "NewGetMeetingDetailRequest.h"
#import "NewMeetingConfirmViewController.h"
#import "NewCalendarMakeSureViewController.h"
#import "SelectContactBookViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "NewFestivalViewController.h"

typedef NS_ENUM(NSInteger , SectionType)
{
    SectionTypeMonth = 0,
    SectionTypeWeek,
    SectionTypeToday,
    SectionTypeCheckSomebody
};

typedef NS_ENUM(NSUInteger, CalendarActionType) {
    CalendarActionTypeAddEvent,
    CalendarActionTypeAddMeeting,
    CalendarActionTypeCheckSchedule,
};

NSString* const MCCalendarDidChangedNotification = @"calendar_change_noyification";

static CGFloat const kTitleViewHeight = 40;
static CGFloat const kCalendarAlertViewHeight = 49;

@interface NewCalendarViewController () <NewCalendarAlertViewDelegate,NewCalendarWeekViewDelegate, BaseRequestDelegate, NewCalendarMonthViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NewCalendarAlertView *calendarAlertView;
@property (nonatomic, strong) NomarlDealWithEventView *dropListView;
@property (nonatomic, strong) NewCalendarMonthView *monthView;
@property (nonatomic, strong) NewCalendarWeekView *weekView;
@property(nonatomic, strong) NewCalendarYearAndMonthNumberView  *titleView;
//记录获取事件数据的年份
@property(nonatomic, assign) NSInteger  lastYearCount;
@property(nonatomic, assign) NSInteger  nextYearCount;
/**
 *  存放时间的字典，key:年份 value:年份对应一年的事件数组
 */
@property(nonatomic, strong) NSMutableDictionary *eventDictionary;

@property (nonatomic,strong) NewPopUpCalendarListView * popCalendarView;

@property (nonatomic,strong) NSString * logName;

@property (nonatomic,strong) NSMutableDictionary * dictionary;

@property (nonatomic,strong) NSString * u_true_name ;

@property (nonatomic,strong) UIBarButtonItem * rightSelectItem;

@end

@implementation NewCalendarViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastYearCount = [NSDate date].year;
    self.nextYearCount = [NSDate date].year;
    self.logName = [UnifiedUserInfoManager share].userShowID;
    

    [self setupTitleView];
    
    [self setupRightNavigationItem];
    
    [self setupCalendarAlertView];
    
    [self addMonthView];
    
    [self backToToday];
    
    [self getEventDateWithYear:0];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:MCCalendarDidChangedNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.popCalendarView) {
        self.popCalendarView.hidden = NO;
    }
	
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCCalendarDidChangedNotification object:nil];
}

- (void)changeData
{
    [self changeLookPeopelWithUID:self.logName];
}

#pragma mark - Setup UICompement
- (void)setupTitleView {
    //顶部月份／年份部分
    self.titleView = [[NewCalendarYearAndMonthNumberView alloc] initWithFrame:CGRectMake( 0, 0, IOS_SCREEN_WIDTH * 0.5, kTitleViewHeight)] ;
    self.navigationItem.titleView = self.titleView;
    self.monthView.titleView = self.titleView;
    self.titleView.yearLbl.text = [NSString stringWithFormat:@"%ld年", (long)[NSDate mtc_year:[NSDate date]]];
    self.titleView.monthLbl.text = [NSString stringWithFormat:@"%ld%@", (long)[NSDate mtc_month:[NSDate date]],LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
}

- (void)setupRightNavigationItem {
    self.rightSelectItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClick)];
    self.navigationItem.rightBarButtonItem = self.rightSelectItem;
	
}

/**
 *  底部工具栏视图
 */
- (void)setupCalendarAlertView {
    [self.view addSubview:self.calendarAlertView];
    [self.calendarAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(kCalendarAlertViewHeight));
    }];
}

- (void)btnAddClick
{
    if (!self.dropListView.canappear) {
        self.dropListView.canappear = YES;
        [self.dropListView removeFromSuperview];
        
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [self.dropListView setpassbackBlock:^(NSInteger selectIndex) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) { return;}
		
        switch (selectIndex) {
            case CalendarActionTypeAddMeeting:
            {
                NewCalendarAddMeetingViewController *NewMeetingVC = [[NewCalendarAddMeetingViewController alloc] init];
#warning unused the NewCalendarAddMeetingViewController's block
                [NewMeetingVC refreshDataBlick:^{
                    [weakSelf changeLookPeopelWithUID:self.logName];
                }];
                [self.navigationController pushViewController:NewMeetingVC animated:YES];
            }
                break;
            case CalendarActionTypeAddEvent:
            {
                NewCalendarAddNewEventViewController *vc = [[NewCalendarAddNewEventViewController alloc] init];
                [vc refreshDataBlick:^{
                    [weakSelf changeLookPeopelWithUID:self.logName];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case CalendarActionTypeCheckSchedule:
            {
                SelectContactBookViewController * VC = [[SelectContactBookViewController alloc] init];
                [VC setSingleSelectable:YES];
                [VC setSelfSelectable:NO];
                [VC setIsMission:NO];
                
                [VC selectedPeople:^(NSArray *selectedPeople) {
                    if (selectedPeople.count != 0)
                    {
                        ContactPersonDetailInformationModel * model = [selectedPeople firstObject];
                        strongSelf.u_true_name = [model.u_true_name copy];
                        [strongSelf changeLookPeopelWithUID:model.show_id];
                        strongSelf.navigationItem.rightBarButtonItems = @[];
                    }
                }];
                
                [self presentViewController:VC animated:YES completion:nil];
                
            }
                break;

        }
    }];
    
    [self.view addSubview:self.dropListView];
    [self.dropListView appear];
}

- (void)changeLookPeopelWithUID:(NSString *)uid
{
    _logName = uid;
    self.eventDictionary = [NSMutableDictionary dictionary];;
    self.monthView.eventDictionary = self.eventDictionary;
    [self.monthView.tableView reloadData];
	
    [self getEventDateWithYear:0];
    
    if (_weekView != nil) {
        [self.weekView setLookCalendarUID:self.logName];
    }
    if (self.popCalendarView) {
		[self.popCalendarView setLookCalendarUID:self.logName IsReadOnly:(!self.isMyself)];
		
    }
    if (![self isMyself]) {
        [self.calendarAlertView lookOthersScheduleWithName:self.u_true_name];
    }
    
}

- (void)addMonthView {
    [self.view addSubview:self.monthView];
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.calendarAlertView.mas_top);
    }];
}

- (void)addWeekView{
    [self.view addSubview:self.weekView];
    [self.weekView setLookCalendarUID:self.logName];
    [self.weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.calendarAlertView.mas_top);
    }];
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewCalendarWeeksEventRequest class]]) {
        NewCalendarWeeksEventResponse *currentReponse = (NewCalendarWeeksEventResponse *)response;
        [self hideLoading];
        NewCalendarWeeksModel *eventModel = currentReponse.dataArray.count?currentReponse.dataArray[0]:nil;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:eventModel.endTime/1000];
        [self.eventDictionary setObject:[currentReponse dataArray] forKey:[NSString stringWithFormat:@"%ld",date.year]];
        self.monthView.eventDictionary = self.eventDictionary;
        [self.monthView.tableView reloadData];

    }else if ([request isKindOfClass:[NewCalendarGetRequest class]]) {
        [self.navigationController hideLoading];
        NewCalendarGetResponse * resp = (NewCalendarGetResponse *)response;
        [self pushCalendarVCWithModel:resp.model];
    }else if ([request isKindOfClass:[NewGetMeetingDetailRequest class]]) {
        [self.navigationController hideLoading];
        NewGetMeetingDetailResponse * resp = (NewGetMeetingDetailResponse *)response;
        
        [self pushMeetingVCWithModel:resp.model];
    }
    [self hideLoading];
}

/**
 *  选择日程中具体会议时,进行会议详情视图的呈现
 *  @param model 会议数据模型
 */
- (void)pushMeetingVCWithModel:(NewMeetingModel *)model
{
    self.popCalendarView.hidden = YES;
    NewMeetingConfirmViewController * mettingVC = [[NewMeetingConfirmViewController alloc] initWithModel:model WithRepeatType:calendar_repeatNo justSee:![self isMyself]];
    [self.navigationController pushViewController:mettingVC animated:YES];
    
}

/**
 *  选择日程中具体事件时,进行事件详情视图的呈现
 *  @param model 事件数据模型
 */
- (void)pushCalendarVCWithModel:(CalendarLaunchrModel *)model
{
    self.popCalendarView.hidden = YES;
    NewCalendarMakeSureViewController * calendarVC = [[NewCalendarMakeSureViewController alloc] initWithModelShow:model justSee:![self isMyself]];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {

    if ([request isKindOfClass:[NewCalendarGetRequest class]] ||
        [request isKindOfClass:[NewGetMeetingDetailRequest class]]) {
        if (self.popCalendarView) {
            [self.navigationController postError:errorMessage];
        }
	} else {
		[self postError:errorMessage];
	}
}

#pragma mark - NewCalendarAlertView Delegate
- (void)newCalendarAlertView:(NewCalendarAlertView *)alertView didClickedAtIndex:(NSUInteger)index {
    switch (index) {
        case SectionTypeMonth:
        {
            if (_monthView)
            {
                self.weekView.hidden = YES;
                self.monthView.hidden = NO;
            }
            [self.calendarAlertView setSelectedIndex:SectionTypeMonth];
        }
            break;
        case SectionTypeWeek:
        {
            if (!_weekView)
            {
                [self addWeekView];
                self.monthView.hidden = YES;
            }else
            {
                self.weekView.hidden = NO;
				
            }
            [self.calendarAlertView setSelectedIndex:SectionTypeWeek];
        }
            break;
        case SectionTypeToday:
        {
            [self backToToday];
        }
            break;
            
        case SectionTypeCheckSomebody:
        {
            [self changeLookPeopelWithUID:[[UnifiedUserInfoManager share] userShowID]];
            self.navigationItem.rightBarButtonItem = _rightSelectItem;
        }
            break;
    }
    
    [self updateTitleViewContentWithSectionType:index];
	[self updateCalendarAlertViewTodayWithSectionType:index];
}

- (void)dismissCalendarView
{
    [self.popCalendarView removeFromSuperview];
    self.popCalendarView = nil;
}

- (void)pushVCWithType:(NewPopUpCalendarListViewBlockType)type model:(NewCalendarWeeksModel *)model
{
    // 跳转页面时,将view 隐藏
    if (type == blockType_CreatMetting) {
        self.popCalendarView.hidden = YES;
        NewCalendarAddMeetingViewController * VC = [[NewCalendarAddMeetingViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (type == blockType_CreatEvent) {
        self.popCalendarView.hidden = YES;
        NewCalendarAddNewEventViewController * vc = [[NewCalendarAddNewEventViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        if ([model.type isEqualToString:@"event"] || [model.type isEqualToString:@"event_sure"]) {
            [self getCalendarModelRequestWithModel:model];
        }else if ([model.type isEqualToString:@"meeting"] ) {
            [self getMettingRequestWithModel:model];
        }else if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"]) {
            self.popCalendarView.hidden = YES;
            
            NewFestivalViewController * vc = [[NewFestivalViewController alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)pushVCWithModel:(NewCalendarWeeksModel *)model WithTime:(NSDate *)date
{
    self.popCalendarView.hidden = YES;
    NewCalendarAddNewEventViewController * vc = [[NewCalendarAddNewEventViewController alloc] initWithNSDate:date];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Detial Information
- (void)getCalendarModelRequestWithModel:(NewCalendarWeeksModel *)model
{
    UIViewController *postLoadingViewController = self;
    if (self.popCalendarView) {
        postLoadingViewController = self.navigationController;
    }
	
	if (![self isMyself] && !model.isVisible) {
		[postLoadingViewController postError:LOCAL(PERMISSION_ERROR)];
		return;
	}
	
    NewCalendarGetRequest * request = [[NewCalendarGetRequest alloc] initWithDelegate:self];
    [request getCalendarWithShowId:model.showId initialStartTime:model.startTime];
    [postLoadingViewController postLoading];
}

- (void)getMettingRequestWithModel:(NewCalendarWeeksModel*)model
{
    UIViewController *postLoadingViewController = self;
    if (self.popCalendarView) {
        postLoadingViewController = self.navigationController;
    }
    
    if (!model.isAllowSearch) {
        [postLoadingViewController postError:LOCAL(PERMISSION_ERROR)];
        return;
    }
    
    NewGetMeetingDetailRequest * request = [[NewGetMeetingDetailRequest alloc] initWithDelegate:self];
    [request getMeetingDetailWithShowID:model.relateId startTime:model.startTime];
    [postLoadingViewController postLoading];
}

#pragma mark - NewCalendarMonthViewDelegate
/**
 *  弹出弹窗视图,根据选择的日期进行Action执行
 *  @param date 展示视图选择的日期
 */
- (void)newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:(NSString *)year MonthsText:(NSString *)month {
	self.titleView.yearLbl.text = year;
	self.titleView.monthLbl.text = month;
}

- (void)presentVCWithDate:(NSDate *)date
{
    [self.popCalendarView setNewDate:date];
	[self.popCalendarView setLookCalendarUID:self.logName IsReadOnly:(!self.isMyself)];
	[self.navigationController.view addSubview:self.popCalendarView];
}

- (void)SetTodayColor:(BOOL)isToday
{
    [self.calendarAlertView setToday:isToday];
}

- (void)getMoreEventDataWithType:(RequestType)type
{
    switch (type)
    {
        case k_getLastYearEventData:   //获取上一年的数据
        {
            [self getEventDateWithYear:--self.lastYearCount];
        }
            break;
        case k_getNextYearEventData:    //获取下一年的数据
        {
            [self getEventDateWithYear:++self.nextYearCount];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NewCalendarWeekViewDelegate
- (void)NewCalendarWeekView_ChangeStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
	if (!self.weekView.hidden) {
		self.titleView.yearLbl.text = startDate;
		self.titleView.monthLbl.text = endDate;
	}
}
- (void)setIsToday:(BOOL)isToday
{
    [self.calendarAlertView setToday:isToday];
}

- (void)NewCalendarWeekViewDidSelectModel:(NewCalendarWeeksModel *)model {
    [self pushVCWithType:blockType_Calendar model:model];
}

#pragma mark - Initializer
- (NewCalendarAlertView *)calendarAlertView {
    if (!_calendarAlertView) {
        _calendarAlertView = [[NewCalendarAlertView alloc] initWithImages:@[[UIImage imageNamed:@"month_normal"],
                                                                            [UIImage imageNamed:@"week_Normal"],
                                                                            [UIImage imageNamed:@"loc_normal"]]
                                                             selectImages:@[[UIImage imageNamed:@"month_select"],
                                                                            [UIImage imageNamed:@"week_select"],
                                                                            [UIImage imageNamed:@"loc_select"]]
                                                                   titles:@[LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH),
                                                                            LOCAL(CALENDAR_SCHEDULEBYWEEK_WEEK),
                                                                            LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY)]];
        
        _calendarAlertView.delegate = self;
        [_calendarAlertView setToday:YES];
        [_calendarAlertView setSelectedIndex:0];
    }
    return _calendarAlertView;
}

- (NewCalendarMonthView *)monthView {
    if (!_monthView) {
        _monthView = [[NewCalendarMonthView alloc] init];
        _monthView.delegate = self;
    }
    return _monthView;
}

- (NewCalendarWeekView *)weekView
{
    if (!_weekView)
    {
        _weekView = [[NewCalendarWeekView alloc] init];
        _weekView.delegate = self;
    }
    return _weekView;
}

- (NomarlDealWithEventView *)dropListView {
    if (!_dropListView) {
        NSArray *images = @[[UIImage imageNamed:@"NewCalendar_Event"],
                            [UIImage imageNamed:@"NewCalendar_Meeting"],
                            [UIImage imageNamed:@"NewCalendar_Check"]/*,
                                                                      [UIImage imageNamed:@"NewCalendar_Google"]*/];
        NSArray *titles = @[LOCAL(CALENDAR_ADD_ADDORDER),
                            LOCAL(MEETING_ADDNEWMEETING),
                            LOCAL(NEWCALENDAR_SEEOTHEREVENT)/*,
                                      @"同步谷歌日历"*/];
        _dropListView = [[NomarlDealWithEventView alloc] initWithArrayLogos:images arrayTitles:titles];
        _dropListView.canappear = YES;
    }
    return _dropListView;
}

- (NSMutableDictionary *)eventDictionary
{
    if (!_eventDictionary)
    {
        _eventDictionary = [NSMutableDictionary dictionary];
    }
    return _eventDictionary;
}

- (NewPopUpCalendarListView *)popCalendarView
{
    if (!_popCalendarView) {
        _popCalendarView = [[NewPopUpCalendarListView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT)];
        
        __weak typeof(self) weakSelf = self;
        [_popCalendarView setDisMissBlock:^(NewPopUpCalendarListViewBlockType type,NewCalendarWeeksModel * model) {
            __strong typeof(self) strongSelf = weakSelf;
            if (type == blockType_pop) {
                [strongSelf dismissCalendarView];
            }else {
                [strongSelf pushVCWithType:type model:model];
                NSLog(@"model===%d",model.isVisible);
                
            }
        }];
        
        [_popCalendarView setJumptoaddeventnblock:^(NSDate *date) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf pushVCWithModel:nil WithTime:date];
        }];
    }
    return _popCalendarView;
}

#pragma mark - Private Method
/**
 *  展示视图重置成当天的视图样式
 */
- (void)backToToday
{
    NewCalendarDataHelper *helper = [NewCalendarDataHelper shareInstace];
    NSInteger height = 0;
    
    for (NSMutableArray *array in helper.modelArray)
    {
        for (int  i = 0 ; i <array.count ; i++)
        {
            
            NewCalendarMonthDataModel *model = array[i];
            if ((model.day == [NSDate mtc_day:[NSDate date]] )&& (model.month == [NSDate mtc_month:[NSDate date]])&&(model.year == [NSDate mtc_year:[NSDate date]]))
            {
                [self.monthView.tableView setContentOffset:CGPointMake(0, height) animated:YES];
				self.titleView.monthLbl.text = [NSString stringWithFormat:@"%ld月", (long)model.month];
				self.titleView.yearLbl.text = [NSString stringWithFormat:@"%ld年", (long)model.year];
                break;
            }
        }
        height += (IOS_SCREEN_HEIGHT - 49 - 64 - 30);
    }
    
    if (_weekView) {
		if (!_weekView.hidden) {
			[self.weekView locationWithToday];
			[self updateTitleViewContentWithSectionType:SectionTypeWeek];
		}
    }
    
}

- (BOOL)isMyself {
    return [self.logName isEqualToString:[UnifiedUserInfoManager share].userShowID];
}

/**
 *  获得指定年的所有事件
 *  @param year 与今年的差值
 */
- (void)getEventDateWithYear:(NSInteger)year
{
    NewCalendarWeeksEventRequest *request = [[NewCalendarWeeksEventRequest alloc] initWithDelegate:self];
    NSDate *StartDate =[NSDate dateWithYear:year?:[NSDate date].year month:1 day:1];
    NSDate *EndDate = [NSDate dateWithYear:year?:[NSDate date].year month:12 day:31];
    [request eventListWithStartDate:StartDate endDate:EndDate userLoginName:self.logName];
}

/**
 *  切换日历的视图类型时,进行titleView的文本更新
 *  @param type 视图类型: SectionTypeMonth:月视图, SectionTypeWeek:周视图
 */
- (void)updateTitleViewContentWithSectionType:(SectionType)type {
    switch (type) {
        case SectionTypeMonth: {
            [self updateTitleViewContentWithYearLabelString:self.monthView.currentYearTitle monthLabelString:self.monthView.currentMonthTitle];
            break;
        }
        case SectionTypeWeek: {
            [self updateTitleViewContentWithYearLabelString:self.weekView.currentYearTitle monthLabelString:self.weekView.currentMonthTitle];
            break;
        }
		case SectionTypeToday:
        case SectionTypeCheckSomebody:
            break;
    }
}

- (void)updateTitleViewContentWithYearLabelString:(NSString *)yearString monthLabelString:(NSString *)monthString {
    self.titleView.yearLbl.text = yearString;
    self.titleView.monthLbl.text = monthString;
}

- (BOOL)isTodayWithModel:(NewCalendarMonthDataModel *)model {
	return YES;
}

- (void)updateCalendarAlertViewTodayWithSectionType:(SectionType)type {
	switch (type) {
		case SectionTypeMonth:
			[self.calendarAlertView setToday: self.monthView.isTodayVisible];
			break;
		case SectionTypeWeek:
			if (_weekView && !_weekView.hidden) {
				[self.calendarAlertView setToday:self.weekView.isTodayVisible];
			}
			break;
		case SectionTypeToday:
		case SectionTypeCheckSomebody:
			break;
	}
}

@end
