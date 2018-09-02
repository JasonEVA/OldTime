//
//  MeetingConfirmViewController.m
//  launcher
//
//  Created by Conan Ma on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingConfirmViewController.h"
#import "MeetingConfirmTitleTableViewCell.h"
#import "CalendarEventMakeSureHeaderView.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "MeetingAddNewMenberTableViewCell.h"
#import "MeetingOnlyLabelTableViewCell.h"
#import "MeetingTwoBtnsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "PlaceModel.h"
#import "UIView+Util.h"
#import "MyDefine.h"
#import "Category.h"
#import "CalendarDeleteRequest.h"
#import "MeetingAddNewMeetingViewController.h"
#import "MeetingJoinPersonModel.h"
#import "MeetingConfirmMeetingRequest.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "MeetingEditRequest.h"
#import "CalendarButtonsTableViewCell.h"
#import "CalendarViewController.h"
#import "NomarlDealWithEventView.h"

static NSString * const noMapCellIdentifier = @"noMapCellIdentifier";
static NSString *const killMapDelegateNotification = @"killMapDelegate";

@interface MeetingConfirmViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *ShowID;

@property (nonatomic, strong) PlaceModel *selectedPlace;

/** 选择了参加或不参加 */
@property (nonatomic, assign) BOOL successSelectJoin;
@property (nonatomic) calendar_repeatType RepeattypeOnlyForPass;
@property (nonatomic) BOOL NeedChangeRepeatType;

@property (nonatomic, assign) BOOL justSee;
@property (nonatomic, strong)NomarlDealWithEventView *DealWithEventview;

@property (nonatomic, assign) CGFloat mustComeCellRowHieght; //必须出席cell行高
@property (nonatomic, assign) CGFloat canComeCellRowHieght;  //选择出席cell行高

@property (nonatomic, assign) BOOL showMore;    // default YES
@property (nonatomic, assign) BOOL showMoreCC;  // default YES

@end

@implementation MeetingConfirmViewController

-(instancetype)initWithModel:(NewMeetingModel *)model
{
    if (self = [super initWithAppShowIdType:kAttachmentAppShowIdCalendar rmShowID:model.showID])
    {
        self.NeedChangeRepeatType = NO;
        self.meetingModel = model;
    }
    return self;
}

- (instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type {
    return [self initWithModel:model WithRepeatType:type justSee:NO];
}

-(instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type justSee:(BOOL)justSee
{
    if (self = [super initWithAppShowIdType:kAttachmentAppShowIdCalendar rmShowID:model.showID])
    {
        _justSee = justSee;
        self.RepeattypeOnlyForPass = type;
        self.NeedChangeRepeatType = YES;
        
        NSString *myShowId = [[UnifiedUserInfoManager share] userShowID];
        _justSee = ![myShowId isEqualToString:model.createUser];
        self.meetingModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    _showMore = YES;
    _showMoreCC = YES;
    [super viewDidLoad];
    [self setJoinRowHeight];
    self.title = LOCAL(MEETING_COMFIRM);
    [self showLeftItemWithSelector:@selector(switchToRootVC)];
    
    self.tableView.backgroundColor = [UIColor mtc_colorWithW:235];
    
    [self.tableView registerClass:[CalendarMakeSureMapTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
    [self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
    [self.tableView registerClass:[MeetingAddNewMenberTableViewCell class] forCellReuseIdentifier:[MeetingAddNewMenberTableViewCell identifier]];
    [self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:noMapCellIdentifier];
    [self.tableView registerClass:[CalendarButtonsTableViewCell class] forCellReuseIdentifier:[CalendarButtonsTableViewCell identifier]];
    
    if (!self.justSee)
    {
        UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
        [self.navigationItem setRightBarButtonItem:barbtn];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
	
    [self popGestureDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self popGestureDisabled:NO];
    if (!isUseGoogel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:killMapDelegateNotification object:nil];
    }
    
}

- (void)configCreateComment {
    NSMutableArray *arrayRequire = [NSMutableArray arrayWithArray:[self.meetingModel.requireJoin componentsSeparatedByString:@"●"]];
    NSMutableArray *arrayJoin    = [NSMutableArray arrayWithArray:[self.meetingModel.join componentsSeparatedByString:@"●"]];
    
    ![[arrayRequire firstObject] isEqualToString:@""] ?: [arrayRequire removeObjectAtIndex:0];
    ![[arrayJoin firstObject] isEqualToString:@""] ?: [arrayJoin removeObjectAtIndex:0];
    
    // 代传输
    [arrayRequire addObjectsFromArray:arrayJoin];
    
    NSMutableArray *arrayNameRequire = [NSMutableArray arrayWithArray:[self.meetingModel.requireJoinName componentsSeparatedByString:@"●"]];
    NSMutableArray *arrayJoinName    = [NSMutableArray arrayWithArray:[self.meetingModel.joinName componentsSeparatedByString:@"●"]];
    
    ![[arrayNameRequire firstObject] isEqualToString:@""] ?: [arrayNameRequire removeObjectAtIndex:0];
    ![[arrayJoinName firstObject] isEqualToString:@""] ?: [arrayJoinName removeObjectAtIndex:0];
    
    // 代传输
    [arrayNameRequire addObjectsFromArray:arrayJoinName];
    
    [self.createRequest setToUser:arrayRequire toUserName:arrayNameRequire title:self.meetingModel.title];
    [self.createRequest setRmShowId:self.meetingModel.showID];
}

#pragma mark - Privite Methods

- (void)setJoinRowHeight {
    self.mustComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.meetingModel.try_requireJoinName componentsSeparatedByString:@"●"] showMore:self.showMore accessoryTypeMode:NO];
    self.canComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.meetingModel.try_joinName componentsSeparatedByString:@"●"] showMore:self.showMoreCC accessoryTypeMode:NO];
}

- (void)switchToRootVC {
    for (id VC in [self.navigationController viewControllers]) {
        if ([VC isKindOfClass:[CalendarViewController class]]) {
            [self.navigationController popToViewController:VC animated:NO];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 是否已经确定参加 */
- (BOOL)isJoin {
    if (self.successSelectJoin)
    {
        return self.successSelectJoin;
    }
    for (MeetingJoinPersonModel *model in self.meetingModel.arrRequireJoin) {
        if (![model.NANE isEqualToString:[[UnifiedUserInfoManager share] userShowID]])
        {
            continue;
        }
        
        if (model.ISJOIN == join_unSure) {
            return NO;
        }
    }
    
    for (MeetingJoinPersonModel *model in self.meetingModel.arrJoin) {
        if (![model.NANE isEqualToString:[[UnifiedUserInfoManager share] userShowID]])
        {
            continue;
        }
        
        if (model.ISJOIN == join_unSure) {
            return NO;
        }
    }
    
    return YES;
}

/** 根据placeModel判断是否显示地图 */
- (BOOL)canUseMap {
    if (!self.selectedPlace)
    {
        return NO;
    }
    
    CLLocationCoordinate2D coordinate = self.selectedPlace.coordinate;
    if (coordinate.latitude == MAXLAT && coordinate.longitude == MAXLAT)
    {
        return NO;
    }
    return YES;
}

#pragma mark - Button Click
- (void)btnAttendbtn:(UIButton *)btn
{
    [self postLoading];
    NSInteger agree = 0;
    if (btn.tag == 111)
    {
        // 参加
        agree = 1;
    }
    else {
        // 拒绝
        agree = 0;
    }
    
    MeetingConfirmMeetingRequest *confirmRequest = [[MeetingConfirmMeetingRequest alloc] initWithDelegate:self];
    [confirmRequest ConfirmWhetherAttendWith:self.meetingModel.showID WhetherAgree:agree Reason:nil];
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

- (void)clickToDelete {
    if (self.meetingModel.repeatType == calendar_repeatNo)
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(MEETING_DELETE), nil];
        [ShowDeleteView show];
    }
    else
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(MEETING_DELETE_CURRENT),LOCAL(CALENDAR_DELETE_CURRENT_AFTER), nil];
        [ShowDeleteView show];
    }
}

- (void)clickToEdit {
    BOOL isExist = NO;
    for (UIViewController *VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[MeetingAddNewMeetingViewController class]])
        {
            isExist = YES;
            ((MeetingAddNewMeetingViewController *)VC).eventType = meeting_eventTypeEdit;
            [((MeetingAddNewMeetingViewController *)VC) setModel:self.meetingModel];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        }
    }
    if (!isExist)
    {
        MeetingAddNewMeetingViewController *addVC = [[MeetingAddNewMeetingViewController alloc] init];
        addVC.eventType = meeting_eventTypeEdit;
        [addVC setModel:self.meetingModel];
        [addVC setOriginalRepeatType:self.RepeattypeOnlyForPass];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (void)clickToForward {
    // TODO: 分享
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
        // 重复事件都删除
        saveType = 1;
    }
    
    // 删除
    [self postLoading];
    
    self.ShowID = self.meetingModel.showID;
    CalendarDeleteRequest *request = [[CalendarDeleteRequest alloc] initWithDelegate:self];
    [request deleteSheduleByRelateId:self.ShowID initialStartTime:self.meetingModel.startTime saveType:saveType];
}

#pragma mark - tableview Delegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return 15;
    }
    else
    {
        return 55;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    if (indexPath.row == 0) {
        if ([self isJoin]) {
//            return 100;
            if ([self.meetingModel.showName isEqualToString:@""] || self.meetingModel.showName == nil)
            {
                return 75;
            }
            else
            {
                return 90;
            }
        }
        else
        {
            return 133;
        }
    }
    
    if (indexPath.row == 1) {
        if ([self canUseMap]) {
            return [CalendarMakeSureMapTableViewCell height];
        }
        else if (![self.selectedPlace name].length) {
            return 0;
        }
    }
    
    if (indexPath.row == 2) {
        if (![self.meetingModel.requireJoinName length]) {
            return 0;
        } else {
            return self.mustComeCellRowHieght;
        }
    }
    
    
    if (indexPath.row == 3) {
        if (![self.meetingModel.joinName length]) {
            return 0;
        } else {
            return self.canComeCellRowHieght;
        }
    }
    
    if (indexPath.row == 5) {
        return [CalendarMakeSureDetailTableViewCell heightForCell:self.meetingModel.content];
    }
    
    if (indexPath.row == 6 && self.justSee) {
        return 0;
    }
    
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            MeetingConfirmTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingConfirmTitleTableViewCellID"];
            if (!cell) {
                cell = [[MeetingConfirmTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingConfirmTitleTableViewCellID"];
            }
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }

            [cell setData:self.meetingModel];
            
            if ([self isJoin]) {
                [cell.btnAttend setHidden:YES];
                [cell.btnRefused setHidden:YES];
            }
            
            [cell.btnAttend addTarget:self action:@selector(btnAttendbtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnRefused addTarget:self action:@selector(btnAttendbtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case 1:
        {
            if (![self canUseMap]) { // 不能使用地图
                CalendarMakeSureMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMapCellIdentifier];
                
                UIImage *image = [UIImage imageNamed:@"Calendar_Location_Logo"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [cell setAccessoryView:imageView];
                
                [cell textLabel].font = [UIFont systemFontOfSize:15];
                [cell textLabel].text = self.selectedPlace.name;
                
                cell.hidden = ![self.selectedPlace.name length];
                
                return cell;
            }
            else {
                
                CalendarMakeSureMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
                if (self.selectedPlace) {
                    [cell mapWithPlaceModel:self.selectedPlace];
                }
                return cell;
            }
        }
        case 2: // 必须出席
        case 3: // 选择出席
        {
            MeetingAddNewMenberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MeetingAddNewMenberTableViewCell identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }

            cell.myTextLabel.text = (indexPath.row == 2) ? LOCAL(MEETING_MUST_ATTEND) : LOCAL(MEETING_CANNOT_ATTEND);

            BOOL showMore = (indexPath.row == 2) ? self.showMore : self.showMoreCC;
            
            NSString *stringTmp = indexPath.row == 2 ? self.meetingModel.requireJoinName : self.meetingModel.joinName;
            NSArray *array = [stringTmp componentsSeparatedByString:@"●"];
            [cell dataWithStrings:array showMore:showMore];
            cell.hidden = ![stringTmp length];
            return cell;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingOnlyLabelTableViewCellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingOnlyLabelTableViewCellID"];
                cell.textLabel.font = [UIFont mtc_font_30];
                [cell setSeparatorInset:UIEdgeInsetsZero];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }

            }
            if (self.NeedChangeRepeatType)
            {
                NSArray *arr = @[LOCAL(CALENDAR_NEVER_REPEAT), LOCAL(CALENDAR_REPEAT_EVERYDAY), LOCAL(CALENDAR_REPEAT_EVERYWEEK), LOCAL(CALENDAR_REPEAT_EVERYMONTH), LOCAL(CALENDAR_REPEAT_EVERYYEAR)];
                cell.textLabel.text = [arr objectAtIndex:self.RepeattypeOnlyForPass];
            }
            else
            {
                cell.textLabel.text = [self.meetingModel repeatTypeString];
            }
            return cell;
        }
        case 5:
        {
            CalendarMakeSureDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
            [cell setDetailText:self.meetingModel.content];
            return cell;
        }
        case 6: {
            CalendarButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarButtonsTableViewCell identifier]];
            [cell clickedButton:^(NSInteger index) {
                if (index == 0) {
                    [self clickToEdit];
                } else {
                    [self clickToDelete];
                }
            }];
            return cell;
        }
        default:return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        if (indexPath.row == 2)
        {
            if (!self.showMore) {
                return;
            }
            
            self.showMore = NO;
            self.mustComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.meetingModel.try_requireJoinName componentsSeparatedByString:@"●"] showMore:self.showMore accessoryTypeMode:NO];
        }
        else if (indexPath.row == 3)
        {
            if (!self.showMoreCC) {
                return;
            }
            self.showMoreCC = NO;
            self.canComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.meetingModel.try_joinName componentsSeparatedByString:@"●"] showMore:self.showMoreCC accessoryTypeMode:NO];
        }
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CalendarDeleteRequest class]]) {
        [self postSuccess];
        if (((CalendarDeleteResponse *)response).isNeedEdit == 0)
        {
            [self performSelector:@selector(switchToRootVC) withObject:nil afterDelay:0.5];
        }
        else
        {
            MeetingEditRequest *request = [[MeetingEditRequest alloc] initWithDelegate:self];
            [request UpdateRepeatWithShowID:self.meetingModel.showID upDatetype:@"1"];
        }
        
    }
    else if ([request isKindOfClass:[MeetingConfirmMeetingRequest class]]) {
        [self postSuccess];
        self.successSelectJoin = YES;
        [self.tableView reloadData];
    }
    else if ([request isKindOfClass:[MeetingEditRequest class]])
    {
        [self performSelector:@selector(switchToRootVC) withObject:nil afterDelay:0.5];
    }
    
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Initializer
@synthesize createRequest = _createRequest;

- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_meetingComment];
    }
    return _createRequest;
}

- (void)setMeetingModel:(NewMeetingModel *)meetingModel {
    _meetingModel = meetingModel;
    self.selectedPlace = meetingModel.place;
    [self.tableView reloadData];
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
