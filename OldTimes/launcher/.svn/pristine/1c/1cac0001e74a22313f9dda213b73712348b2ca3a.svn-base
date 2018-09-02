//
//  ChatNewTaskView.m
//  launcher
//
//  Created by Lars Chen on 15/10/8.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatNewTaskView.h"
#import <Masonry.h>
#import "UIView+Util.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ChatNewTaskSelectTimeTableViewCell.h"
#import "CalendarNewEventRemindViewController.h"
#import "CalendarLaunchrModel.h"
#import "ChatSingleViewController.h"
#import "HomeTabBarController.h"
#import "TaskCreateAndEditDefine.h"
#import "TaskCreateRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "TaskNewTaskViewController.h"
#import "MissionSelectProjectViewController.h"
#import "AppTaskModel.h"
#import "WhiteBoradStatusType.h"
#import "ProjectModel.h"
#import "ProjectDetailRequest.h"
#import "UIViewController+Loading.h"
#import "UnifiedSqlManager.h"
#import "SelectContactBookViewController.h"
#import "IMApplicationEnum.h"

typedef NS_ENUM(NSUInteger, NewTaskCellStyle) {
    kNewTaskCellStyleTitle = 00,
    kNewTaskCellStyleProject,
    kNewTaskCellStyleTime,
    kNewTaskCellStylePerson,
};

#define COLOR_FONT_GRAY         [UIColor mtc_colorWithHex:0x666666]

static NSString *cellID = @"chatNewTaskCellID";

@interface ChatNewTaskView () <UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) ChatNewTaskSelectTimeTableViewCell *selectTimeCell;

// Data

/// 当前选择下的项目
@property (nonatomic, strong) ProjectModel *currentProject;

@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic) calendar_remindType remindType;
@property (nonatomic, strong) NSMutableDictionary *dictModel;

@property (nonatomic, copy) createTaskCallback createTaskBlock;
@property (nonatomic, copy) UINavigationController *(^moreBlock)();

@end

@implementation ChatNewTaskView

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
#pragma mark - PrivateMethod
- (void)initComponents
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.lbTitle];
    [self.contentView addSubview:self.btnDone];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-9.5);
        make.centerY.equalTo(self.lbTitle);
        make.width.height.equalTo(@40);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9.5);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (UIView *)createTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    
    // 跟多选项按钮
    UIButton *btnMore = [[UIButton alloc] init];
    [btnMore titleLabel].font = [UIFont systemFontOfSize:15];
    
    [btnMore setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    [btnMore setTitle:LOCAL(MISSION_MORE_CHOOSE) forState:UIControlStateNormal];
    
    btnMore.expandSize = CGSizeMake(30, 5);
    
    [btnMore addTarget:self action:@selector(btnMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:btnMore];
    
    [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    
    return footerView;
}

- (UITableViewCell *)createCellWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.section == kNewTaskCellStyleTitle)
    {
        self.textField = [UITextField new];
        [self.textField setTextColor:[UIColor blackColor]];
        [self.textField setBackgroundColor:[UIColor whiteColor]];
        [self.textField setFont:[UIFont systemFontOfSize:15]];
        [self.textField setText:[self.dictModel objectForKey:@(kNewTaskCellStyleTitle)]];
        [self.textField setDelegate:self];
        self.textField.text = self.placeTitle;
        [cell addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
    }
    else if (indexPath.section == kNewTaskCellStyleProject)
    {
        [cell.textLabel setText:LOCAL(MISSION_DETAIL_ITEM)];
        [cell.textLabel setTextColor:COLOR_FONT_GRAY];
        [cell.detailTextLabel setText:[[self.dictModel objectForKey:@(kNewTaskCellStyleProject)] name]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if (indexPath.section == kNewTaskCellStylePerson)
    {
        [cell.textLabel setText:LOCAL(MISSION_PARTICIPANT)];
        [cell.textLabel setTextColor:COLOR_FONT_GRAY];
        [cell.detailTextLabel setText:[self personString]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (!self.isGroupChat)
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    else
    {
        self.selectTimeCell = [ChatNewTaskSelectTimeTableViewCell new];
        return self.selectTimeCell;
    }
    
    
    return cell;
}

- (UIViewController *)getPresentedViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[HomeTabBarController class]]) {
        result = [(HomeTabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    
    return result;
}

- (void)reloadRealIndex:(NewTaskCellStyle)section {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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
    [self.dictModel setObject:self.textField.text forKey:@(kTaskCreateAndEditRequestTypeTitle)];
    [self.dictModel setObject:self.selectTimeCell.datePicker.date forKey:@(kTaskCreateAndEditRequestTypeDeadline)];
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
    }
}

/// 是否可以选人
- (BOOL)canSelectPerson {
    if (self.isGroupChat) {
        return YES;
    }
    
    ContactPersonDetailInformationModel *model = [self.arrPersons firstObject];
    
    return ![model.show_id isEqualToString:self.currentUserShowId];
}

#pragma mark - Interface Method
- (void)moreOptions:(UINavigationController *(^)())moreBlock {
    self.moreBlock = moreBlock;
}

#pragma mark - Cell Block
/** 选择Project */
- (void)selectProject:(ProjectModel *)project {
    
    [self.parentController postLoading];
    ProjectDetailRequest *detailRequest = [[ProjectDetailRequest alloc] initWithDelegate:self];
    [detailRequest detailShowId:project.showId];
    
    [self.dictModel setObject:project forKey:@(kTaskCreateAndEditRequestTypeProject)];
    [self reloadRealIndex:kNewTaskCellStyleProject];
    
    self.arrPersons = @[];
    [self reloadRealIndex:kNewTaskCellStylePerson];
}

#pragma mark - UITabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kNewTaskCellStyleTitle || section == kNewTaskCellStyleProject)
    {
        return 15;
    }
    else if (section == kNewTaskCellStyleTime)
    {
        return 23;
    }
    else
    {
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kNewTaskCellStyleTime)
    {
        return 285;
    }
    else
    {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self createCellWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id VC;
    switch (indexPath.section) {
        case kNewTaskCellStyleProject:
        {
            [self.tableView endEditing:YES];
            
            if (!self.parentController) {
                return;
            }
            __weak typeof(self) weakSelf = self;
            VC = [[MissionSelectProjectViewController alloc] initWithSelectProject:^(ProjectModel *project) {
                [weakSelf selectProject:project];
            }];
        }
            break;
            
        case kNewTaskCellStylePerson:
        {
            if (!self.currentProject) {
                [self.parentController postError:LOCAL(MISSION_SELECTPROJECT)];
                return;
            }
            
            if (![self canSelectPerson]) {
                return;
            }
            
            // 选择人员
            VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.arrPersons unableSelectPeople:self.currentProject.arrayMembers];
            [VC setSelectType:selectContact_none];
            [VC setSelfSelectable:YES];
            [VC setSingleSelectable:YES];
            [VC setIsMission:YES];
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
    [self.dictModel setObject:self.textField.text forKey:@(kTaskCreateAndEditRequestTypeTitle)];
}

#pragma mark - Event Responder
- (void)clickToDone
{
    [self collectData];
    
    if (![self.arrPersons count]) {
        [self.parentController postError:LOCAL(GROUP_ADDPROMPT)];
        return;
    }
    
    [self.parentController postLoading];
    
    TaskCreateRequest *createRequest = [[TaskCreateRequest alloc] initWithDelegate:self];
    [createRequest createTask:self.dictModel parentId:@""];
}

- (void)btnMoreClicked
{
    [self collectData];
    
    __weak typeof(self) weakSelf = self;
    TaskNewTaskViewController *VC = [[TaskNewTaskViewController alloc] initWithDictModel:self.dictModel CreateNewTaskBlock:^(NSMutableDictionary *dictModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.dictModel = dictModel;
        [strongSelf createAppModel];
    }];
    VC.hidesBottomBarWhenPushed = YES;
    [self.parentController dismissViewControllerAnimated:YES completion:^{
        !self.moreBlock ?: [self.moreBlock() pushViewController:VC animated:YES];
    }];
}

#pragma mark - Interface Method
- (void)dismiss {
    !self.parentController ?: [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self.parentController hideLoading];
    if ([request isKindOfClass:[TaskCreateRequest class]]) {
        
        if (self.createTaskBlock) {
            [self.dictModel setObject:[(id)response showId] forKey:@(kTaskCreateAndEditRequestTypeId)];
            [self createAppModel];
        }
    }

    else if ([request isKindOfClass:[ProjectDetailRequest class]]) {
        self.currentProject = [(id)response project];
        
        if (!self.currentUserShowId) {
            return;
            }
        
        // 单聊模式下，如果有聊天对象则直接选择聊天对象
        for (ContactPersonDetailInformationModel *model in self.currentProject.arrayMembers) {
            if (![model.show_id isEqualToString:self.currentUserShowId]) {
                continue;
            }
            
            self.arrPersons = @[model];
            [self reloadRealIndex:kNewTaskCellStylePerson];
            break;
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self.parentController postError:errorMessage];
}

#pragma mark - Init UI
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
        
        [_btnDone setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_btnDone addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (UILabel *)lbTitle
{
    if (!_lbTitle)
    {
        _lbTitle = [UILabel new];
        [_lbTitle setTextColor:COLOR_FONT_GRAY];
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
        
        _tableView.tableFooterView = [self createTableFooterView];
        
    }
    return _tableView;
}

@end
