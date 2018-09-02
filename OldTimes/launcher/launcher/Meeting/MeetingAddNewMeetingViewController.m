//
//  MeetingAddNewMeetingViewController.m
//  launcher
//
//  Created by Conan Ma on 15/8/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建会议

#import "MeetingAddNewMeetingViewController.h"
#import "MyDefine.h"
#import "Masonry.h"
#import "MeetingConfirmViewController.h"
#import "SelectContactBookViewController.h"
#import "CalendarNewEventRepeatViewController.h"
#import "CalendarNewEventRemindViewController.h"
#import "MeetingNewRequest.h"
#import "MeetingEditRequest.h"
#import "Category.h"

#import "MeetingTimeDetailViewController.h"
#import "MeetingTimeandAddressSelectView.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarAndMeetingPlaceSelectViewController.h"
#import "PlaceModel.h"
#import "NewMeetingModel.h"
#import "ContactPersonDetailInformationModel.h"
#import "CalendarDeleteRequest.h"
#import "MeetingNewRequest.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

typedef enum{
    CellTimeandAddressStyleDefaultl = 0,
    CellTimeandAddressStyleWithoutMap = 1,
    CellTimeandAddressStyleWithMap = 2,
}CellTimeandAddressStyle;

static NSString *const killMapDelegateNotification = @"killMapDelegate";
@interface MeetingAddNewMeetingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,MeetingTimeandAddressSelectViewDelegate,BaseRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;       //整个信息表
@property (nonatomic, strong) MeetingTimeandAddressSelectView *TimeandAddressSelectView;
@property (nonatomic) CellTimeandAddressStyle CellTimeandAddressStyle;

/** 成对出现时间（必须是双双的) */
@property (nonatomic, strong) NSMutableArray *timesArray;
@property (nonatomic, strong) NSString *strAddress;
@property (nonatomic, strong) NSDate *MeetingDate;

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strMustAttend;
@property (nonatomic, strong) NSString *strNeedAttend;
@property (nonatomic, strong) NSString *strDate;

@property (nonatomic, strong) NewMeetingModel *modelMeeting;    // 新建会议Model

/** 选中的必须出席 */
@property (nonatomic, strong) NSArray *arraySelectedPeople;

@property (nonatomic) CGFloat mustComeCellRowHieght; //必须出席cell行高
@property (nonatomic) CGFloat canComeCellRowHieght;  //选择出席cell行高
@property (nonatomic, copy) NSArray *mustArr;
@property (nonatomic, copy) NSArray *tryArr;
@end

@implementation MeetingAddNewMeetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCAL(MEETING_ADDNEWMEETING);
    self.mustComeCellRowHieght = 47;
    self.canComeCellRowHieght = 47;
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_ADD_CANCLE) style:UIBarButtonItemStylePlain target:self action:@selector(BackBarBtnClick)];
    [self.navigationItem setLeftBarButtonItem:leftBarBtn];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_ADD_SAVE) style:UIBarButtonItemStylePlain target:self action:@selector(SaveBarBtnClick)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    self.view.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];

    [self initData];
    [self.modelMeeting removeAllAction];
    [self CreatFrame];
    
    self.ViewNeedShow = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!isUseGoogel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:killMapDelegateNotification object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.ViewNeedShow)
    {
        self.TimeandAddressSelectView.hidden = NO;
        if (self.strAddress != nil)
        {
            self.TimeandAddressSelectView.lblbtnJumpToMap.text = self.strAddress;
        }
    }
}

- (void)dealloc {
    if (self.TimeandAddressSelectView) {
        [self.TimeandAddressSelectView removeFromSuperview];
        self.TimeandAddressSelectView = nil;
    }
}

- (void)initData
{
    if (self.modelMeeting == nil)
    {
        self.modelMeeting = [NewMeetingModel new];
        self.modelMeeting.try_requireJoin = [[UnifiedUserInfoManager share] userShowID];
        self.modelMeeting.try_requireJoinName = [[UnifiedUserInfoManager share] userName];
    }
}

- (void)CreatFrame
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setModel:(NewMeetingModel *)model
{
    self.modelMeeting = model;

    if (![self canUseMap])
    {
        self.CellTimeandAddressStyle = CellTimeandAddressStyleWithoutMap;
    }
    else
    {
        self.CellTimeandAddressStyle = CellTimeandAddressStyleWithMap;
    }
    
    [self.tableView reloadData];
}

- (void)setOriginalRepeatType:(calendar_repeatType)RepeatType
{
    self.modelMeeting.repeatType = RepeatType;
    [self.tableView reloadData];
}

#pragma mark - Privite Methods
//根据取得选中人数，返回行数
- (NSInteger)getRowNumberWithData:(NSArray *)array {
    NSString *labelText = [[NSString alloc] init];;
    NSString *labelTextTest = [[NSString alloc] init];
    for (int i = 0; i < array.count; i++) {
        if (i == 0)
        {
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        } else {
            labelText = [labelText stringByAppendingString:@"、"];
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        }
    }
    if ((self.view.frame.size.width - 110) / 10 >= labelTextTest.length)
    {
        return 45;
    } else {
        return (labelTextTest.length / ((self.view.frame.size.width - 110) / 10) + 1) * 15 + 45;
    }
}

- (void)BackBarBtnClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)btnJumpToMapClick:(UIButton *)btn
{
    if (self.TimeandAddressSelectView.isInnerMeeting)
    {
        [self.TimeandAddressSelectView.MeetingActionSheetView show];
    }
    else
    {
        self.TimeandAddressSelectView.hidden = YES;
        self.ViewNeedShow = YES;
        CalendarAndMeetingPlaceSelectViewController *CAMPSVC = [[CalendarAndMeetingPlaceSelectViewController alloc] init];
        
        [CAMPSVC getSelectedPlace:^(PlaceModel *selectedPlace) {
            self.strAddress = selectedPlace.name;
            self.TimeandAddressSelectView.strAddress = selectedPlace.name;
            self.modelMeeting.try_place = selectedPlace;

            // 会议室 场所2选1 优先场所
            self.modelMeeting.try_rShowId  = @"";
            self.modelMeeting.try_showName = @"";
        }];
        
        [self.navigationController pushViewController:CAMPSVC animated:YES];
    }
}

- (void)SaveBarBtnClick
{
    [self dismissKeyboard];
    
    if (![self checkInformation])
    {
        return;
    }
    
    if (self.eventType == meeting_eventTypeSave)
    {
        [self postLoading];
        MeetingNewRequest *newRequest = [[MeetingNewRequest alloc] initWithDelegate:self];
        [newRequest newMeetingModel:self.modelMeeting];
    }
    else if (self.eventType == meeting_eventTypeEdit)
    {
        // 这个不用try_repeatType 判断原来的类型
        if (self.modelMeeting.repeatType == calendar_repeatNo)
        {
            [self postLoading];
            CalendarDeleteRequest *deleterequest = [[CalendarDeleteRequest alloc] initWithDelegate:self];
            [deleterequest deleteSheduleByRelateId:self.modelMeeting.showID initialStartTime:self.modelMeeting.startTime saveType:0];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_SELECTEDITTYPE) message:@"" delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(CALENDAR_EDIT_CURRENT_MEETING),LOCAL(CALENDAR_EDIT_ALL_MEETINGS), nil];
            [alert show];
        }
    }
}

/** 选择必须、非必须人员 */
- (void)selectPeople:(NSArray *)selectPeople {
    NSString *join = @"";
    NSString *joinName = @"";
    NSInteger i = 0;
    
    self.arraySelectedPeople = [NSArray arrayWithArray:selectPeople];
    
    for (ContactPersonDetailInformationModel *model in selectPeople)
    {
        join = [join stringByAppendingString:model.show_id];
        joinName = [joinName stringByAppendingString:model.u_true_name];
        if (i != selectPeople.count - 1) {
            join = [join stringByAppendingString:@"●"];
            joinName = [joinName stringByAppendingString:@"●"];
        }
        i ++;
    }
    
    if (_tempMust)
    {
        self.mustArr = self.arraySelectedPeople;
        self.modelMeeting.try_requireJoin = join;
        self.modelMeeting.try_requireJoinName = joinName;
    }
    else
    {
        self.tryArr = self.arraySelectedPeople;
        self.modelMeeting.try_join = join;
        self.modelMeeting.try_joinName = joinName;
    }
    self.mustComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.modelMeeting.try_requireJoinName componentsSeparatedByString:@"●"] showMore:NO accessoryTypeMode:YES];
    self.canComeCellRowHieght = [MeetingAddNewMenberTableViewCell heightFromArrayString:[self.modelMeeting.try_joinName componentsSeparatedByString:@"●"] showMore:NO accessoryTypeMode:YES];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [self postLoading];
    NSInteger saveType = 0;
    if (buttonIndex == 2)
    {
        saveType = 1;
    }
    
    CalendarDeleteRequest *deleterequest = [[CalendarDeleteRequest alloc] initWithDelegate:self];
    [deleterequest deleteSheduleByRelateId:self.modelMeeting.showID initialStartTime:self.modelMeeting.startTime saveType:saveType];
}

- (BOOL)checkInformation {
    NSString *errorString = @"";
    if (![self.modelMeeting.try_title length]) {
        errorString = LOCAL(MEETING_INPUT_TITLE);
    } else if (![self.modelMeeting.try_requireJoin length]) {
        errorString = LOCAL(MEETING_INPUT_ATTENDERS);
    } else if (self.modelMeeting.try_startTime == 0) {
        errorString = LOCAL(MEETING_INPUT_MEETINGTIME );
    } else if (![self.modelMeeting.try_rShowId length] && !self.modelMeeting.try_place) {
        errorString = LOCAL(MEETING_INPUT_MEETINGADDRESS);
    }
    
    if (![errorString length]) {
        return YES;
    }
    
    [self postError:errorString];
    return NO;
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

/** 根据placeModel判断是否显示地图 */
- (BOOL)canUseMap {
    if (!self.modelMeeting.try_place)
    {
        self.CellTimeandAddressStyle = 1;
        return NO;
    }
    
    CLLocationCoordinate2D coordinate = self.modelMeeting.try_place.coordinate;
    if (coordinate.latitude == MAXLAT && coordinate.longitude == MAXLAT) {
        self.CellTimeandAddressStyle = 1;
        return NO;
    }
    self.CellTimeandAddressStyle = 2;
    return YES;
}

#pragma mark - tableview Delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //若联系人为小蓝色格子的返回高度： return [self getMemberCellHeightWithIndexPath:indexPath];
    if (indexPath.section == 5 && indexPath.row == 0)
    {
        return 106;
    }
    else if (indexPath.section == 2)
    {
        switch (self.CellTimeandAddressStyle)
        {
            case CellTimeandAddressStyleDefaultl:
                return 47;
            case CellTimeandAddressStyleWithoutMap:
                return 88;
            case CellTimeandAddressStyleWithMap:
                if (indexPath.row == 1) {
                    return [CalendarMakeSureMapTableViewCell height];
                }
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //必须出席
            return self.mustComeCellRowHieght;
        } else if (indexPath.row == 1) {
            //选择出席
            return self.canComeCellRowHieght;
        }
    }
    
    if (indexPath.section == 4)
    {
        return 100;
    }
    
    return 47;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            if (self.CellTimeandAddressStyle == 2 && [self canUseMap])
            {
                return 2;
            }else
            {
                return 1;
            }
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            MeetingTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTextFieldTableViewCellID"];
            if (!cell) {
                cell = [[MeetingTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingTextFieldTableViewCellID"];
            }
            cell.tfdTitle.delegate = self;
            cell.tfdTitle.text = self.modelMeeting.try_title;
            return cell;
        }
            break;
        case 1: //必须出席，选择出席
        {
            MeetingAddNewMenberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MeetingAddNewMenberTableViewCell identifier]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSString *title ;
            NSArray *array ;
            if (indexPath.row == 0)
            {
                title = LOCAL(MEETING_MUST_ATTEND);
                array = [self.modelMeeting.try_requireJoinName componentsSeparatedByString:@"●"];
                NSMutableArray *arrayAddSelf = [NSMutableArray arrayWithArray:array];
                if ([[arrayAddSelf firstObject] isEqualToString:@""]) {
                    [arrayAddSelf removeLastObject];
                }
                
                array = [NSArray arrayWithArray:arrayAddSelf];
            }
            else {
                title = LOCAL(MEETING_CANNOT_ATTEND);
                array = [self.modelMeeting.try_joinName componentsSeparatedByString:@"●"];
            }
            cell.myTextLabel.text = title;
            [cell dataWithStrings:array showMore:NO];
            
            return cell;
        }
            break;
        case 2:
        {
            if (self.CellTimeandAddressStyle == 0)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repeatremindCellID"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"repeatremindCellID"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell textLabel].font = [UIFont mtc_font_30];
                }
                
                cell.textLabel.text = LOCAL(MEETING_CHOOSETIME_ADDRESS);
                return cell;
            
                break;
            }
            else
            {
                if (![self canUseMap]) { // 不能使用地图
                    MeetingTimeAndAddressWithoutMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTimeAndAddressWithoutMapTableViewCellID"];
                    if (!cell)
                    {
                        cell = [[MeetingTimeAndAddressWithoutMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeetingTimeAndAddressWithoutMapTableViewCellID"];
                    }
                    cell.lblTitle.text = LOCAL(MEETING_CHOOSETIME_ADDRESS);
                    cell.lblAddress.text = [self.modelMeeting.try_showName stringByAppendingString:self.modelMeeting.try_place.name];
                    cell.lblTime.text = [self.modelMeeting.try_startTime mtc_startToEndDate:self.modelMeeting.try_endTime];
                    return cell;
                }
                else
                {
                    if (indexPath.row == 0)
                    {
                        MeetingAddNewMenberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MeetingAddNewMenberTableViewCell identifier]];

                        cell.textLabel.text = LOCAL(MEETING_CHOOSETIME_ADDRESS);
                        NSString *str = [self.modelMeeting.try_startTime mtc_startToEndDate:self.modelMeeting.try_endTime];
                        cell.detailTextLabel.text = str;
                        return cell;
                    }
                    else
                    {
                        
                            CalendarMakeSureMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
                            if (self.modelMeeting.try_place)
                            {
                                [cell mapWithPlaceModel:self.modelMeeting.try_place];
                            }
                            return cell;
                        
                    }
                }

            }

        }
            break;
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repeatremindCellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"repeatremindCellID"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell textLabel].font = [UIFont mtc_font_30];
                [cell detailTextLabel].font = [UIFont mtc_font_30];
            }
            
//            BOOL isThird = indexPath.section == 3;
//            cell.textLabel.text = LOCAL((isThird ? MEETING_REMIND : MEETING_NOTIFICATE));
//            cell.detailTextLabel.text = isThird ? [self.modelMeeting repeatTypeString] : [self.modelMeeting remindTypeString];
            cell.textLabel.text = LOCAL(MEETING_NOTIFICATE);
            cell.detailTextLabel.text = [self.modelMeeting remindTypeString];
            return cell;
        }
            break;
        case 4:
        {
            MeetIngTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MeetIngTextViewTableViewCell identifier]];
            cell.textView.delegate = self;
            [cell setContent:self.modelMeeting.try_content ?: @""];
            return cell;
        }
            break;
            
        default: return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section)
    {
        case 1:
        {
            _tempMust = indexPath.row == 0;
            
            NSArray *arrSelected = _tempMust ? self.mustArr : self.tryArr;
            NSArray *arrUnableSelect = !_tempMust ? self.mustArr : self.tryArr;
//            NSString *stringSelected     = _tempMust ? self.modelMeeting.try_requireJoin : self.modelMeeting.try_join;
//            NSString *stringUnableSelect = !_tempMust ? self.modelMeeting.try_requireJoin : self.modelMeeting.try_join;
            
            SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:[arrSelected count] ? arrSelected : @[]
                                                                                               unableSelectPeople:[arrUnableSelect count] ? arrUnableSelect : @[]];
			__weak typeof(self) weakSelf = self;
            [VC selectedPeople:^(NSArray *selectedPeople) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectPeople:selectedPeople];
            }];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            if (![self.timesArray count]) {
                if (!self.modelMeeting.try_startTime && !self.modelMeeting.try_endTime)
                {
                    NSDate *startDate = [NSDate dateByCalculatorMinuteIntervalDidChange:nil];
                    NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60];
                    [self.timesArray addObjectsFromArray:@[startDate, endDate]];
                }
                else {
                    [self.timesArray addObjectsFromArray:@[self.modelMeeting.try_startTime, self.modelMeeting.try_endTime]];
                }
            }
            
            self.TimeandAddressSelectView = [[MeetingTimeandAddressSelectView alloc] initWithMeetingModel:self.modelMeeting timeList:self.timesArray];
            self.TimeandAddressSelectView.delegate = self;
            [self.TimeandAddressSelectView.btnJumpToMap addTarget:self action:@selector(btnJumpToMapClick:) forControlEvents:UIControlEventTouchUpInside];
            self.ViewNeedShow = YES;
            [self.TimeandAddressSelectView showWithMeetingRoom:YES];
        }
            break;
//        case 3:         // 重复
//        {
//            CalendarNewEventRepeatViewController *CNERVC = [[CalendarNewEventRepeatViewController alloc] initWithRepeatType:^(NSInteger repatType) {
//                self.modelMeeting.repeatType = repatType;
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }];
//            
//            [self.navigationController pushViewController:CNERVC animated:YES];
//            break;
//        }
//            break;
        case 3:         // 通知
        {
            CalendarNewEventRemindViewController *CNERVC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:NO RemindType:^(NSInteger remindType) {
                self.modelMeeting.try_remindType = remindType;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CNERVC animated:YES];
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

#pragma mark - TextView Delegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.modelMeeting.try_content = textView.text;
}

#pragma mark - TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.modelMeeting.try_title = textField.text;
}

#pragma mark - MeetingTimeandAddressSelectViewDelegate
- (void)MeetingTimeandAddressSelectViewDelegateCallBack_SelectTimes:(NSArray *)timeArray address:(MeetingRoomListModel *)model
{
    self.ViewNeedShow = NO;
    
    if (timeArray != nil)
    {
        if (![self canUseMap])
        {
            self.CellTimeandAddressStyle = 1;
        }
        else
        {
            self.CellTimeandAddressStyle = 2;
        }
        
        self.modelMeeting.try_startTime = timeArray[0];
        self.modelMeeting.try_endTime = timeArray[1];
        
        
        if (model != nil)
        {
            self.modelMeeting.try_showName = model.name;
            self.modelMeeting.try_rShowId = model.ID;
//            self.modelMeeting.rShowId = model.ID;
//            self.modelMeeting.showName = model.name;
        }
        else
        {
            self.modelMeeting.try_showName = @"";
            self.modelMeeting.try_rShowId = @"";
        }
        
        
        self.timesArray = [NSMutableArray arrayWithArray:timeArray];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)MeetingTimeandAddressSelectViewDelegateCallBack_ShowDetailTimeArrange:(NSDate *)date
{
    MeetingTimeDetailViewController *VC = [[MeetingTimeDetailViewController alloc] initWithDate:date];
    
    [VC setRequired:self.modelMeeting.try_requireJoin];
    [VC setRequiredName:self.modelMeeting.try_requireJoinName];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)delegateposterror:(NSString *)string
{
    [self postError:string];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[CalendarDeleteRequest class]])
    {
        [self RecordToDiary:@"删除会议成功"];
        if (((CalendarDeleteResponse *)response).isNeedEdit == 0)
        {
            MeetingNewRequest *newrequest = [[MeetingNewRequest alloc] initWithDelegate:self];
            [newrequest newMeetingModel:self.modelMeeting];
        }
        else
        {
            MeetingEditRequest *request = [[MeetingEditRequest alloc] initWithDelegate:self];
            [request UpdateRepeatWithShowID:self.modelMeeting.showID upDatetype:@"1"];
        }
    }
    else if ([response isKindOfClass:[MeetingNewResponse class]])
    {
        [self.modelMeeting refreshAction];
        [self hideLoading];
        BOOL isExist = NO;
        for (UIViewController *VC in self.navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[MeetingConfirmViewController class]])  {
                isExist = YES;
                MeetingConfirmViewController *confirmMeetingVC = (MeetingConfirmViewController *)VC;
                confirmMeetingVC.meetingModel = self.modelMeeting;
                [self.navigationController popViewControllerAnimated:NO];
                break;
            }
        }
        if (!isExist)
        {
            MeetingConfirmViewController *VC = [[MeetingConfirmViewController alloc] initWithModel:self.modelMeeting];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else if ([request isKindOfClass:[MeetingEditRequest class]])
    {
        [self.modelMeeting refreshAction];
        if (self.eventType == meeting_eventTypeEdit)
        {
            MeetingNewRequest *newrequest = [[MeetingNewRequest alloc] initWithDelegate:self];
            [newrequest newMeetingModel:self.modelMeeting];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
    [self RecordToDiary:[NSString stringWithFormat:@"meetingandmeeting:%@",errorMessage]];
}

#pragma mark - Initializer
- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor grayBackground];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

        [_tableView registerClass:[CalendarMakeSureMapTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
        [_tableView registerClass:[MeetingAddNewMenberTableViewCell class] forCellReuseIdentifier:[MeetingAddNewMenberTableViewCell identifier]];
        [_tableView registerClass:[MeetIngTextViewTableViewCell class] forCellReuseIdentifier:[MeetIngTextViewTableViewCell identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)timesArray
{
    if (!_timesArray)
    {
        _timesArray = [NSMutableArray array];
    }
    return _timesArray;
}

- (NSArray *)mustArr
{
    if (!_mustArr) {
        _mustArr = [[NSArray alloc] init];
    }
    return _mustArr;
}

- (NSArray *)tryArr
{
    if (!_tryArr) {
        _tryArr = [[NSArray alloc] init];
    }
    return _tryArr;
}

@end
