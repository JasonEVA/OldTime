//
//  NewChatNewTaskView.m
//  launcher
//
//  Created by 马晓波 on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewChatNewTaskView.h"
#import <Masonry.h>
#import "UIView+Util.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ChatNewTaskSelectTimeTableViewCell.h"
#import "CalendarNewEventRemindViewController.h"
#import "CalendarLaunchrModel.h"
#import "ChatSingleViewController.h"
#import "TaskCreateAndEditDefine.h"
#import "ContactPersonDetailInformationModel.h"
#import "TaskNewTaskViewController.h"
#import "MissionSelectProjectViewController.h"
#import "AppTaskModel.h"
#import "WhiteBoradStatusType.h"
#import "ProjectModel.h"
#import "UIViewController+Loading.h"
#import "UnifiedSqlManager.h"
#import "SelectContactBookViewController.h"
#import "UIFont+Util.h"
#import "NewMissionTimeSelectView.h"
#import "NSDate+String.h"
#import "NewMissionSelectProjectViewController.h"
#import "NewTaskCreateRequest.h"
#import "IMApplicationEnum.h"
#import "NewMissionAddMissionViewController.h"
#include "NewMissionDetailModel.h"
#import "NewChatNewTaskViewTItleCell.h"
typedef NS_ENUM(NSUInteger, NewTaskCellStyle) {
    kNewTaskCellStyleTitle = 00,
    kNewTaskCellStyleBeginTime = 10,
    kNewTaskCellStyleEndTime = 11,
    kNewTaskCellStylePerson = 20,
    kNewTaskCellStyleProject = 21,
};

static NSString *cellID = @"chatNewTaskCellID";

@interface NewChatNewTaskView () <UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate,UITextFieldDelegate,NewMissionTimeSelectViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) ChatNewTaskSelectTimeTableViewCell *selectTimeCell;
@property (nonatomic, strong) UIView *shadowView;
// Data

/// 当前选择下的项目
@property (nonatomic, strong) ProjectModel *currentProject;

@property (nonatomic, assign) BOOL wholeDay;
@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic) calendar_remindType remindType;
@property (nonatomic, strong) NSMutableDictionary *dictModel;

@property (nonatomic, copy) createTaskCallback createTaskBlock;
@property (nonatomic, copy) UINavigationController *(^moreBlock)();
@property(nonatomic, strong) NewChatNewTaskViewTItleCell  *titleCell;

@end

@implementation NewChatNewTaskView

- (instancetype)initCreateNewTaskWithTitle:(NSString *)title block:(createTaskCallback)taskBlock {
    self = [self initCreateNewTaskBlock:taskBlock];
    if (self) {
        _placeTitle = title;
    }
    
    return self;
}

- (instancetype)initCreateNewTaskBlock:(createTaskCallback)taskBlock;
{
    if (self = [super init])
    {
        self.createTaskBlock = taskBlock;
        
        self.dictModel = [NSMutableDictionary new];
        
        [self initComponents];
    }
    
    return self;
}
#pragma mark - Private Method
- (void)initComponents
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.lbTitle];
    [self.contentView addSubview:self.btnDone];
    [self.contentView addSubview:self.btnCancel];
    [self initConstraints];
}

- (void)initConstraints
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@360);
//        make.bottom.equalTo(self).offset(45);
        make.centerY.equalTo(self);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-9.5);
        make.centerY.equalTo(self.lbTitle);
        make.height.equalTo(@40);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(9.5);
        make.centerY.equalTo(self.lbTitle);
        make.height.equalTo(@40);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9.5);
        make.centerX.equalTo(self.contentView);
    }];
}

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexneed = indexPath.row + indexPath.section * 10;
    UITableViewCell *cell;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    [cell.textLabel setFont:[UIFont mtc_font_30]];
    [cell.detailTextLabel setFont:[UIFont mtc_font_30]];
    
    switch (indexneed)
    {
        case kNewTaskCellStyleTitle:
        {
            NewChatNewTaskViewTItleCell * tcell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatNewTaskViewTItleCell identifier]];
            self.titleCell = tcell;
            [tcell setTitle:self.placeTitle];
            if ([self.dictModel objectForKey:@(kNewTaskCellStyleTitle)]) {
                [tcell setTitle:[self.dictModel objectForKey:@(kNewTaskCellStyleTitle)]];
            }
            [tcell getTextWithBlock:^(NSString *title) {
                self.titleStr = title;
            }];
            return tcell;
            
        }
            break;
        case kNewTaskCellStyleBeginTime:
        {
            [cell.textLabel setText:LOCAL(NEWMISSION_SELECT_START_TIME)];
            [cell.textLabel setTextColor:[UIColor mediumFontColor]];
            id time;
            time = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
            if (time) {
                time = [time mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue]];
            } else {
                time = LOCAL(NONE);
            }
            [cell.detailTextLabel setText:time];
            [cell.detailTextLabel setTextColor:[UIColor blackColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
            break;
        case kNewTaskCellStyleEndTime:
        {
            [cell.textLabel setText:LOCAL(MISSION_ENDTIME)];
            [cell.textLabel setTextColor:[UIColor mediumFontColor]];
            id time;
            time = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
            if (time) {
                time = [time mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue]];
            } else {
                time = LOCAL(NONE);
            }
            [cell.detailTextLabel setText:time];
            [cell.detailTextLabel setTextColor:[UIColor blackColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
            break;
        case kNewTaskCellStylePerson:
        {
            [cell.textLabel setText:LOCAL(MISSION_PARTICIPANT)];
            [cell.textLabel setTextColor:[UIColor mediumFontColor]];
            [cell.detailTextLabel setText:[self personString]];
            [cell.detailTextLabel setTextColor:[UIColor blackColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            if (!self.isGroupChat)
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
            break;
        case kNewTaskCellStyleProject:
        {
            [cell.textLabel setText:LOCAL(MISSION_DETAIL_ITEM)];
            [cell.textLabel setTextColor:[UIColor mediumFontColor]];
            [cell.detailTextLabel setText:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)] name]];
            [cell.detailTextLabel setTextColor:[UIColor blackColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            if ([cell.detailTextLabel.text isEqualToString:@""]||cell.detailTextLabel.text == nil)
            {
               [cell.detailTextLabel setText:LOCAL(NONE)];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)reloadRealIndex:(NewTaskCellStyle)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section % 10 inSection:section / 10];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/** 获取分配组成的string */
- (NSString *)personString {
    if (!self.arrPersons || ![self.arrPersons firstObject]) {
        return @"";
    }
    
    ContactPersonDetailInformationModel *model = [self.arrPersons firstObject];
    return model.u_true_name;
}

// 收集数据
- (void)collectData
{
    [self.dictModel setObject:self.titleStr?:@"" forKey:@(kTaskCreateAndEditRequestTypeTitle)];
    [self.dictModel setObject:self.arrPersons ?:@[] forKey:@(kTaskCreateAndEditRequestTypePeople)];
}

// 创建并返回appModel
- (void)createAppModel
{
    MessageAppModel *appModel = [MessageAppModel new];
    appModel.msgTitle = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeTitle)];
    appModel.msgContent = appModel.msgTitle;
    appModel.eventType = IM_Applicaion_task;
    appModel.msgAppShowID = [MessageAppModel getShowIDfromAppType:(Msg_type)IM_Applicaion_task];
    appModel.msgType = 1;
    appModel.msgAppType = @"";
    appModel.msgReadStatus = 0;
    appModel.msgHandleStatus = 0;
    
    AppTaskModel *taskModel = [AppTaskModel new];
    
    taskModel = [AppTaskModel new];
    taskModel.title = appModel.msgTitle;
    appModel.msgFrom = [[UnifiedUserInfoManager share] userName];
    NSDate *deadLine = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
    long long timeInterval = [deadLine timeIntervalSince1970] * 1000;
    taskModel.end = timeInterval;
    ProjectModel *projectModel = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)];
    taskModel.projectName = projectModel.name;
    taskModel.content = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeComment)];
    
    NSNumber *priorityNumber  = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypePriority)];
    taskModel.priority = [WhiteBoradStatusType getMissionPriorityString:[priorityNumber integerValue]];
    taskModel.level = [priorityNumber integerValue];
    taskModel.id = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeId)];
    taskModel.allTask = 0;
    taskModel.finishTask = 0;
    taskModel.stateName = @"待办";
    
    appModel.msgInfo = [taskModel.mj_keyValues mj_JSONString];
    
    NSArray * array = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypePeople)];
    ContactPersonDetailInformationModel * model;
    if (array.count == 0) {
        model = [ContactPersonDetailInformationModel new];
    }else {
        model = array[0];
    }
    
    [self.parentController postSuccess];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    
    if (self.isGroupChat || ![self canSelectPerson]) {
        !self.createTaskBlock ?:self.createTaskBlock(appModel,model);
        self.createTaskBlock = nil;
    }
}

/// 是否可以选人
- (BOOL)canSelectPerson {
    if (self.isGroupChat) {
        return YES;
    }
    
    ContactPersonDetailInformationModel *model = [self.arrPersons firstObject];
    
    return ![model.show_id isEqualToString:self.currentUserModel.show_id];
}

#pragma mark - Interface Method
- (void)moreOptions:(UINavigationController *(^)())moreBlock {
    self.moreBlock = moreBlock;
}

- (void)setCurrentUserModel:(ContactPersonDetailInformationModel *)currentUserModel {
    _currentUserModel = currentUserModel;
    if (currentUserModel) {
        self.arrPersons = @[currentUserModel];
    }
}


#pragma mark - Cell Block
/** 选择Project */
- (void)selectProject:(ProjectModel *)project {
	if (project) {
		[self.dictModel setObject:project forKey:@(kTaskCreateAndEditRequestTypeProject)];
	} else {
		[self.dictModel removeObjectForKey:@(kTaskCreateAndEditRequestTypeProject)];
	}
	
    [self reloadRealIndex:kNewTaskCellStyleProject];
}

#pragma mark - UITabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.001; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 45; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self createCellWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger realIndex = indexPath.row + indexPath.section * 10;
    id VC;
    switch (realIndex) {
        case kNewTaskCellStyleProject:
        {
            [self.tableView endEditing:YES];
            
            if (!self.parentController) {
                return;
            }
            __weak typeof(self) weakSelf = self;
			NewMissionSelectProjectViewController *VC = [[NewMissionSelectProjectViewController alloc] initWithSelectProject:^(ProjectModel *project) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectProject:project];
            }];
			
            if (!VC) {
                return;
            }
			ProjectModel *model = self.dictModel[@(kTaskCreateAndEditRequestTypeProject)];
			if (model && model.showId && ![model.showId isEqualToString:@""]) {
				VC.selectedProjectShowID = model.showId;
			}
			
            [self.parentController.navigationController pushViewController:VC animated:YES];
            return;
        }
            break;
            
        case kNewTaskCellStylePerson:
        {
            // 选择人员
            VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.arrPersons unableSelectPeople:nil];
            [VC setSelectType:selectContact_none];
            [VC setSelfSelectable:YES];
            [VC setSingleSelectable:YES];
//            [VC setIsMission:YES];
            __weak typeof(self) weakSelf = self;
            [VC selectedPeople:^(NSArray *people) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                ContactPersonDetailInformationModel *person = [people firstObject];
                
                strongSelf.arrPersons = person ? @[person] : @[];
                [strongSelf reloadRealIndex:kNewTaskCellStylePerson];
            }];
            
            [self.parentController presentViewController:VC animated:YES completion:nil];
            return;
        }
            break;
        case kNewTaskCellStyleBeginTime:
        {
            NewMissionTimeSelectView *sheetView = [[NewMissionTimeSelectView alloc] init];
            sheetView.backgroundColor = [UIColor clearColor];
            [sheetView setShowWholeDayMode:YES];
            sheetView.delegate = self;
            [sheetView setTitle:LOCAL(NEWMISSION_SELECT_START_TIME) noSelect:LOCAL(NONE)];
            sheetView.task_identifier = realIndex;
            
            [self.contentView addSubview:self.shadowView];
            [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [sheetView wholeDayIsOn:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue]];
            NSDate *date = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
            if (date) {
                [sheetView setDate:date];
            }
            
            [self.parentController.view addSubview:sheetView];
        }
            break;
        case kNewTaskCellStyleEndTime:
        {
            NewMissionTimeSelectView *sheetView = [[NewMissionTimeSelectView alloc] init];
            sheetView.backgroundColor = [UIColor clearColor];
            [sheetView setShowWholeDayMode:YES];
            sheetView.delegate = self;
            [sheetView setTitle:LOCAL(NEWMISSION_SELECT_END_TIME) noSelect:LOCAL(NONE)];
            sheetView.task_identifier = realIndex;
            
            [self.contentView addSubview:self.shadowView];
            [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [sheetView wholeDayIsOn:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue]];
            NSDate *date = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
            if (date) {
                [sheetView setDate:date];
            }
            
            [self.parentController.view addSubview:sheetView];
        }
            break;
        default:
            break;
    }
    
    if (!VC) {
        return;
    }

    [self.parentController.navigationController pushViewController:VC animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
    [self.dictModel setObject:self.titleStr?:@"" forKey:@(kTaskCreateAndEditRequestTypeTitle)];
}

#pragma mark - Event Responder
- (void)clickToDone
{
    [self.titleCell setEndEditing];
    [self collectData];

    if (![self.arrPersons count]) {
        [self.parentController postError:LOCAL(GROUP_ADDPROMPT)];
        return;
    }
    
    [self.parentController postLoading];
    
    NewTaskCreateRequest *createRequest = [[NewTaskCreateRequest alloc] initWithDelegate:self];
    [createRequest createTask:self.dictModel parentId:@""];
}

- (void)clickToMore {
    if (self.moreBlock)
    {
        UINavigationController *nav = self.moreBlock();
        [nav dismissViewControllerAnimated:YES completion:^{
            [self collectData];
            
            NewMissionAddMissionViewController *vc = [[NewMissionAddMissionViewController alloc] initWithCreatMainMission];
            vc.missionDict = self.dictModel;
			vc.hidesBottomBarWhenPushed = YES;
			
            [nav pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark - Interface Method
- (void)dismiss {
    !self.parentController ?: [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NewMissionTimeSelectView Delegate
- (void)NewMissionTimeSelectView:(NewMissionTimeSelectView *)timeView didSelectDate:(NSDate *)date {
    TaskCreateAndEditRequestType timeType;
    TaskCreateAndEditRequestType wholeDayType;
    NewTaskCellStyle reloadCellType = timeView.task_identifier;
    
    if (reloadCellType == kNewTaskCellStyleBeginTime) {
        
        timeType = kTaskCreateAndEditRequestTypeStartTime;
        wholeDayType = kTaskCreateAndEditRequestTypeIsStartTimeAllDay;
    } else {
        
        timeType = kTaskCreateAndEditRequestTypeDeadline;
        wholeDayType = kTaskCreateAndEditRequestTypeIsEndTimeAllDay;
    }
    
    if (date) {
        [self.dictModel setObject:date forKey:@(timeType)];
    } else {
        [self.dictModel removeObjectForKey:@(timeType)];
    }
    
    [self.dictModel setObject:@(self.wholeDay) forKey:@(wholeDayType)];
    [self reloadRealIndex:reloadCellType];
}

- (void)NewMissionTimeSelectViewDelegateCallBack_isWholeDay:(BOOL)isWholdDay {
    self.wholeDay = isWholdDay;
    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
}

- (void)NewMissionTimeSelectViewDelegateCallBack_closeDeadlineSwitch {
    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self.parentController hideLoading];
    if ([request isKindOfClass:[NewTaskCreateRequest class]]) {
        
        if (self.createTaskBlock) {
            [self.dictModel setObject:[(id)response showId] forKey:@(kTaskCreateAndEditRequestTypeId)];
            [self createAppModel];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self.parentController postError:errorMessage];
}

#pragma mark - Init UI

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *moreButton = [UIButton new];
    moreButton.titleLabel.font = [UIFont mtc_font_30];
    
    [moreButton setTitle:LOCAL(MISSION_MORE_CHOOSE) forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    
    moreButton.expandSize = CGSizeMake(30, 5);
    
    [moreButton addTarget:self action:@selector(clickToMore) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    
    return footerView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor mtc_colorWithHex:0xEBEBEB];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)btnDone
{
    if (!_btnDone)
    {
        _btnDone = [[UIButton alloc] init];
        
        [_btnDone setTitle:LOCAL(CONFIRM) forState:UIControlStateNormal];
        [_btnDone setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        _btnDone.titleLabel.font = [UIFont mtc_font_30];
        [_btnDone addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] init];
        
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont mtc_font_30];
        [_btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UILabel *)lbTitle
{
    if (!_lbTitle)
    {
        _lbTitle = [UILabel new];
        [_lbTitle setTextColor:[UIColor mediumFontColor]];
        [_lbTitle setText:LOCAL(MISSION_NEWTASK_TITLE)];
        [_lbTitle setFont:[UIFont systemFontOfSize:15]];
    }
    
    return _lbTitle;
}
 
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
       _tableView.tableFooterView = [self tableFooterView];
        [_tableView registerClass:[NewChatNewTaskViewTItleCell class] forCellReuseIdentifier:[NewChatNewTaskViewTItleCell identifier]];
    }
    return _tableView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _shadowView.layer.cornerRadius = 5.0;
        _shadowView.layer.masksToBounds = YES;
    }
    return _shadowView;
}

@end
