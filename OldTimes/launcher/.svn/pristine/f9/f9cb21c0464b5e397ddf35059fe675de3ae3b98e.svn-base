//
//  MissionMianViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionMianViewController.h"
#import "MissionDetailViewController.h"
#import "MissionNavBar.h"
#import "MissionMainTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MissionMenuView.h"
#import "MissionPickerBar.h"
#import "TestMaininterfaceViewControlViewController.h"
#import "TaskWhiteBoardViewController.h"
#import "TaskNewTaskViewController.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "MissionDetailModel.h"
#import "GetWhiteBoardListRequest.h"
#import "ProjectModel.h"
#import <MJRefresh/MJRefresh.h>
#import "SearchMissionListRequest.h"
#import "GetTaskListRequest.h"
#import "GetTaskDetailRequest.h"
#import "MissionDetailModel.h"
#import "TaskWhiteBoardModel.h"
#import "TaskChangeWhiteBoardRequest.h"
#import <DateTools/DateTools.h>
#import "TaskEditRequest.h"
#import "TaskCreateAndEditDefine.h"
#import "GetAllCommentRequest.h"
#import "TaskAddNewProgressViewController.h"
#import "MixpanelMananger.h"
#import "MyDefine.h"

typedef NS_ENUM(NSUInteger, footerViewStyle) {
    footerViewStyleNone = 0,
    /** new doing done commit */
    footerViewStyleStats,
    /** 今天 明天 后天 一周后 */
    footerViewStyleTime,
};

typedef NS_ENUM(NSInteger, taskActionType) {
    taskActionTypeChangeTime = 0,
    taskActionTypeDetail,
    taskActionTypeEdit,
};

@interface MissionMianViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, MissionMenuViewDelegate, UITextFieldDelegate, MissionPickerBarDelegate, MissionNavBarDelegate, MissionMainTableViewCellDelegate, BaseRequestDelegate, ApplyAddDeadlineActionSheetViewDelegate> {
    TaskWhiteBoardViewController *_whiteBoardVC; // 里面加了手势delegate，不提出来写就报错！！！！毙了🐶了
}
@property (nonatomic, strong) MissionNavBar  *navBar;
@property (nonatomic, strong) UITableView  *missionTableView;
/** 底部menu */
@property (nonatomic, strong) MissionMenuView  *menuBar;
/** 快速输入标题 */
@property (nonatomic, strong) UITextField  *titleTxfd;
/** 中间工具栏的容器 */
@property (nonatomic, strong) UIView *contentView;

// Data

/** 子导航栏标题事件 */
@property (nonatomic, strong) NSArray *itemTitleArray;

/** 显示footerView的Index（初始化－1） */
@property (nonatomic, assign) NSInteger showSection;
@property (nonatomic, assign) footerViewStyle showFooterStyle;

/** 用于过滤条件下查询任务 */
@property (nonatomic, strong) SearchMissionListRequest *searchRequest;
@property (nonatomic, strong) GetTaskListRequest *taskRequest;

/** 存储任务的数据（按白板分组）(数据ARRAY中最后第二个存储是否还有剩余数据,lastOne请求pageIndex（初始化为1）) */
@property (nonatomic, strong) NSMutableDictionary *dictData;
/**
 *  根据项目showId存储项目的白板
 */
@property (nonatomic, strong) NSMutableDictionary *dictWhiteBoard;

/** 为nil时则当前是只显示New状态 */
@property (nonatomic, strong) TaskWhiteBoardModel *currentWhiteBoard;

/** 修改时间时，存储时间专用 */
@property (nonatomic, copy) NSDate *selectedDate;

/** 有评论的数据 */
@property (nonatomic, strong) NSDictionary *dictComments;


@property (nonatomic, strong) ProjectModel *currentProject;
@property (nonatomic, assign) ProjectSearchType searchType;
@property (nonatomic, strong) UIView *emptyPageView; //空白页

@end

@implementation MissionMianViewController

- (instancetype)initWithProject:(ProjectModel *)project {
    self = [self initWithSearchType:-1];
    if (self) {
        _currentProject = project;
    }
    return self;
}

- (instancetype)initWithSearchType:(ProjectSearchType)type {
    self = [super init];
    if (self) {
        _searchType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.currentProject.name ?: LOCAL(Application_Mission);
    
    if (self.currentProject) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mission_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickToEditProject)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    [self initComponents];
    [self createToolBar];
    self.showSection = -1;
    
    [self postLoading];
    
    if (self.searchType != ProjectSearchTypeNone) {
        self.searchRequest = [[SearchMissionListRequest alloc] initWithDelegate:self];
        [self.searchRequest searchTaskListWithType:self.searchType];
    }
    else {
        [self.navBar showWithProjectId:self.currentProject.showId];
    }
    
    
    GetAllCommentRequest *commentsRequest = [[GetAllCommentRequest alloc] initWithDelegate:self];
    [commentsRequest requestData];
    
    [self resetData];
    self.dictWhiteBoard = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)initComponents
{
    [self.view addSubview:self.missionTableView];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.menuBar];
    [self initConstraints];
}

- (void)initConstraints {
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@33);
    }];

    [self.menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.width.equalTo(self.view);
    }];

    [self.missionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.menuBar.mas_top);
        make.left.right.equalTo(self.view);
    }];
    [self.view addSubview:self.emptyPageView];
    [self.emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.missionTableView);
    }];
}

#pragma mark - Data Dictionary
static NSString * const dictionaryNewKey = @"dictionaryNewKey";

- (BOOL)justShowNew {
    return !self.currentWhiteBoard;
}

- (void)resetData {
    if (self.dictData) {
        [self.dictData removeAllObjects];
        self.dictData = nil;
    }
    
    self.dictData = [NSMutableDictionary dictionary];
    [self.dictData setObject:[NSMutableArray arrayWithObjects:@YES, @1, nil] forKey:dictionaryNewKey];
}

- (void)dataAddDatas:(NSArray *)array totalCount:(NSInteger)totalCount pageIndex:(NSUInteger)pageIndex {
    if (!array.count == 0) {
        [self.emptyPageView setHidden:YES];
    }
    NSString *key = dictionaryNewKey;
    if (![self justShowNew]) {
        key = [self.currentWhiteBoard showId];
    }
    
    NSMutableArray *arrayTmp = [self.dictData objectForKey:key];
    if (!arrayTmp) {
        arrayTmp = [NSMutableArray array];
        [self.dictData setObject:arrayTmp forKey:key];
    }
    else {
        [arrayTmp removeLastObject];
        [arrayTmp removeLastObject];
    }
    
    [arrayTmp addObjectsFromArray:array];
    [arrayTmp addObject:(totalCount ? @YES : @NO)];
    [arrayTmp addObject:@(pageIndex)];
    
    self.showSection = -1;
    [self.missionTableView reloadData];
}

- (void)dataFirstAddDatas:(NSArray *)array totalCount:(NSInteger)totalCount {
    NSString *key = dictionaryNewKey;
    NSMutableArray *arrayTmp = [NSMutableArray arrayWithArray:array];
    
    [arrayTmp addObject:(totalCount ? @YES : @NO)];
    [arrayTmp addObject:@2];
    
    if (![self justShowNew]) {
        key = [self.currentWhiteBoard showId];
    }
    
    [self.dictData setObject:arrayTmp forKey:key];
    self.showSection = -1;
    [self.missionTableView reloadData];
}

- (NSMutableArray *)arrayNeedShow {
    NSString *key = dictionaryNewKey;
    if (![self justShowNew]) {
        key = [self.currentWhiteBoard showId];
    }
    
    NSMutableArray *array = [self.dictData objectForKey:key];
    if (!array) {
        array = [NSMutableArray array];
        [array addObject:@YES];
        [array addObject:@1];
        [self.dictData setObject:array forKey:key];
    }
    
    return array;
}

#pragma mark - Button Click
/** 更多选项点击 */
- (void)clickTocreate {
    TaskNewTaskViewController *vc = [[TaskNewTaskViewController alloc] initWithTitle:self.titleTxfd.text createNewTaskBlock:^(NSString *projectId) {
        
        if (![self justShowNew] && [self.currentWhiteBoard style] != whiteBoardStyleWaiting) {
            // 只显示new或者 不在new状态时 不做处理
            return;
        }
        
        [[self.missionTableView header] beginRefreshing];
        [self.view endEditing:YES];
        [self.titleTxfd resignFirstResponder];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickToEditProject {
    TaskAddNewProgressViewController *VC = [[TaskAddNewProgressViewController alloc] initWithProjectModel:self.currentProject completion:^{
        self.title = self.currentProject.name;
    }];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[SearchMissionListRequest class]] || [request isKindOfClass:[GetTaskListRequest class]]) {
        [self RecordToDiary:@"获取任务列表成功"];
        BOOL headerRefreshing = [self.missionTableView header].isRefreshing;
        BOOL footerRefreshing = [self.missionTableView footer].isRefreshing;
        
        if (headerRefreshing) {
            [[self.missionTableView header] endRefreshing];
        }
        
        if (footerRefreshing) {
            [[self.missionTableView footer] endRefreshing];
        }
        
        NSArray *array = [(id)response taskArray];
        
        if (!headerRefreshing && !footerRefreshing) {
            // 初次刷新
            [self hideLoading];
        }
        
        if (headerRefreshing) {
            [self dataFirstAddDatas:array totalCount:[array count]];
            return;
        }
        
        [self dataAddDatas:array totalCount:[array count] pageIndex:[(id)request indexPage]];
        
        [self.missionTableView.footer setHidden:([array count] == 0)];
    }
    
    else if ([request isKindOfClass:[GetTaskDetailRequest class]]) {
        [self hideLoading];
        [self RecordToDiary:@"获取任务详情成功"];
        MissionDetailModel *detailModel = [(id)response detailModel];
        
        if ([request identifier] == taskActionTypeChangeTime) {
            // 修改时间
            TaskEditRequest *editRequest = [[TaskEditRequest alloc] initWithDelegate:self];
            [editRequest editTaskModel:detailModel editDitionary:@{@(kTaskCreateAndEditRequestTypeDeadline):self.selectedDate}];
            
            return;
        }
        
        else if ([request identifier] == taskActionTypeDetail) {
        
            MissionDetailViewController *MDVC = [[MissionDetailViewController alloc] initWithMissionDetailModel:detailModel];
            
            [MDVC taskReload:^{
                [[self.missionTableView header] beginRefreshing];
            }];
            [self.navigationController pushViewController:MDVC animated:YES];
            
        } else if ([request identifier] == taskActionTypeEdit) {
            TaskNewTaskViewController *taskVC = [[TaskNewTaskViewController alloc] initWithMissionDetail:detailModel editCompletion:^{
                [[self.missionTableView header] beginRefreshing];
            }];
            
            [self.navigationController pushViewController:taskVC animated:YES];
        }
    }
    
    else if ([request isKindOfClass:[GetWhiteBoardListRequest class]]) {
        [self RecordToDiary:@"获取任务白板成功"];
        self.itemTitleArray = [NSArray arrayWithArray:[(id)response arrayWhiteBoard]];
        [self.dictWhiteBoard setObject:self.itemTitleArray forKey:[(id)response projectShowId]];
        [self.missionTableView reloadData];
    }
    
    else if ([request isKindOfClass:[TaskChangeWhiteBoardRequest class]]) {
        [self hideLoading];
        
        [[self.missionTableView header] beginRefreshing];
    }
    
    else if ([request isKindOfClass:[TaskEditRequest class]]) {
        [self hideLoading];
        
        [self RecordToDiary:@"编辑任务成功"];
        if (self.showSection == -1) {
            return;
        }
        
        NSArray *arrayShow = [self arrayNeedShow];
        MissionMainViewModel *modelRefresh = [arrayShow objectAtIndex:self.showSection];
        modelRefresh.deadlineDate = self.selectedDate;
        
        [self.missionTableView beginUpdates];
        [self.missionTableView reloadSections:[NSIndexSet indexSetWithIndex:self.showSection] withRowAnimation:UITableViewRowAnimationNone];
        self.showSection = -1;
        [self.missionTableView endUpdates];
    }
    
    else if ([request isKindOfClass:[GetAllCommentRequest class]]) {
        [self RecordToDiary:@"获取任务评论成功"];
        self.dictComments = [(id)response dictionaryComments];
        [self.missionTableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    [self RecordToDiary:[NSString stringWithFormat:@"任务主页面获取失败:%@",errorMessage]];
    if ([self.missionTableView footer].isRefreshing) {
        [[self.missionTableView footer] endRefreshing];
    }
    
    if ([self.missionTableView header].isRefreshing) {
        [[self.missionTableView header] endRefreshing];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self arrayNeedShow].count - 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 1;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissionMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MissionMainTableViewCell identifier]];
    cell.delegate = self;
    
    if (indexPath.section == self.showSection) {
        [cell showRightUtilityButtonsAnimated:NO];
    } else {
        [cell hideUtilityButtonsAnimated:NO];
    }
    
    cell.showSubDelegate = self;
    
    MissionMainViewModel *model = [[self arrayNeedShow] objectAtIndex:indexPath.section];
    
    NSInteger readStatus = -1;
    if ([self.dictComments objectForKey:model.showId]) {
        readStatus = [[self.dictComments objectForKey:model.showId] integerValue];
    }
    
    switch (readStatus) {
        case -1:
            model.commentStatus = MissionTaskCommentNone;
            break;
        case 0:
            model.commentStatus = MissionTaskCommentNew;
            break;
        case 1:
            model.commentStatus = MissionTaskCommentNormal;
            break;
    }
    
    [cell setCellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MissionMainTableViewCell height];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.showSection && self.showFooterStyle != footerViewStyleNone) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != self.showSection) {
        return nil;
    }

    NSArray *arrayShow;
    switch (self.showFooterStyle) {
        case footerViewStyleStats:
            arrayShow = [NSArray arrayWithArray:self.itemTitleArray];
            break;
        case footerViewStyleTime:
            arrayShow = @[];
            break;
        default: arrayShow = @[];
            break;
    }
    
    if (self.showFooterStyle == footerViewStyleStats) {
        NSMutableArray *arrayTmp = [self arrayNeedShow];
        MissionMainViewModel *showModel = [arrayTmp objectAtIndex:section];
        
        MissionNavBar *missionView = [[MissionNavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) style:MissionNavBarStyleWithoutAdd];
        [missionView showWithArray:arrayShow currentWhiteBoardId:showModel.statusId];
        missionView.delegate = self;

        return missionView;
    }
    
    MissionPickerBar *pickerBar = [[MissionPickerBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    pickerBar.delegate = self;
    return pickerBar;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    
    MissionDetailModel *showModel = [[self arrayNeedShow] objectAtIndex:indexPath.section];
    
    [self postLoading];
    GetTaskDetailRequest *taskDetailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self identifier:taskActionTypeDetail];
    [taskDetailRequest getDetailTaskWithId:showModel.showId];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.showSection = -1;
    self.showFooterStyle = footerViewStyleNone;
    [self.missionTableView reloadData];
    [self.view endEditing:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *path = [self.missionTableView indexPathForCell:cell];
    NSMutableArray *listArray = [self arrayNeedShow];
    MissionMainViewModel *selectedModel = [listArray objectAtIndex:path.section];
    
    switch (index) {
        case 0: // 今天 明天 后天 。。。
            self.showSection = path.section;
            self.showFooterStyle = footerViewStyleTime;
            break;
        case 1:
            self.showSection = -1;
            self.showFooterStyle = footerViewStyleNone;
            break;
        case 2: // new doing done commit
            self.showSection = path.section;
            self.showFooterStyle = footerViewStyleStats;
            break;
    }

    switch (self.showFooterStyle) {
        case footerViewStyleTime:
        {
            [self.missionTableView reloadData];
        }
            break;
        case footerViewStyleStats:
        {   // 获取白板
            
            self.itemTitleArray = [self.dictWhiteBoard objectForKey:selectedModel.projectId];
            if (!self.itemTitleArray) {
                // 没有白板了，获取
                GetWhiteBoardListRequest *whiteBoardListRequest = [[GetWhiteBoardListRequest alloc] initWithDelegate:self];
                [whiteBoardListRequest getProjectWhiteBoard:selectedModel.projectId];
            }
            
            [self.missionTableView reloadData];
        }
            break;
        default:
            break;
    }

    if (self.showSection != -1) {
        [self.missionTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    if (self.showSection == -1) {
        [self postLoading];
        GetTaskDetailRequest *detailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self identifier:taskActionTypeEdit];
        [detailRequest getDetailTaskWithId:selectedModel.showId];
    }
}

- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell {
    NSIndexPath *indexPath = [self.missionTableView indexPathForCell:cell];
    
    if ([cell isUtilityButtonsHidden]) {
        if (indexPath && indexPath.section == self.showSection) {
            self.showSection = -1;
            self.showFooterStyle = footerViewStyleNone;
            [self.missionTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    else {
        if (!indexPath) {
            return;
        }
    
        self.showSection = indexPath.section;
        self.showFooterStyle = footerViewStyleNone;
        [self.missionTableView reloadData];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES;}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
//    if (![textField.text length]) {
//        return YES;
//    }
    
#warning 暂时不能快速生成任务，跳转追加吧－－－－－－－－－
    [self clickTocreate];
    return YES;
}

#pragma mark - MissonNavBar Delegate
- (void)missionNavBar:(MissionNavBar *)navBar refreshWithSelectedWhiteBoard:(TaskWhiteBoardModel *)whiteBoard {
    if (navBar.style == MissionNavBarStyleDefault) {
        self.currentWhiteBoard = whiteBoard;
        
        // 已经请求过就不请求了
        NSMutableArray *arrayShow = [self arrayNeedShow]; // 不移出去，跟whiteboard有关联
        BOOL remain = [[arrayShow objectAtIndex:arrayShow.count - 2] boolValue];
        if (arrayShow.count > 2 || !remain) {
            [self.missionTableView reloadData];
            [self showFooterView];
            return;
        }
        
        [self postLoading];
        [self.taskRequest getTaskListWithWhiteBoardId:whiteBoard.showId pageIndex:1];
    }
    else {
        // footerView点击事件
        if (self.showSection == -1) {
            return;
        }
        [self postLoading];
        
        NSMutableArray *arrayShow = [self arrayNeedShow];
        MissionMainViewModel *selectedModel = [arrayShow objectAtIndex:self.showSection];
        TaskChangeWhiteBoardRequest *changeRequest = [[TaskChangeWhiteBoardRequest alloc] initWithDelegate:self];
        [changeRequest changeTaskId:selectedModel.showId whiteboardId:whiteBoard.showId];
    }
}

- (void)missionNavBarShowEditVC:(MissionNavBar *)navBar {
    if (!self.currentProject) {
        return;
    }
    _whiteBoardVC = [[TaskWhiteBoardViewController alloc] initWithProjectId:self.currentProject.showId finished:^(NSArray *savedArray) {
        self.itemTitleArray = [NSArray arrayWithArray:savedArray];
        // 修改完白板后更新字典里
        [self.dictWhiteBoard setObject:self.itemTitleArray forKey:self.currentProject.showId];
        [self.navBar updateWhiteboard:savedArray];
    }];
    
    [self.navigationController pushViewController:_whiteBoardVC animated:YES];
}

- (void)missionNavBarShowFailed:(NSString *)errorMsg {
    [self postError:errorMsg];
}

#pragma mark - MissonMenuView Delegate
- (void)missionMenuViewDelegateCallBack_showKeyBoardWithIndex:(NSInteger)index {
    if (index == kmenuBtn) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (index == kaddBtn) {
        [self.titleTxfd becomeFirstResponder];
        [MixpanelMananger track:@"task/new"];
    }
}

#pragma mark - 给选择时间用的method
- (void)didSelectTime {
    [self postLoading];
    
    NSArray *array = [self arrayNeedShow];
    MissionMainViewModel *changedModel = [array objectAtIndex:self.showSection];
    
    GetTaskDetailRequest *detailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self identifier:taskActionTypeChangeTime];
    [detailRequest getDetailTaskWithId:changedModel.showId];
}

#pragma mark - MissionPickerBar Delegate
- (void)MissionPickerBarDelegateCallBack_setEventStateNameWithIndex:(NSInteger)index {
    [self.view endEditing:YES];
    if (self.showSection == -1) {
        return;
    }
    
    NSArray *dateSelected = @[@0, @1, @2, @7];
    if (index < [dateSelected count]) {
        NSInteger days = [[dateSelected objectAtIndex:index] integerValue];
        self.selectedDate = [[NSDate date] dateByAddingDays:days];
    }
    
    else {
        self.selectedDate = [[NSDate date] dateByAddingMonths:1];
    }
    [self didSelectTime];
}

- (void)MissionPickerBarDelegateCallBack_optionsSelected {
    [self.view endEditing:YES];
    ApplyAddDeadlineActionSheetView *view = [[ApplyAddDeadlineActionSheetView alloc] init];
    [view setShowWholeDayMode:YES];
    view.delegate = self;
    [self.view addSubview:view];
}

#pragma mark - ApplyAddDeadLineActionSheetView Delegate
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date {
    if (self.showSection == -1) {
        return;
    }
    
    self.selectedDate = date;
    [self didSelectTime];
}

#pragma mark - MissionMainTableViewCell Delegate
- (void)missionMainTableViewCellDelegateCallBack_showSubcell:(MissionMainTableViewCell *)cell {
    NSIndexPath *indexPath = [self.missionTableView indexPathForCell:cell];
    // 要展开收拢的Model
    MissionMainViewModel *folderModel = [[self arrayNeedShow] objectAtIndex:indexPath.section];
    
    NSIndexSet *indexSetNeedReload = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.section + 1, folderModel.subMissionArray.count)];
    if (self.showSection != -1 && [indexSetNeedReload containsIndex:self.showSection]) {
        self.showSection = -1;
        self.showFooterStyle = footerViewStyleNone;
    }
    
    [self.missionTableView beginUpdates];
    if (folderModel.isFolder) {
        // 关闭
        [[self arrayNeedShow] removeObjectsAtIndexes:indexSetNeedReload];
        [self.missionTableView deleteSections:indexSetNeedReload withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        // 展开
        [[self arrayNeedShow] insertObjects:folderModel.subMissionArray atIndexes:indexSetNeedReload];
        [self.missionTableView insertSections:indexSetNeedReload withRowAnimation:UITableViewRowAnimationFade];
    }
    
    folderModel.folder = !folderModel.folder;
    
    if (self.showSection != -1 && self.showFooterStyle != footerViewStyleNone) {
        self.showFooterStyle = footerViewStyleNone;
        
        if (![indexSetNeedReload containsIndex:self.showSection]) {
            [self.missionTableView reloadSections:[NSIndexSet indexSetWithIndex:self.showSection] withRowAnimation:UITableViewRowAnimationFade];
        }
        self.showSection = -1;
    }
    
    [self.missionTableView endUpdates];
}

#pragma mark - Private Method
- (void)keyBoardFrameChanged:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double timeInterval = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(endKeyboardRect)) {
        CGFloat temp = endKeyboardRect.size.height + CGRectGetHeight(self.contentView.frame);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-temp);
        }];
    }
    else {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
    }
    
    [UIView animateWithDuration:timeInterval animations:^{
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
    }];
}

//创建键盘上的工具栏
- (void)createToolBar {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.equalTo(@45);
    }];
    
    self.titleTxfd = [[UITextField alloc] init];
    self.titleTxfd.delegate = self;
    self.titleTxfd.placeholder = LOCAL(MISSION_PLS_INPUT_TAST_TITLE);
    self.titleTxfd.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.titleTxfd];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setTitle:LOCAL(MISSION_MORE_CHOOSE) forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    
    [moreBtn addTarget:self action:@selector(clickTocreate) forControlEvents:UIControlEventTouchUpInside];
    
    [moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.contentView addSubview:moreBtn];
    
    [self.titleTxfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(moreBtn.mas_left).offset(-10);
    }];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)refreshData {
    if ([self justShowNew]) {
        [self.searchRequest searchTaskListRefresh];
    }
    else {
        [self.taskRequest getTaskListWithWhiteBoardId:[self.currentWhiteBoard showId] pageIndex:1];
    }
}

- (void)getMoreData {
    if ([self justShowNew]) {
        [self.searchRequest searchMoreTaskList];
    }
    else {
        NSMutableArray *array = [self arrayNeedShow];
        [self.taskRequest getTaskListWithWhiteBoardId:[self.currentWhiteBoard showId] pageIndex:[[array lastObject] unsignedIntegerValue]];
    }
}

- (void)showFooterView {
    NSMutableArray *array = [self arrayNeedShow];
    BOOL showFooter = ![[array objectAtIndex:array.count - 2] boolValue];
    [self.missionTableView footer].hidden = showFooter;
}

#pragma mark - getter and setter
- (MissionMenuView *)menuBar {
    if (!_menuBar) {
        _menuBar = [[MissionMenuView alloc] init];
        _menuBar.delegate = self;
    }
    return _menuBar;
}

- (MissionNavBar *)navBar {
    if (!_navBar) {
        _navBar = [[MissionNavBar alloc] init];
        _navBar.delegate = self;
    }
    return _navBar;
}

- (UITableView *)missionTableView
{
    if (!_missionTableView)
    {
        _missionTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _missionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _missionTableView.delegate = self;
        _missionTableView.dataSource = self;
        
        [_missionTableView registerClass:[MissionMainTableViewCell class] forCellReuseIdentifier:[MissionMainTableViewCell identifier]];
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _missionTableView.header = header;
        
        _missionTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    }
    return _missionTableView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return  _contentView;
}

- (GetTaskListRequest *)taskRequest {
    if (!_taskRequest) {
        _taskRequest = [[GetTaskListRequest alloc] initWithDelegate:self];
    }
    return _taskRequest;
}
- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nounfinishjob"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:LOCAL(MISSION_EMPTY_ICON)];
        [titel setTextColor:[UIColor themeBlue]];
        [_emptyPageView addSubview:imageView];
        [_emptyPageView addSubview:titel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView).offset(15);
            make.bottom.equalTo(_emptyPageView.mas_centerY);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(20);
        }];
    }
    return _emptyPageView;
}

@end
