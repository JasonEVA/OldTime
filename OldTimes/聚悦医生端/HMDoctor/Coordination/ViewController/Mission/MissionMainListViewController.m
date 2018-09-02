//
//  MissionMainListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMainListViewController.h"
#import "MissionMainListAdapter.h"
#import <Masonry/Masonry.h>
#import "MissionMainListInputView.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import <SWTableViewCell/SWTableViewCell.h>

#import "GetTaskTypeCountsTask.h"
#import "GetTaskTypePageListTask.h"
#import "TaskTypeTitleAndCountModel.h"
#import "MissionListModel.h"
#import "MissionDetailModel.h"
#import "CoordinationModalViewController.h"
#import "UpdateTaskStatusTask.h"
@interface MissionMainListViewController()<ATTableViewAdapterDelegate,TaskObserver,MissionMainListAdapterDelegate,CoordinationModalViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MissionMainListAdapter *adapter;
@property (nonatomic, strong) MissionMainListInputView *selectMissionTypeView;  //任务类型选择弹出View
@property (nonatomic, strong) MASConstraint *selectViewHeight;
@property (nonatomic, strong) UIButton *titelBtn;
@property (nonatomic, strong) UIImageView *titelImg;
@property (nonatomic) BOOL isSelectViewShow;    //记录任务类型View是否弹出
@property (nonatomic, strong) UIImageView *imageView;   //翻转箭头
@property (nonatomic, strong)  TaskTypeTitleAndCountModel  *selectedTitleCountModel; // <##>
@property(nonatomic, strong) UIView  *emptyPageView;   //空白页

@property(nonatomic, strong) MissionDetailModel *currentModel;
@property(nonatomic, assign) NSIndexPath  *currentIndexPath;
@end

@implementation MissionMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:self.titelBtn];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self.navigationItem setRightBarButtonItem:addBar];
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI);  //设计师给的切图是翻过来的
    self.isSelectViewShow = NO;
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestTypeTaskListWithTypeData:self.selectedTitleCountModel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -private method

#pragma mark - private method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.emptyPageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectMissionTypeView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.selectMissionTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        self.selectViewHeight = make.height.mas_equalTo(0);
    }];

}

// 设置数据
- (void)configData {
    // 获取分类
    [self requestTaskTitleAndCount];
}

- (void)selectTitelActionWithMissionTypeData:(TaskTypeTitleAndCountModel *)selectModel
{
    [self.titelBtn setTitle:selectModel.tabName forState:UIControlStateNormal];
}

// 请求任务类型标题和count
- (void)requestTaskTitleAndCount {
    
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"userId" : [NSString stringWithFormat:@"%ld",(long)info.userId]
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetTaskTypeCountsTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

// 请求某类型任务列表
- (void)requestTypeTaskListWithTypeData:(TaskTypeTitleAndCountModel *)model {
    if (!model) {
        return;
    }
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                           @"tabInd" : [NSString stringWithFormat:@"%ld",model.tabInd]
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetTaskTypePageListTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

// 配置任务类型数
- (void)configTaskTitleAndCountWithData:(NSArray *)array {
    __weak typeof(self) weakSelf = self;
    [self.selectMissionTypeView reloadInputViewWithData:array selectIndexBlock:^(TaskTypeTitleAndCountModel *selectModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.selectedTitleCountModel = selectModel;
        [strongSelf selectTitelActionWithMissionTypeData:selectModel];
        [strongSelf requestTypeTaskListWithTypeData:selectModel];
    }];
    
    [self.selectMissionTypeView closeInputViewNoti:^{
        [weakSelf taskTypeSelectViewEvent];
    }];
}

// 配置任务列表
- (void)configTaskListDataWithListData:(MissionListModel *)model {
    [self.adapter.adapterArray removeAllObjects];
    if (model.history) {
        [self.adapter.adapterArray addObject:model.history];
    }
    [self.adapter.adapterArray addObject:model.records];
    if (self.adapter.arrayButtons.count > 0) {
        [self.adapter.arrayButtons[0] selectButton].selected = NO;
    }
    // 配置列表头
    [self configTaskListSectionDataWithListData:model];
    [self.tableView reloadData];
    
    self.tableView.hidden = ![self judgementWithArray:self.adapter.adapterArray];
    self.emptyPageView.hidden = !self.tableView.hidden;
}



- (BOOL)judgementWithArray:(NSArray *)array {
    
    //对应二维的情况
    if (array.count == 2){
        for (NSArray *object in array){
            if (object.count > 0) {
                return YES;
            }
            else {
                continue;
            }
            return NO;
        }
    }
    //对应一维的情况
    NSArray *arr = array.firstObject;
    return arr.count;
}


// 配置列表头
- (void)configTaskListSectionDataWithListData:(MissionListModel *)model {
    MissionType type = (MissionType)self.selectedTitleCountModel.tabInd;
    self.adapter.selectType = type;
    
    NSMutableArray *arrayTemp = [NSMutableArray array];
    if (model.history) {
        [arrayTemp addObject:@"已过期"];
    }

    switch (type) {
        case MissionType_Today:
            [arrayTemp addObject:@"待执行"];

            break;
            
        case MissionType_Tomorrow:
            [arrayTemp addObject:@"待执行"];

            break;
            
        case MissionType_All:
            [arrayTemp addObject:@"待执行"];

            break;
            
        case MissionType_Refuse:
            [arrayTemp addObject:@"我拒绝的"];

            break;
            
        case MissionType_SendFromMe:
            [arrayTemp addObject:@"我发出的"];

            break;
            
        case MissionType_Down:
            [arrayTemp addObject:@"已完成"];

            break;
    }
    self.adapter.headViewTitelArr = arrayTemp;
}

#pragma mark - event Response

- (void)addClick
{
    [[ATModuleInteractor sharedInstance] goToAddNewMissionVC];
}

- (void)taskTypeSelectViewEvent
{
    CGFloat angle;
    if (self.isSelectViewShow) {
        self.selectViewHeight.offset = 0;
        angle = M_PI;
    } else {
        self.selectViewHeight.offset = self.view.frame.size.height;
        angle = 0;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view layoutIfNeeded];
        strongSelf.imageView.transform = CGAffineTransformMakeRotation(angle);
    }];
    self.isSelectViewShow ^= 1;
}

//点击完成或者取消完成事件
- (void)sendAcceptOrRejectRequestWihtAccept:(BOOL)isAccept Reason:(NSString *)reason Model:(MissionDetailModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:model.showID forKey:@"showId"];
    [dict setValue:@(3)forKey:@"status"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([UpdateTaskStatusTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)showAlterViewWithIsFinished:(BOOL)isfinished model:(MissionDetailModel *)model
{
    CoordinationModalViewController *VC = [[CoordinationModalViewController alloc]initWithTitle:@"完成确认" message:@"确定？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [self presentViewController:VC animated:YES completion:nil];
    
}
#pragma mark - CoordinationModalViewControllerDelegate

- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex Tag:(NSInteger)tag
{
    if (buttonIndex){
        [self sendAcceptOrRejectRequestWihtAccept:YES Reason:nil Model:self.currentModel];
    }
}

#pragma mark - UITableViewDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    [[ATModuleInteractor sharedInstance] goToMissionDetailVCWithModel:(MissionDetailModel *)cellData];
}

- (void)missionMainListAdapterDelegateCallBack_newDraftWithCellData:(id)CellData {
    // 新建草稿
    if ([CellData isKindOfClass:[MissionDetailModel class]]) {
        [[ATModuleInteractor sharedInstance] goToNewDraftMissionVCWithData:CellData];
    }
}
#pragma mark - request Delegate

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }

    [self at_hideLoading];
    [self.view closeWaitView];
    [self showAlertMessage:errorMessage];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:NSStringFromClass([GetTaskTypeCountsTask class])]) {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            [self configTaskTitleAndCountWithData:taskResult];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([GetTaskTypePageListTask class])]) {
        if ([taskResult isKindOfClass:[MissionListModel class]]) {
            // 配置列表
            [self configTaskListDataWithListData:taskResult];
        }
    }else if ([taskname isEqualToString:NSStringFromClass([UpdateTaskStatusTask class])])
    {
        if (self.adapter.adapterArray.count ==2 ) {
            for (int i = 0; i< self.adapter.adapterArray.count; i++){
                NSMutableArray *tempArr = [self.adapter.adapterArray[i] mutableCopy];
                [tempArr removeObject:self.currentModel];
                self.adapter.adapterArray[i] = tempArr;
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (MissionMainListAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [MissionMainListAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        _adapter.customDelegate = self;
        __weak typeof(self) weakSelf = self;
        [_adapter showAlterViewWithBlock:^(BOOL isFinished, UITableViewCell *cell) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSIndexPath *indexpath = [strongSelf.tableView indexPathForCell:cell];
            NSArray*tempArray = strongSelf.adapter.adapterArray[indexpath.section];
            
            MissionDetailModel *model = tempArray[indexpath.row];
            strongSelf.currentModel = model;
            if (!isFinished) {
                [strongSelf sendAcceptOrRejectRequestWihtAccept:isFinished Reason:nil Model:model];
            }else{
                [strongSelf showAlterViewWithIsFinished:isFinished model:model];
            }
        }];
    }
    return _adapter;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

 - (MissionMainListInputView *)selectMissionTypeView
{
    if (!_selectMissionTypeView) {
        _selectMissionTypeView = [MissionMainListInputView new];
        [_selectMissionTypeView setClipsToBounds:YES];
    }
    return _selectMissionTypeView;
}

- (UIButton *)titelBtn
{
    if (!_titelBtn) {
        _titelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        [_titelBtn setTitle:@"今天" forState:UIControlStateNormal];
        [_titelBtn addTarget:self action:@selector(taskTypeSelectViewEvent) forControlEvents:UIControlEventTouchUpInside];
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downArror"]];
        [_titelBtn addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titelBtn.titleLabel);
            make.left.equalTo(_titelBtn.titleLabel.mas_right).offset(3);
        }];
    }
    return _titelBtn;
}

- (UIImageView *)titelImg
{
    if (!_titelImg) {
        _titelImg = [UIImageView new];
    }
    return _titelImg;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nounfinishjob"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:@"赞！没有未完成的任务"];
        [titel setTextColor:[UIColor commonBlueColor]];
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
