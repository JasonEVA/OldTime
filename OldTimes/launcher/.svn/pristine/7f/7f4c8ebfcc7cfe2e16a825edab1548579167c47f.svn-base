//
//  CalendarViewController.m
//  Launchr
//
//  Created by Conan Ma on 15/7/23.
//  Copyright (c) 2015年 Conan Ma. All rights reserved.
//  日历主界面

#import "CalendarViewController.h"
#import "Masonry.h"
#import "SearchView.h"
#import "CalendarDateDataModel.h"
#import "CalendarEventListTableViewCell.h"
#import "CalendarNewEventViewController.h"
#import "MyDefine.h"
#import "CalendarPageControlPointView.h"
#import "CalendarTableViewEventListHeadView.h"
#import "RoundCountView.h"
#import "CalendarDayCollectionViewCell.h"
#import "CalendarMonthDataModel.h"
#import "DateTools.h"
#import "MeetingAddNewMeetingViewController.h"
#import "CalendarLaunchrModel.h"
#import "CalendarNewEventMakeSureViewController.h"
#import "CalendarGetWeekEventRequest.h"
#import "MeetingOnlyLabelTableViewCell.h"
#import "GetMeetingDetailRequest.h"
#import "MeetingConfirmViewController.h"
#import "FestivalViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SelectContactBookViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "CalendarGetRequest.h"
#import "AvatarUtil.h"
#import "MixpanelMananger.h"
#import "Category.h"

#define OneSeventhWidth (self.view.bounds.size.width/7)

static NSString * CollectionViewCellIdentifier = @"CollectionViewCellIdentifierID";

@interface CalendarViewController ()<UIActionSheetDelegate>

/** 当前显示的人员loginName（默认本人） */
@property (nonatomic, copy)  NSString *selectedLoginName;
/** 显示当前人员 */
@property (nonatomic, strong) UILabel *selectedLabel;

@property (nonatomic, strong) UIView *ContentView;
@property (nonatomic, strong) UIButton *btnToday;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) CalendarPageControlPointView *PageControlView;
@property (nonatomic, strong) RoundCountView *RoundView;
@property (nonatomic, strong) UIActionSheet *actionSheet;              //选择添加事件种类
@property (nonatomic, strong) MASConstraint *MasConstraint;
@property (nonatomic, strong) MASConstraint *MasConstraintCollection;
@property (nonatomic, strong) UIView *ViewWeeksLabel;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic) NSInteger initWeeks;
@property (nonatomic) BOOL tableviewneedMove;
@property (nonatomic) calendar_repeatType RepeatTypeOnlyForPass;

/** 适配ios7无法滚动到当前日期 */
@property (nonatomic, assign) BOOL isFirstIn;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightSelectItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_CHANGE) style:UIBarButtonItemStylePlain target:self action:@selector(clickToChangePerson)];
    self.navigationItem.rightBarButtonItem = rightSelectItem;
    
    self.selectedLoginName = [[UnifiedUserInfoManager share] userShowID];
    
    [self initComponents];
    [self CreatFrame];
    [self changeRightBottomStatus:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshEventData];
    //    [self RefreshCollectionandTableviewEventListData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0 , self.ScrollView.frame.size.width, self.ScrollView.frame.size.height);
    if (!self.isFirstIn) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowTotalNumber / 2 - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.isFirstIn = YES;
    }
}

#pragma mark - Interface Method
- (void)newEvent
{
    [self btnAddClick];
}

#pragma mark - Privite Methods
- (void)initComponents
{
    [self.view addSubview:self.ScrollView];
    [self.ScrollView addSubview:self.ContentView];
    
    _rowTotalNumber = 20;
    _rowMoveNumber = 5;
    self.tableviewneedMove = NO;
    
    //设置1星期标题
    NSArray *arrTitlts = [NSArray arrayWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    self.ViewWeeksLabel.frame = CGRectMake(0, 38, self.view.frame.size.width, 30);
    for (int i = 0; i<7; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(OneSeventhWidth *i, 0, OneSeventhWidth, 30)];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [arrTitlts objectAtIndex:i];
        if (i == 0 || i == 6)
        {
            label.textColor = [UIColor colorWithRed:175.0/255 green:175.0/255 blue:175.0/255 alpha:1];
        }
        else
        {
            label.textColor = [UIColor colorWithRed:28.0/255 green:28.0/255 blue:28.0/255 alpha:1];
        }
        [self.ViewWeeksLabel addSubview:label];
    }
    [self.view addSubview:self.ViewWeeksLabel];
    
    self.lblLine = [[UILabel alloc] initWithFrame:CGRectMake(12, 70, self.view.frame.size.width -24, 1)];
    self.lblLine.backgroundColor = [UIColor grayBackground];
    [self.view addSubview:self.lblLine];
    [self.view bringSubviewToFront:self.lblLine];
    
    _arrayMonthDataModel  = [[NSMutableArray alloc] initWithCapacity:_rowTotalNumber];
    
    //获取当月为中心的21个月
    [self arrayMonthDataModelInit];
    //tableview滑到当前月
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowTotalNumber / 2 - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //获取当周为中心的21个周
    [self getFirstWeek];
    [self.CollectionViewWeek setContentOffset:CGPointMake((self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2, 0)];
    
    [self.view addSubview:self.selectedLabel];
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);
        make.top.equalTo(self.view).offset(13);
    }];
}

- (void)CreatFrame
{
    [self.ScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view).offset(70);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
    }];
    
    [self.ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ScrollView);
        make.height.equalTo(self.ScrollView);
    }];
    
    [self.ContentView addSubview:self.tableView];
    [self.ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(CGRectGetWidth(self.view.frame) * 2));
    }];
    
    [self.ContentView addSubview:self.CollectionViewWeek];
    [self.CollectionViewWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_right);
        self.MasConstraintCollection = make.top.equalTo(self.ContentView);
        make.width.equalTo(self.tableView);
        make.height.equalTo(@(55));
    }];
    
    [self.ContentView addSubview:self.tableViewEventList];
    [self.tableViewEventList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_right);
        self.MasConstraint = make.top.equalTo(self.CollectionViewWeek.mas_bottom);
        make.width.equalTo(self.tableView);
        make.bottom.equalTo(self.ContentView);
    }];
    
    [self.view addSubview:self.btnToday];
    [self.btnToday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ScrollView.mas_bottom);
        make.left.equalTo(self.ScrollView);
        make.right.equalTo(self.view).dividedBy(2).offset(0.5);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.btnAdd];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ScrollView.mas_bottom);
        make.left.equalTo(self.btnToday.mas_right).offset(-1);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.PageControlView];
    [self.PageControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
}

//刷新collection和tablevieweventlist的数据  tablevieweventlist里的数据是根据collection里的数据取出来的
- (void)RefreshCollectionandTableviewEventListData
{
    CalendarWeekDataModel *weekModel = [self.arrWeekModels objectAtIndex:self.CollectionViewWeek.contentOffset.x/self.view.frame.size.width];
    
    NSDate *dateStart = ((CalendarDateDataModel *)(weekModel.arrDayModels[0]))._date;
    NSDate *dateEnd = [dateStart dateByAddingDays:7];
    
    [self TableviewHeaderTtitleUpdate];
    CalendarGetWeekEventRequest *requestWeek = [[CalendarGetWeekEventRequest alloc] initWithDelegate:self];
    [requestWeek eventListWithStartDate:dateStart endDate:dateEnd userLoginName:self.selectedLoginName];
}

// 刷新事件相关的 Data
- (void)refreshEventData
{
    //月视图 刷新数据
    CalendarMonthDataModel *monthDataModel = _arrayMonthDataModel[0];
    NSDate *startDate = monthDataModel._firstDateInThisMonth;
    monthDataModel = _arrayMonthDataModel[_rowTotalNumber - 1];
    monthDataModel = [monthDataModel getNextMonth];
    NSDate *endDate = monthDataModel._firstDateInThisMonth;
    
    CalendarGetEventListRequest *request = [[CalendarGetEventListRequest alloc] initWithDelegate:self];
    [request eventListWithStartDate:startDate endDate:endDate userLoginName:self.selectedLoginName];
    
    //周视图刷新数据
    CalendarWeekDataModel *weekModel = [self.arrWeekModels objectAtIndex:self.CollectionViewWeek.contentOffset.x/self.view.frame.size.width];
    
    NSDate *dateStart = ((CalendarDateDataModel *)(weekModel.arrDayModels[0]))._date;
    NSDate *dateEnd = [dateStart dateByAddingDays:7];
    
    [self TableviewHeaderTtitleUpdate];
    CalendarGetWeekEventRequest *requestWeek = [[CalendarGetWeekEventRequest alloc] initWithDelegate:self];
    [requestWeek eventListWithStartDate:dateStart endDate:dateEnd userLoginName:self.selectedLoginName];
}

// tableview下一批
- (void)addNextBatchData
{
    NSRange range;
    range.location = 0;
    range.length = _rowMoveNumber;
    
    [_arrayMonthDataModel removeObjectsInRange:range];
    
    for (NSInteger i = 0; i < _rowMoveNumber; i++)
    {
        CalendarMonthDataModel *lastModel = [_arrayMonthDataModel lastObject];
        CalendarMonthDataModel *newModel = [lastModel getNextMonth];
        [_arrayMonthDataModel addObject:newModel];
    }
    
    CGPoint point = self.tableView.contentOffset;
    point.y -= _buttomMoveOffsetGate;
    self.tableView.contentOffset = point;
    
    [self refreshTableViewOffsetGate];      // 减少需要在之后再更新高度
    
    [self.tableView reloadData];
}

// tableview上一批
- (void)addLastBatchData
{
    NSRange range;
    range.location = _arrayMonthDataModel.count - _rowMoveNumber;
    range.length = _rowMoveNumber;
    [_arrayMonthDataModel removeObjectsInRange:range];
    
    for (NSInteger i = 0; i < _rowMoveNumber; i++)
    {
        CalendarMonthDataModel *firstModel = [_arrayMonthDataModel firstObject];
        CalendarMonthDataModel *newModel = [firstModel getLastMonth];
        [_arrayMonthDataModel insertObject:newModel atIndex:0];
    }
    
    [self refreshTableViewOffsetGate];      // 增加需要在先更新高度
    
    CGPoint lastPoint = self.tableView.contentOffset;
    [self.tableView setContentOffset:CGPointMake(lastPoint.x, lastPoint.y + _topMoveOffsetGate)];
    
    [self.tableView reloadData];
}

- (void)TableviewHeaderTtitleUpdate
{
    [self.arrTableViewEvent removeAllObjects];
    NSArray *arrWeekName = @[LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),
                             LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY)];
    
    for (int i = 0; i<7; i++)
    {
        int s = self.CollectionViewWeek.contentOffset.x/self.view.frame.size.width;
        CalendarDateDataModel *daymodel = [((CalendarWeekDataModel *)self.arrWeekModels[s]).arrDayModels objectAtIndex:i];
        
        [self.arrTableViewEvent addObject:[NSString stringWithFormat:@"%ld%@%ld%@(%@)",(long)daymodel._month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH),(long)daymodel._dayModel._dayNumber,LOCAL(CALENDAR_SCHEDULEBYWEEK_DAY),arrWeekName[i]]];
        
        NSDate *date1 = [NSDate date];
        
        if (date1.year == daymodel._date.year && date1.month == daymodel._date.month && date1.day == daymodel._date.day)
        {
            [self.arrTableViewEvent addObject:@"1"];
        }
        else if ([date1 isLaterThan:daymodel._date])
        {
            [self.arrTableViewEvent addObject:@"0"];
        }
        else
        {
            [self.arrTableViewEvent addObject:@"2"];
        }
        
        [self.arrTableViewEvent addObject:daymodel._dayModel.arrayEventList];
    }
    [self.tableViewEventList reloadData];
}

/** 切换右下角按钮状态，是否是本人状态 */
- (void)changeRightBottomStatus:(BOOL)isSelf {
    NSString *title = isSelf ? LOCAL(CALENDAR_CHANGE) : LOCAL(CALENDAR_MYCALENDAR);
    SEL selector = isSelf ? @selector(clickToChangePerson) : @selector(clickToChangeMyself);
    
    UIBarButtonItem *rightSelectItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    self.navigationItem.rightBarButtonItem = rightSelectItem;
    
    [self.btnToday mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).dividedBy(isSelf ? 2 : 1);
        make.top.equalTo(self.ScrollView.mas_bottom);
        make.left.equalTo(self.ScrollView);
        make.bottom.equalTo(self.view);
    }];
    
    [UIView performWithoutAnimation:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)isMyself {
    return [self.selectedLoginName isEqualToString:[UnifiedUserInfoManager share].userShowID];
}

#pragma mark - Button Click
- (void)Back {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickToChangePerson {
    SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] init];
    VC.singleSelectable = YES;
    VC.selfSelectable = YES;
    
    __weak typeof(self) weakSelf = self;
    [VC selectedPeople:^(NSArray *people) {
        ContactPersonDetailInformationModel *selectedPeople = [people firstObject];
        if (!selectedPeople) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.selectedLoginName = selectedPeople.show_id;
        strongSelf.selectedLabel.text = selectedPeople.u_true_name;
        [strongSelf postLoading];
        // 在ViewDidAppear中已经有调用请求了，因此不再使用网络
        
        [strongSelf changeRightBottomStatus:[strongSelf isMyself]];
        
    }];
    [self presentViewController:VC animated:YES completion:nil];
}

/** 回到自己的状态 */
- (void)clickToChangeMyself {
    self.selectedLoginName = [[UnifiedUserInfoManager share] userShowID];
    [self.navigationItem.rightBarButtonItem setTitle:LOCAL(CALENDAR_CHANGE)];
    self.selectedLabel.text = @"";
    [self changeRightBottomStatus:YES];
    [self postLoading];
    [self refreshEventData];
}

- (void)btnTodayClick
{
    if (self.ScrollView.contentOffset.x == 0)
    {
        //如果界面在月视图  刷新事件 跳转到当前一个月
        _arrayMonthDataModel = [[NSMutableArray alloc] init];
        NSDate *date = [NSDate date];
        self.title = [NSString stringWithFormat:@"%ld",(long)date.year];
        _Year = date.year;
        [self.tableView reloadData];
        [self arrayMonthDataModelInit];
        
        CalendarMonthDataModel *monthDataModel = _arrayMonthDataModel[0];
        NSDate *startDate = monthDataModel._firstDateInThisMonth;
        monthDataModel = _arrayMonthDataModel[_rowTotalNumber - 1];
        monthDataModel = [monthDataModel getNextMonth];
        NSDate *endDate = monthDataModel._firstDateInThisMonth;
        
        CalendarGetEventListRequest *request = [[CalendarGetEventListRequest alloc] initWithDelegate:self];
        [request eventListWithStartDate:startDate endDate:endDate userLoginName:self.selectedLoginName];
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowTotalNumber / 2 - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else
    {
        //如果界面在周视图 刷新事件 跳转到当前一周
        [self.CollectionViewWeek setContentOffset:CGPointMake((self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2, 0)];
        self.title = [NSString stringWithFormat:@"%ld%@",(long)_TodayMonth,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
        [self RefreshCollectionandTableviewEventListData];
    }
    self.btnToday.enabled = NO;
}

- (void)btnAddClick
{
    [self.actionSheet showInView:self.view];
}

#pragma mark - Month Data Model Init
- (void)arrayMonthDataModelInit
{
    //获取当前月model
    CalendarMonthDataModel *monthDataModelNow = [[CalendarMonthDataModel alloc] initWithCurrentMonth];
    
    NSInteger beforeNum;
    NSInteger afterNum;
    
    // 确定当月之前的月的数量和之后的月的数量
    if (_rowTotalNumber % 2 == 0)
    {
        beforeNum = _rowTotalNumber / 2 - 1;
        afterNum = _rowTotalNumber / 2;
    }
    else
    {
        beforeNum = _rowTotalNumber / 2;
        afterNum = _rowTotalNumber / 2;
    }
    
    NSMutableArray *arrayBeforeModel = [[NSMutableArray alloc] initWithCapacity:beforeNum];
    CalendarMonthDataModel *monthDataModel = [monthDataModelNow getLastMonth];
    for (NSInteger i = 0; i < beforeNum; i++)
    {
        [arrayBeforeModel addObject:monthDataModel];
        monthDataModel = [monthDataModel getLastMonth];
    }
    // 倒序添加前几个
    for (NSInteger i = beforeNum - 1; i >= 0; i--)
    {
        [_arrayMonthDataModel addObject:arrayBeforeModel[i]];
    }
    // 添加当前
    [_arrayMonthDataModel addObject:monthDataModelNow];
    // 添加后几个
    monthDataModel = [monthDataModelNow getNextMonth];
    for (int i = 0; i < afterNum; i++)
    {
        [_arrayMonthDataModel addObject:monthDataModel];
        monthDataModel = [monthDataModel getNextMonth];
    }
    
    [self refreshTableViewOffsetGate];
}

- (void)arrayWeekDataModelInit
{
    NSInteger beforeNum;
    NSInteger afterNum;
    
    // 确定当月之前的月的数量和之后的月的数量
    beforeNum = 10;
    afterNum = 10;
    
    for (int i = 0; i < beforeNum; i++)
    {
        [self getLastWeek];
        [self.arrWeekModels insertObject:self.LastWeekModels atIndex:0];
    }
    
    // 添加后几个
    for (int i = 0; i < afterNum; i++)
    {
        [self getNextWeek];
        [self.arrWeekModels addObject:self.NextWeekModels];
    }
}

// 更新高度信息
- (void)refreshTableViewOffsetGate
{
    CGFloat topGate = 0;
    
    for (int i = 0; i < _rowMoveNumber; i++)
    {
        topGate += ((CalendarMonthDataModel *)[_arrayMonthDataModel objectAtIndex:i])._cellHeight;
    }
    _topMoveOffsetGate = topGate;
    
    CGFloat buttomGate = 0;
    
    for (int i = 0; i < _rowMoveNumber; i++)
    {
        buttomGate += ((CalendarMonthDataModel *)[_arrayMonthDataModel objectAtIndex:_arrayMonthDataModel.count - 1 - i])._cellHeight;
    }
    
    _buttomMoveOffsetGate = buttomGate;
}

#pragma mark - week data model init
//获取当天所在的周的model
- (void)getFirstWeek
{
    CalendarWeekDataModel *WeekDatamodelNow = [[CalendarWeekDataModel alloc] initWithCurrentWeek:YES];
    [self.arrWeekModels addObject:WeekDatamodelNow];
    
    self.DateBefore = WeekDatamodelNow.DateBefore;
    self.DateAfter = WeekDatamodelNow.DateAfter;
    
    [self arrayWeekDataModelInit];
}

//获取之前一周
- (void)getLastWeek
{
    NSDateComponents *Components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.DateBefore];
    [Components setDay:Components.day - 7];
    
    self.DateBefore = [[NSCalendar currentCalendar] dateFromComponents:Components];
    self.LastWeekModels = [[CalendarWeekDataModel alloc] init];
    self.LastWeekModels.DateBefore = [[NSCalendar currentCalendar] dateFromComponents:Components];
    for (NSInteger day = 0; day < 7; day++) {
        CalendarDateDataModel *dateDataModel = [[CalendarDateDataModel alloc] init];
        DayModel *dayModel = [[DayModel alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeInterval:24 *60 * 60 *day sinceDate:self.DateBefore];
        dayModel._dayNumber = date.day;
        [dateDataModel setYear:date.year month:date.month day:dayModel];
        [self.LastWeekModels.arrDayModels addObject:dateDataModel];
    }
}

//获取之后一周
- (void)getNextWeek
{
    NSDateComponents *Components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.DateAfter];
    [Components setDay:Components.day + 7];
    
    self.DateAfter = [[NSCalendar currentCalendar] dateFromComponents:Components];
    self.NextWeekModels = [[CalendarWeekDataModel alloc] init];
    self.NextWeekModels.DateAfter = [[NSCalendar currentCalendar] dateFromComponents:Components];
    for (NSInteger day = 0; day < 7; day++) {
        CalendarDateDataModel *dateDataModel = [[CalendarDateDataModel alloc] init];
        DayModel *dayModel = [[DayModel alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeInterval:24 *60 * 60 *day sinceDate:self.DateAfter];
        dayModel._dayNumber = date.day;
        [dateDataModel setYear:date.year month:date.month day:dayModel];
        [self.NextWeekModels.arrDayModels setObject:dateDataModel atIndexedSubscript:day];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            MeetingAddNewMeetingViewController *NewMeetingVC = [[MeetingAddNewMeetingViewController alloc] init];
            [self.navigationController pushViewController:NewMeetingVC animated:YES];
        }
            break;
        case 0:
        {
            CalendarNewEventViewController *CNEVC = [[CalendarNewEventViewController alloc] init];
            [self.navigationController pushViewController:CNEVC animated:YES];
        }
            break;
        default:
            return;
    }
    
    
    [MixpanelMananger track:@"calendar/new"];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableViewEventList == scrollView)
    {
        return;
    }
    
    if (self.tableView.contentSize.height == 0)
    {
        return;
    }
    if (scrollView == self.tableView) {
        // 无限下拉
        // 快到底部的时候把头上的数据清除掉，再往后面添加内容
        if (self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableView.frame.size.height < _buttomMoveOffsetGate)
        {
            [self addNextBatchData];
            [self refreshEventData];
        }
        // 无限上拉
        // 快到顶部的时候把尾部的数据清楚掉，再往头上添加内容
        else if (self.tableView.contentOffset.y < _topMoveOffsetGate)
        {
            [self addLastBatchData];
            [self refreshEventData];
        }
    }
    
    if (scrollView == self.ScrollView)
    {
        //回到今天
        float index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        if (index!= 1)
        {
            if (self.CollectionViewWeek.contentOffset.x <= self.view.bounds.size.width || self.CollectionViewWeek.contentOffset.x /self.view.bounds.size.width +2 >= self.arrWeekModels.count)
            {
                [self.CollectionViewWeek setContentOffset:CGPointMake((self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2, 0)];
                if (!_TodayMonth)
                {
                    return;
                }
                self.title = [NSString stringWithFormat:@"%ld%@",_TodayMonth,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
            }
        }
        [self TableviewHeaderTtitleUpdate];
    }
    
    if (scrollView == self.tableView)
    {
        BOOL todayshow = YES;
        
        for (CalendarMonthTableViewCell *cell in self.tableView.visibleCells)
        {
            NSDate *datetoday = [NSDate date];
            if (cell._monthDataModel._year == datetoday.year && cell._monthDataModel._month == datetoday.month)
            {
                todayshow = NO;
            }
        }
        self.btnToday.enabled = todayshow;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.tableViewEventList == scrollView)
    {
        return;
    }
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    if (scrollView == self.ScrollView)
    {
        //回到今天
        
        if (index != 1)
        {
            [self.CollectionViewWeek setContentOffset:CGPointMake((self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2, 0)];
            [self RefreshCollectionandTableviewEventListData];
        }
        [self.PageControlView setSelectedColor:index];
        
        if (index == 0)
        {
            self.title = [NSString stringWithFormat:@"%ld",(long)_Year];
            BOOL todayshow = YES;
            
            for (CalendarMonthTableViewCell *cell in self.tableView.visibleCells)
            {
                NSDate *datetoday = [NSDate date];
                if (cell._monthDataModel._year == datetoday.year && cell._monthDataModel._month == datetoday.month)
                {
                    todayshow = NO;
                }
            }
            self.btnToday.enabled = todayshow;
        }
        if (index == 1)
        {
            if (_Month == 0)
            {
                self.title = [NSString stringWithFormat:@"%ld%@",_TodayMonth,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
            }
            else
            {
                self.title = [NSString stringWithFormat:@"%ld%@",_Month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
            }
            
            [self RefreshCollectionandTableviewEventListData];
            self.btnToday.enabled = NO;
            
        }
    }
    if (scrollView == self.CollectionViewWeek)
    {
        if (self.CollectionViewWeek.contentOffset.x <= self.view.bounds.size.width)
        {
            //左边添加数据
            [self arrayWeekDataModelInit];
            [self.CollectionViewWeek reloadData];
            [self.CollectionViewWeek setContentOffset:CGPointMake(self.view.frame.size.width *11, 0)];
        }
        else if(self.CollectionViewWeek.contentOffset.x /self.view.bounds.size.width +2 >= self.arrWeekModels.count)
        {
            //右边添加数据
            [self arrayWeekDataModelInit];
            [self.CollectionViewWeek reloadData];
            [self.CollectionViewWeek setContentOffset:CGPointMake(self.view.frame.size.width *(self.arrWeekModels.count - 12), 0)];
        }
        
        [self RefreshCollectionandTableviewEventListData];
        
        if (self.CollectionViewWeek.contentOffset.x == (self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2)
        {
            self.btnToday.enabled = NO;
        }
        else
        {
            self.btnToday.enabled = YES;
        }
    }
}

#pragma mark - UITableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableViewEventList)
    {
        return 25;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CalendarTableViewEventListHeadView *View = [[CalendarTableViewEventListHeadView alloc] init];
    View.lblTitle.text = [self.arrTableViewEvent objectAtIndex:section * 3];
    UIColor *color;
    
    //设置head字体颜色 当天之前为灰色  当天为蓝色  之后为黑色
    NSInteger s = [[NSString stringWithFormat:@"%@",[self.arrTableViewEvent objectAtIndex:section * 3 + 1]] integerValue];
    
    if (s == 0)
    {
        color = [UIColor cellTitleGray];
    }
    else if (s == 1)
    {
        color = [UIColor themeBlue];
    }
    else
    {
        color = [UIColor blackColor];
    }
    
    [View.lblTitle setTextColor:color];
    return View;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableViewEventList)
    {
        return self.arrTableViewEvent.count/3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return _arrayMonthDataModel.count;
    }
    else if(tableView == self.tableViewEventList)
    {
        if (((NSMutableArray *)[self.arrTableViewEvent objectAtIndex: section *3 + 2]).count == 0)
        {
            return 1;
        }else
        {
            return ((NSMutableArray *)[self.arrTableViewEvent objectAtIndex: section *3 + 2]).count;;
        }
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        static NSString *indentifier = @"CalendarMonthTableViewIndentifier";
        
        CalendarMonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[CalendarMonthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        CalendarMonthDataModel *monthDataModel = _arrayMonthDataModel[indexPath.row];
        _SelectedCurrent = monthDataModel._daysOfMonth;
        [cell setMonthDataModel:monthDataModel];
        cell.delegate = self;
        
        // 根据将要显示的月份来更改标题
        if (self.title == nil)
        {
            self.title = [NSString stringWithFormat:@"%ld", (long)monthDataModel._year];
            _Year = (long)monthDataModel._year;
        }
        else if (monthDataModel._month == 2 || monthDataModel._month == 11)
        {
            self.title = [NSString stringWithFormat:@"%ld", (long)monthDataModel._year];
            _Year = (long)monthDataModel._year;
        }
        return cell;
    }
    else if(tableView == self.tableViewEventList)
    {
        NSMutableArray *arr = [self.arrTableViewEvent objectAtIndex:indexPath.section *3 + 2];
        
        if (arr.count != 0)
        {
            CalendarEventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarEventListTableViewIdentifier"];
            if (!cell)
            {
                cell = [[CalendarEventListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"CalendarEventListTableViewIdentifier"];
            }
            int s = self.CollectionViewWeek.contentOffset.x/self.view.frame.size.width;
            CalendarDateDataModel *daymodel = [((CalendarWeekDataModel *)self.arrWeekModels[s]).arrDayModels objectAtIndex:indexPath.section];
            CalendarLaunchrModel *model = [arr objectAtIndex:indexPath.row];
            [cell setWithModel:model DayModel:daymodel];
            
            return cell;
        }
        else
        {
            MeetingOnlyLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingOnlyLabelTableViewCellID"];
            if (!cell)
            {
                cell = [[MeetingOnlyLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingOnlyLabelTableViewCellID"];
            }
            cell.lblTitle.text = [NSString stringWithFormat:@"   %@",LOCAL(CALENDAR_NO_DATA)];
            return cell;
        }
        
        return nil;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
            return ((CalendarMonthDataModel *)[_arrayMonthDataModel objectAtIndex:indexPath.row])._cellHeight;
//        return CGRectGetHeight(self.view.frame);
    }
    else if(tableView == self.tableViewEventList)
    {
        return 60;
        
    }
    else
    {
        return 60;
//        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableViewEventList) {
        
        // 日程周点击
        NSArray *array = [self.arrTableViewEvent objectAtIndex:indexPath.section * 3 + 2];
        
        if (![array count])
        {
            return;
        }
        
        CalendarLaunchrModel *model = [array objectAtIndex:indexPath.row];
        if ([model.type isEqualToString:@"meeting"]) {
            // 会议
            self.RepeatTypeOnlyForPass = model.repeatType;
            GetMeetingDetailRequest *request = [[GetMeetingDetailRequest alloc] initWithDelegate:self];
            [request getMeetingDetailWithShowID:model.relateId startTime:model.time[0]];
            [self postLoading];
        }
        else if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"])
        {
            FestivalViewController *VC = [[FestivalViewController alloc] initWithModel:model];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else {
            // 日程
            CalendarGetRequest *request = [[CalendarGetRequest alloc] initWithDelegate:self];
            [request getCalendarWithModel:model];
            [self postLoading];
        }
    }
}

#pragma mark - collectionviewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrWeekModels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    //设置数据
    CalendarWeekDataModel *weekmodel = [self.arrWeekModels objectAtIndex:indexPath.section];
    NSMutableArray *arr = weekmodel.arrDayModels;
    CalendarDateDataModel *daymodel = [arr objectAtIndex:indexPath.row];
    cell.lblTitle.text = [NSString stringWithFormat:@"%ld",(long)daymodel._dayModel._dayNumber];
    [cell setModel:daymodel];
    if (self.ScrollView.contentOffset.x == self.view.frame.size.width)
    {
        self.title = [NSString stringWithFormat:@"%ld%@",(long)daymodel._month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)];
        _DayMonth = daymodel._month;
    }
    if (daymodel._ifToday)
    {
        _TodayMonth = daymodel._month;
    }
    if (_SelectedDate != nil)
    {
        if (daymodel._date == _SelectedDate)
        {
            cell.selected = YES;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/7,55);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.CollectionViewWeek reloadData];
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarWeekDataModel *weekModel = [self.arrWeekModels objectAtIndex:indexPath.section];
    NSMutableArray *arr = weekModel.arrDayModels;
    
    CalendarDateDataModel *daymodel = [arr objectAtIndex:indexPath.row];
    self.title = [NSString stringWithFormat:@"%ld%@%ld%@",daymodel._month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH),(long)daymodel._dayModel._dayNumber,LOCAL(CALENDAR_SCHEDULEBYWEEK_DAY)];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self.tableViewEventList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    _SelectedDate = nil;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[CalendarGetEventListResponse class]])
    {
        [self hideLoading];
        [self RecordToDiary:@"获取日程事件列表成功"];
        // 首先把已有的事件数据全部清空掉
        for (CalendarMonthDataModel *monthDataModel in _arrayMonthDataModel)
        {
            for (CalendarDateDataModel *DateDataModel in monthDataModel._arrayDateDataModel)
            {
                [DateDataModel._dayModel.arrayEventList removeAllObjects];
            }
        }
        
        //接着把新获得的数据对齐添加进去
        NSArray *array = [(id)response arrayresult];
        for (NSInteger j = 0; j < array.count; j++)
        {
            CalendarLaunchrModel *Dayeventmodel = [array objectAtIndex:j];
            NSDate * startdate = Dayeventmodel.time[0];
            NSDate * enddate = Dayeventmodel.time[1];
            
            for (NSInteger i = 0; i < _arrayMonthDataModel.count; i++)
            {
                CalendarMonthDataModel *monthDataModel = _arrayMonthDataModel[i];
                NSDate *MonthStartDate = monthDataModel._firstDateInThisMonth;
                NSDate *MonthEndDate = [monthDataModel._firstDateInThisMonth dateByAddingDays:monthDataModel._daysOfMonth];
                
                //内包含  外包涵 上包含 下包含
                if (([MonthStartDate isLaterThanOrEqualTo:startdate] && [MonthEndDate isEarlierThanOrEqualTo:enddate])||([MonthStartDate isLaterThanOrEqualTo:startdate] && [MonthStartDate isEarlierThan:enddate] && [MonthEndDate isLaterThanOrEqualTo:enddate])||([MonthStartDate isEarlierThanOrEqualTo:startdate] && [MonthEndDate isEarlierThanOrEqualTo:enddate] && [MonthEndDate isLaterThanOrEqualTo:startdate])||([MonthStartDate isEarlierThanOrEqualTo:startdate] && [MonthEndDate isLaterThanOrEqualTo:enddate]))
                {
                    for (NSInteger s = 0; s < monthDataModel._arrayDateDataModel.count; s++)
                    {
                        CalendarDateDataModel *DateDataModel = monthDataModel._arrayDateDataModel[s];
                        
                        NSDate *DayStart = DateDataModel._date;
                        NSDate *DayEnd = [NSDate dateWithTimeInterval:24* 60 *60 - 1 sinceDate:DayStart];
                        if ([DayStart isLaterThanOrEqualTo:startdate] && [DayEnd isEarlierThanOrEqualTo:enddate])
                        {
                            [DateDataModel._dayModel.arrayEventList addObject:Dayeventmodel];
                        }
                        else if ([DayStart isLaterThanOrEqualTo:startdate] && [DayStart isEarlierThan:enddate] && [DayEnd isLaterThanOrEqualTo:enddate])
                        {
                            [DateDataModel._dayModel.arrayEventList addObject:Dayeventmodel];
                        }
                        else if ([DayStart isEarlierThanOrEqualTo:startdate] && [DayEnd isEarlierThanOrEqualTo:enddate] && [DayEnd isLaterThanOrEqualTo:startdate])
                        {
                            [DateDataModel._dayModel.arrayEventList addObject:Dayeventmodel];
                        }
                        else if ([DayStart isEarlierThanOrEqualTo:startdate] && [DayEnd isLaterThanOrEqualTo:enddate])
                        {
                            [DateDataModel._dayModel.arrayEventList addObject:Dayeventmodel];
                        }
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
    else if ([response isKindOfClass:[CalendarGetWeekEventResponse class]])
    {
        [self hideLoading];
        [self RecordToDiary:@"获取日程周事件列表成功"];
        for (CalendarWeekDataModel *weekmodel in self.arrWeekModels)
        {
            for (CalendarDateDataModel *daymodel in weekmodel.arrDayModels)
            {
                [daymodel._dayModel.arrayEventList removeAllObjects];
            }
        }
        
        for (NSInteger j = 0; j < ((CalendarGetWeekEventResponse *)response).arrayresult.count; j++)
        {
            CalendarLaunchrModel *Dayeventmodel = [(id)response arrayresult][j];
            NSDate * startdate = Dayeventmodel.time[0];
            NSDate * enddate = Dayeventmodel.time[1];
            
            for ( NSInteger i = 0; i < self.arrWeekModels.count ;i++)
            {
                CalendarWeekDataModel *weekmodel = self.arrWeekModels[i];
                
                for (NSInteger s = 0; s<7; s++)
                {
                    CalendarDateDataModel *datedatemodel = weekmodel.arrDayModels[s];
                    
                    NSDate *DayStart = datedatemodel._date;
                    NSDate *DayEnd = [NSDate dateWithTimeInterval:24* 60 *60-1  sinceDate:DayStart];
                    if ([DayStart isLaterThanOrEqualTo:startdate] && [DayEnd isEarlierThanOrEqualTo:enddate])
                    {
                        Dayeventmodel.isallday = YES;
                        [datedatemodel._dayModel.arrayEventList addObject:Dayeventmodel];
                    }
                    else if ([DayStart isLaterThanOrEqualTo:startdate] && [DayStart isEarlierThan:enddate] && [DayEnd isLaterThanOrEqualTo:enddate])
                    {
                        [datedatemodel._dayModel.arrayEventList addObject:Dayeventmodel];
                        Dayeventmodel.isallday = YES;
                    }
                    else if ([DayStart isEarlierThanOrEqualTo:startdate] && [DayEnd isEarlierThanOrEqualTo:enddate] && [DayEnd isLaterThanOrEqualTo:startdate])
                    {
                        [datedatemodel._dayModel.arrayEventList addObject:Dayeventmodel];
                    }
                    else if ([DayStart isEarlierThanOrEqualTo:startdate] && [DayEnd isLaterThanOrEqualTo:enddate])
                    {
                        [datedatemodel._dayModel.arrayEventList addObject:Dayeventmodel];
                    }
                }
            }
        }
        [self arrangetherule];
        [self TableviewHeaderTtitleUpdate];
        [self.CollectionViewWeek reloadData];
        [self.tableViewEventList reloadData];
        
        if (self.tableviewneedMove)
        {
            self.tableviewneedMove = NO;
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:_SelectedDate.weekday - 1];
            [self.tableViewEventList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
    else if ([response isKindOfClass:[GetMeetingDetailResponse class]]) {
        [self postSuccess];
        MeetingConfirmViewController *DetailVC = [[MeetingConfirmViewController alloc] initWithModel:[(id)response meetingModel] WithRepeatType:self.RepeatTypeOnlyForPass justSee:![self isMyself]];
        [self.navigationController pushViewController:DetailVC animated:YES];
    }
    else if ([request isKindOfClass:[CalendarGetRequest class]]) {
        [self hideLoading];
        CalendarLaunchrModel *model = [(id)response modelCalendar];
        CalendarNewEventMakeSureViewController *CNEMSVC = [[CalendarNewEventMakeSureViewController alloc] initWithModelShow:model justSee:![self isMyself]];
        [self.navigationController pushViewController:CNEMSVC animated:YES];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    if ([request isKindOfClass:[GetMeetingDetailRequest class]])
    {
        [self postError:errorMessage];
    }
    if ([request isKindOfClass:[CalendarGetWeekEventRequest class]])
    {
        [self postError:errorMessage];
    }
    if ([request isKindOfClass:[CalendarGetEventListRequest class]])
    {
        [self postError:errorMessage];
    }
    
    [self RecordToDiary:errorMessage];
}

- (void)arrangetherule
{
    for (NSInteger i = 0; i<self.arrWeekModels.count; i++)
    {
        CalendarWeekDataModel *model = self.arrWeekModels[i];
        
        for (NSInteger s = 0; s<model.arrDayModels.count; s++)
        {
            NSMutableArray *arrFestival = [[NSMutableArray alloc] init];
            NSMutableArray *arrAllDayEvent = [[NSMutableArray alloc] init];
            NSMutableArray *arrLeftEvent = [[NSMutableArray alloc] init];
            NSMutableArray *arrAll = [[NSMutableArray alloc] init];
            CalendarDateDataModel *daymodel = model.arrDayModels[s];
            [arrAll addObjectsFromArray:daymodel._dayModel.arrayEventList];
            for (NSInteger l = 0; l<arrAll.count; l++)
            {
                CalendarLaunchrModel *Dayeventmodel = [arrAll objectAtIndex:l];
                if (Dayeventmodel.eventType == eventType_statutory_festival || Dayeventmodel.eventType == eventType_company_festival)
                {
                    [arrFestival addObject:Dayeventmodel];
                }
                else if (Dayeventmodel.isallday == YES)
                {
                    [arrAllDayEvent addObject:Dayeventmodel];
                }
                else
                {
                    [arrLeftEvent addObject:Dayeventmodel];
                }
            }
            //按照时间排序感觉很不错诶！！！
            NSArray *array = [arrLeftEvent sortedArrayUsingComparator:^NSComparisonResult(CalendarLaunchrModel * obj1, CalendarLaunchrModel * obj2) {
                if (![obj1.time[0] isEarlierThanOrEqualTo:obj2.time[0]])
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }];
            [daymodel._dayModel.arrayEventList removeAllObjects];
            [daymodel._dayModel.arrayEventList addObjectsFromArray:arrFestival];
            [daymodel._dayModel.arrayEventList addObjectsFromArray:arrAllDayEvent];
            [daymodel._dayModel.arrayEventList addObjectsFromArray:array];
        }
        
        
        
    }
    
    
}

#pragma mark - CalendarMonthTableViewCellDelegate
- (void)CalendarMonthTableViewCellDelegateCallBack_DayCellClickedWithCalendarMonthDataModel:(CalendarMonthDataModel *)monthDataModel calendarDateDataModel:(CalendarDateDataModel *)dateDataModel Cell:(CalendarMonthTableViewCell *)Cell
{
    //判断与今天所在的周相差几周
    NSDate *currentdate = [NSDate date];
    NSInteger weeks = [dateDataModel._date weeksFrom:currentdate];
    _SelectedDate = dateDataModel._date;
    
    if (weeks == 0)
    {
        if (dateDataModel._date.weekOfYear != currentdate.weekOfYear)
        {
            if (dateDataModel._date.weekOfYear > currentdate.weekOfYear || (dateDataModel._date.weekOfYear == 1 && currentdate.weekOfYear > 50))
            {
                weeks = weeks + 1;
            }
            else if(dateDataModel._date.weekOfYear < currentdate.weekOfYear)
            {
                weeks = weeks - 1;
            }
        }
    }
    else
    {
        if (weeks > 0)
        {
            if (_SelectedDate.weekday > currentdate.weekday)
            {
                
            }
            else
            {
                weeks = weeks + 1;
            }
        }else
        {
            if (_SelectedDate.weekday > currentdate.weekday)
            {
                weeks = weeks - 1;
            }
        }
    }
    
    NSInteger initTimes = (abs(weeks)/10);
    if (initTimes > self.initWeeks)
    {
        if (!initTimes == 0)
        {
            for (NSInteger i = 0; i<initTimes - self.initWeeks; i++)
            {
                [self arrayWeekDataModelInit];
                [self.CollectionViewWeek reloadData];
            }
            self.initWeeks = initTimes;
        }
    }
    
    //跳转到相应的日表中的那一周
    [self.CollectionViewWeek setContentOffset:CGPointMake(self.view.frame.size.width *(10 * (self.initWeeks + 1) +weeks), 0) animated:NO];
    [self.ScrollView setContentOffset:CGPointMake(self.view.frame.size.width *1,0) animated:NO];
    [self.PageControlView setSelectedColor:1];
    [self RefreshCollectionandTableviewEventListData];
    
    self.tableviewneedMove = YES;
    
    //动画
    int LineNo;
    if ((dateDataModel._dayModel._dayNumber - 8 + (long)Cell._monthDataModel._firstWeekDay)%7 == 0)
    {
        LineNo = (dateDataModel._dayModel._dayNumber - 8 + (long)Cell._monthDataModel._firstWeekDay)/7  + 2;
    }
    else
    {
        LineNo = (dateDataModel._dayModel._dayNumber - 8 + (long)Cell._monthDataModel._firstWeekDay)/7  + 3;
    }
    
    //把cell转成image 然后按照行数切成两半 上下淡出
    UIImageView *Imgview = (UIImageView *)Cell;
    CGRect rect1;
    CGRect rect2;
    
    rect1.size.width = Imgview.frame.size.width;
    rect1.size.height = 55 * LineNo;
    
    rect2.size.width = Imgview.frame.size.width;
    rect2.size.height = Imgview.frame.size.height - 55 *LineNo;
    rect2.origin.y = 55 *LineNo;
    
    UIGraphicsBeginImageContextWithOptions(Imgview.bounds.size, YES, Imgview.layer.contentsScale);
    [Imgview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect([img CGImage], rect1);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    CGImageRef subImageRef2 = CGImageCreateWithImageInRect([img CGImage], rect2);
    CGRect smallBounds2 = CGRectMake(0, 55 * LineNo, CGImageGetWidth(subImageRef2), CGImageGetHeight(subImageRef2));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(smallBounds2.size);
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context2, smallBounds2, subImageRef2);
    UIImage* smallImage2 = [UIImage imageWithCGImage:subImageRef2];
    UIGraphicsEndImageContext();
    
    UIImageView *view1 = [[UIImageView alloc] initWithImage:smallImage];
    UIImageView *view2 = [[UIImageView alloc] initWithImage:smallImage2];
    view1.backgroundColor = [UIColor whiteColor];
    view2.backgroundColor = [UIColor whiteColor];
    
    view1.frame = CGRectMake(0, Cell.frame.origin.y - self.tableView.contentOffset.y + self.tableView.frame.origin.y + 75, self.view.frame.size.width, 55 *LineNo);
    view2.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, self.view.frame.size.width, Imgview.frame.size.height - 55 *LineNo);
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    self.blackView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    [self.view addSubview:self.blackView];
    [self.view bringSubviewToFront:self.blackView];
    [self.view bringSubviewToFront:self.ViewWeeksLabel];
    [self.view bringSubviewToFront:self.PageControlView];
    [self.view bringSubviewToFront:self.lblLine];
    
    self.MasConstraint.offset = self.tableViewEventList.frame.size.height;
    [self.tableViewEventList setNeedsLayout];
    [self.tableViewEventList layoutIfNeeded];
    
    self.MasConstraintCollection.offset = Cell.frame.origin.y - self.tableView.contentOffset.y + 75 + 55 * LineNo;
    [self.CollectionViewWeek setNeedsLayout];
    [self.CollectionViewWeek layoutIfNeeded];
    
    [UIView animateWithDuration:0.33 animations:^{
        view1.frame = CGRectMake(0, - 55*(LineNo -1) + 77, self.view.frame.size.width, 55 *LineNo);
        view2.frame = CGRectMake(0, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, Imgview.frame.size.height - 55 *LineNo);
        view1.alpha = 0.5;
        view2.alpha = 0.5;
        self.MasConstraintCollection.offset = 0;
        [self.CollectionViewWeek setNeedsLayout];
        [self.CollectionViewWeek layoutIfNeeded];
        
        self.MasConstraint.offset = 0;
        [self.tableViewEventList setNeedsLayout];
        [self.tableViewEventList layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [view2 removeFromSuperview];
        [view1 removeFromSuperview];
        [self.blackView removeFromSuperview];
        [self.view bringSubviewToFront:self.lblLine];
    }];
    
    if (self.CollectionViewWeek.contentOffset.x == (self.CollectionViewWeek.contentSize.width - self.view.frame.size.width)/2)
    {
        self.btnToday.enabled = NO;
        
    }
    else
    {
        self.btnToday.enabled = YES;
    }
}

#pragma mark - init
- (UIScrollView *)ScrollView
{
    if (!_ScrollView) {
        _ScrollView = [[UIScrollView alloc] init];
        _ScrollView.clipsToBounds = YES;
        _ScrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _ScrollView.pagingEnabled = YES;           //是否翻页
        _ScrollView.scrollEnabled = YES;
        _ScrollView.backgroundColor = [UIColor clearColor];
        _ScrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _ScrollView.showsHorizontalScrollIndicator = NO;
        _ScrollView.delegate = self;
    }
    return _ScrollView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.ScrollView.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UITableView *)tableViewEventList
{
    if (!_tableViewEventList)
    {
        _tableViewEventList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewEventList.delegate = self;
        _tableViewEventList.dataSource = self;
        _tableViewEventList.showsVerticalScrollIndicator = NO;
        _tableViewEventList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableViewEventList.backgroundColor = [UIColor whiteColor];
    }
    return _tableViewEventList;
}

- (UIView *)ContentView
{
    if (!_ContentView)
    {
        _ContentView = [[UIView alloc] init];
        _ContentView.backgroundColor = [UIColor clearColor];
    }
    return _ContentView;
}
// 搜索页面
//- (SearchView *)searchView
//{
//    if (!_searchView)
//    {
//        _searchView = [[SearchView alloc] initWithFrame:self.view.bounds];
//    }
//    return _searchView;
//}

- (UIButton *)btnToday
{
    if (!_btnToday)
    {
        _btnToday = [[UIButton alloc] init];
        [_btnToday setTitle:[NSString stringWithFormat:@" %@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY)] forState:UIControlStateNormal];
        
        [_btnToday setImage:[UIImage imageNamed:@"Calendar_TodayButton_Icon_Selected"] forState:UIControlStateHighlighted];
        [_btnToday setImage:[[UIImage imageNamed:@"Calendar_TodayButton_Icon_Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateDisabled];
        [_btnToday setImage:[UIImage imageNamed:@"Calendar_TodayButton_Icon_Unselected"] forState:UIControlStateNormal];
        [_btnToday.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [_btnToday setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        [_btnToday setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        [_btnToday setTitleColor:[UIColor themeBlue] forState:UIControlStateDisabled];
        [_btnToday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnToday.layer.borderWidth = 1.0f;
        _btnToday.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnToday.enabled = NO;
        
        [_btnToday addTarget:self action:@selector(btnTodayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnToday;
}

- (UIButton *)btnAdd
{
    if (!_btnAdd) {
        _btnAdd = [UIButton new];
        [_btnAdd.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnAdd setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        
        [_btnAdd setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        
        [_btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd setTitle:[NSString stringWithFormat:@" %@",LOCAL(CALENDAR_SCHEDULEBYWEEK_ADD)] forState:UIControlStateNormal];
        [_btnAdd setImage:[UIImage imageNamed:@"Cross_Add_Gray"] forState:UIControlStateNormal];
        [_btnAdd setImage:[UIImage imageNamed:@"Cross_Add_Blue"] forState:UIControlStateHighlighted];
        
        _btnAdd.tintColor = [UIColor themeBlue];
        _btnAdd.layer.borderWidth = 1.0f;
        _btnAdd.layer.borderColor = [UIColor grayBackground].CGColor;
    }
    return _btnAdd;
}

- (CalendarPageControlPointView *)PageControlView
{
    if (!_PageControlView)
    {
        _PageControlView = [[CalendarPageControlPointView alloc] initWithFrame:CGRectZero];
    }
    return _PageControlView;
}

- (RoundCountView *)RoundView
{
    if (!_RoundView)
    {
        _RoundView = [[RoundCountView alloc] init];
    }
    return _RoundView;
}

- (UICollectionView *)CollectionViewWeek
{
    if (!_CollectionViewWeek)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _CollectionViewWeek = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_CollectionViewWeek registerClass:[CalendarDayCollectionViewCell class]forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        _CollectionViewWeek.clipsToBounds = YES;
        _CollectionViewWeek.directionalLockEnabled = YES;
        _CollectionViewWeek.pagingEnabled = YES;
        _CollectionViewWeek.backgroundColor = [UIColor clearColor];
        _CollectionViewWeek.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
        _CollectionViewWeek.showsHorizontalScrollIndicator = NO;
        _CollectionViewWeek.delegate = self;
        _CollectionViewWeek.dataSource = self;
    }
    return _CollectionViewWeek;
}

- (NSMutableArray *)arrWeekModels
{
    if (!_arrWeekModels)
    {
        _arrWeekModels = [[NSMutableArray alloc] initWithCapacity:21];
    }
    return _arrWeekModels;
}

- (CalendarWeekDataModel *)LastWeekModels
{
    if (!_LastWeekModels)
    {
        _LastWeekModels = [[CalendarWeekDataModel alloc] init];
    }
    return _LastWeekModels;
}

- (CalendarWeekDataModel *)NextWeekModels
{
    if (!_NextWeekModels)
    {
        _NextWeekModels = [[CalendarWeekDataModel alloc] init];
    }
    return _NextWeekModels;
}

- (UIActionSheet *)actionSheet
{
    if (!_actionSheet)
    {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:LOCAL(CALENDAR_SCHEDULEBYMONTH_CANCLE)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:LOCAL(CALENDAR_ADD_ADDORDER),LOCAL(MEETING_ADDNEWMEETING),nil];
        [_actionSheet dismissWithClickedButtonIndex:0 animated:NO];
    }
    return _actionSheet;
}

- (UIView *)ViewWeeksLabel
{
    if (!_ViewWeeksLabel)
    {
        _ViewWeeksLabel = [[UIView alloc] init];
        _ViewWeeksLabel.backgroundColor = [UIColor whiteColor];
    }
    return _ViewWeeksLabel;
}

- (UIView *)blackView
{
    if (!_blackView)
    {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [UIColor whiteColor];
    }
    return _blackView;
}

- (NSMutableArray *)arrTableViewEvent
{
    if (!_arrTableViewEvent)
    {
        _arrTableViewEvent = [[NSMutableArray alloc] init];
    }
    return _arrTableViewEvent;
}

- (UILabel *)selectedLabel {
    if (!_selectedLabel) {
        _selectedLabel = [UILabel new];
        _selectedLabel.font = [UIFont mtc_font_30];
        _selectedLabel.textColor = [UIColor blackColor];
    }
    return _selectedLabel;
}

@end
