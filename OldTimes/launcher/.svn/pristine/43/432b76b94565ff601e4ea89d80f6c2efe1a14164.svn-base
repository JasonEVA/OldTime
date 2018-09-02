//
//  CalendarNewEventMakeSureViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewEventMakeSureViewController.h"
#import "CalendarNewEventViewController.h"
#import "CalendarViewController.h"
#import "CalendarEventMakeSureHeaderView.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "CalendarButtonsTableViewCell.h"
#import "CalendarNewMakeSureRequest.h"
#import "CalendarDeleteRequest.h"
#import "CalendarGetRequest.h"
#import <Masonry/Masonry.h>
#import "CalendarLaunchrModel.h"
#import "PlaceModel.h"
#import "UIView+Util.h"
#import "MyDefine.h"
#import "Category.h"
#import "NomarlDealWithEventView.h"


static NSString * const noMapCellIdentifier = @"noMapCellIdentifier";
static NSString *const killMapDelegateNotification = @"killMapDelegate";

@interface CalendarNewEventMakeSureViewController ()

@property (nonatomic, strong) CalendarLaunchrModel *modelCalendar;

@property (nonatomic, strong) CalendarEventMakeSureHeaderView *tableHeaderView;

@property (nonatomic, strong)NomarlDealWithEventView *DealWithEventview;

/** 时间选择行数(默认为－1) */
@property (nonatomic, assign) NSInteger indexTime;

@property (nonatomic, readonly) CalendarLaunchrModel *readOnlyModel;

@property (nonatomic, assign) BOOL justSee;

@end

@implementation CalendarNewEventMakeSureViewController

- (instancetype)initWithModelShow:(CalendarLaunchrModel *)modelShow {
    return [self initWithModelShow:modelShow justSee:NO];
}

- (instancetype)initWithModelShow:(CalendarLaunchrModel *)modelShow justSee:(BOOL)justSee {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdCalendar rmShowID:modelShow.showId];
    if (self) {
        self.modelCalendar = modelShow;
        _justSee = justSee;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexTime = -1;
    
    self.title = LOCAL(CALENDAR_CONFIRM_CONFIRMORDER);
    
    [self showLeftItemWithSelector:@selector(clickToSure)];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.backgroundColor = [UIColor grayBackground];
    
    [self.tableView registerClass:[CalendarMakeSureMapTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
    [self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:noMapCellIdentifier];
    [self.tableView registerClass:[CalendarButtonsTableViewCell class] forCellReuseIdentifier:[CalendarButtonsTableViewCell identifier]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if (!self.justSee)
    {
        UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
        [self.navigationItem setRightBarButtonItem:barbtn];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self popGestureDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self popGestureDisabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:killMapDelegateNotification object:nil];
}

- (void)configCreateComment {
    [self.createRequest setRmShowId:self.modelCalendar.showId];
    [self.createRequest setToUser:@[] toUserName:@[] title:self.modelCalendar.title];
}

#pragma mark - Button Click
- (void)clickToSure {
    // 直接弹出标志
    BOOL canPop = NO;
    
    if ([self.modelCalendar time].count <= 2) {
        canPop = YES;
    }
    
    if (self.indexTime == -1) {
        canPop = YES;
    }
    
    if (canPop) {
        [self popViewControllerRoot];
        return;
    }
    
    [self postLoading];
    CalendarNewMakeSureRequest *request = [[CalendarNewMakeSureRequest alloc] initWithDelegate:self];
    [request sureWithShowId:[self.modelCalendar.showIdList objectAtIndex:self.indexTime]];
}

- (void)dealwithEvent
{
    if (self.DealWithEventview.canappear == NO)
    {
        self.DealWithEventview.canappear = YES;
        [self.DealWithEventview removeFromSuperview];
    }
    else
    {
        [self.DealWithEventview setpassbackBlock:^(NSInteger index) {

            if (index == 0) {
                [self clickToEdit];
            } else {
                [self clickToDelete];
            }

            [self.DealWithEventview tapdismess];
        }];
        [self.view addSubview:self.DealWithEventview];
        [self.DealWithEventview appear];
        
    }
    
}

- (void)clickToEdit {
    if (!self.modelCalendar) {
        return;
    }
    NSArray *array = [self.navigationController viewControllers];
    
    id VC = [array objectAtIndex:[array count] - 2];
    if ([VC isKindOfClass:[CalendarNewEventViewController class]]) {
        // 返回编辑模式
        [(CalendarNewEventViewController *)VC setEventType:calendar_eventTypeEdit];
        if (((CalendarNewEventViewController *)VC).modelCalendar.repeatType == calendar_repeatNo)
        {
            ((CalendarNewEventViewController *)VC).saveType = 0;
        }
        else
        {
            ((CalendarNewEventViewController *)VC).saveType = 1;
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        // 新建编辑模式
        CalendarNewEventViewController *newVC = [[CalendarNewEventViewController alloc] init];
        
        [newVC setEventType:calendar_eventTypeEdit];
        [newVC setModelCalendar:self.modelCalendar];
        
        [self.navigationController pushViewController:newVC animated:YES];
    }
}

- (void)clickToDelete
{
    if (self.modelCalendar.repeatType == calendar_repeatNo)
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE)otherButtonTitles:LOCAL(MEETING_DELETE), nil];
        [ShowDeleteView show];
    }
    else
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(MEETING_DELETE_CURRENT),LOCAL(CALENDAR_DELETE_CURRENT_AFTER), nil];
        [ShowDeleteView show];
    }
}

/** 转发 */
- (void)clickToForward {
    
}

#pragma mark - Private Method
/** 根据placeModel判断是否显示地图 */
- (BOOL)canUseMap {
    if (!self.modelCalendar.place) {
        return NO;
    }
    
    CLLocationCoordinate2D coordinate = self.modelCalendar.place.coordinate;
    if (coordinate.latitude == MAXLAT && coordinate.longitude == MAXLAT) {
        return NO;
    }
    return YES;
}

/** 跳转到日程界面 */
- (void)popViewControllerRoot {
    for (id VC in [self.navigationController viewControllers]) {
        if ([VC isKindOfClass:[CalendarViewController class]]) {
            [self.navigationController popToViewController:VC animated:NO];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AlertviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSInteger saveType = 0;
    if (buttonIndex == 2)
    {
        saveType = 1;
    }
        
    //删除代码
    [self postLoading];
    CalendarDeleteRequest *deleteRequest = [[CalendarDeleteRequest alloc] initWithDelegate:self];
    [deleteRequest deleteSheduleByShowId:self.modelCalendar.showId initialStartTime:self.modelCalendar.time[0] saveType:saveType];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CalendarNewMakeSureRequest class]] || [request isKindOfClass:[CalendarDeleteRequest class]]) {
        // 确定候补时间、删除
        [self postSuccess];
        [self performSelector:@selector(popViewControllerRoot) withObject:nil afterDelay:0.5];
    }
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//        return 3;
        return 2;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1)
    {
        return 55;
    }else
    {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row == 0 && [self canUseMap]) {
        // 地图
        return [CalendarMakeSureMapTableViewCell height];
    } else if (indexPath.row == 1) {
        // 详细
        return [CalendarMakeSureDetailTableViewCell heightForCell:self.modelCalendar.content];
    } else if (indexPath.row == 2) {
        if (self.justSee) {
            return 0;
        }
    }
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    id cell = nil;
    switch (indexPath.row) {
        case 0: // 地图
            if (![self canUseMap]) { // 不能使用地图
                cell = [tableView dequeueReusableCellWithIdentifier:noMapCellIdentifier];

                UIImage *image = [UIImage imageNamed:@"Calendar_Location_Logo"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [cell setAccessoryView:imageView];
                
                [cell textLabel].font = [UIFont mtc_font_30];
                [cell textLabel].text = self.modelCalendar.place.name;
            }
            else {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
                if (self.modelCalendar.place) {
                    [cell mapWithPlaceModel:self.modelCalendar.place];
                }
            }
            break;
        case 1: // 详细
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
            [cell setDetailText:self.modelCalendar.content];
            break;
        case 2: // buttons
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarButtonsTableViewCell identifier]];
            [cell clickedButton:^(NSInteger index) {
                if (index == 0) {
                    [self clickToEdit];
                } else {
                    [self clickToDelete];
                }
            }];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Setter Getter
- (void)setModelCalendar:(CalendarLaunchrModel *)modelCalendar {
    _modelCalendar = modelCalendar;
    [self.tableHeaderView setDataWithModel:self.readOnlyModel];
    if ([self.readOnlyModel.time count] == 2) {
        self.title = LOCAL(CALENDAR_CONFIRM_DETAILTITLE);
    }
    
    [self.tableView reloadData];
}

- (CalendarLaunchrModel *)readOnlyModel {
    return self.modelCalendar;
}

#pragma mark - Initializer
- (CalendarEventMakeSureHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[CalendarEventMakeSureHeaderView alloc] init];
        [_tableHeaderView getSelectIndexBlock:^(NSInteger index) {
            self.indexTime = index;
        }];
    }
    return _tableHeaderView;
}

@synthesize createRequest = _createRequest;
- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_eventComment];
    }
    return _createRequest;
}

- (NomarlDealWithEventView *)DealWithEventview
{
    if (!_DealWithEventview)
    {
        _DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(EDIT),LOCAL(MEETING_DELETE)]];
        _DealWithEventview.canappear = YES;
    }
    return _DealWithEventview;
}
@end
