//
//  AddFriendSearchResultsController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddFriendSearchResultsController.h"
#import "NewAddFriendsAdpter.h"
#import "DoctorCompletionInfoModel.h"
#import "DoctorSearchTask.h"
#import "DepartmentAdapter.h"
#import "DoctorSearchResultsModel.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ContactDoctorInfoTableViewCell.h"

@interface AddFriendSearchResultsController ()<ATTableViewAdapterDelegate,TaskObserver>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  DepartmentAdapter  *adapter; // <##>
@property (nonatomic, strong)  DoctorSearchResultsModel  *resultModel; // <##>
@property (nonatomic, copy)  SearchResultClicked  resultClicked; // <##>
@end

@implementation AddFriendSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.title = @"搜索好友";
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked {
    if (keywords.length == 0) {
        return;
    }
    self.resultClicked = clicked;
    NSDictionary *dictParam = @{
                                @"keyWord" : keywords
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([DoctorSearchTask class]) taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    self.resultClicked(cellData);
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([DoctorSearchTask class])])
    {
        if ([taskResult isKindOfClass:[DoctorSearchResultsModel class]]) {
            [self at_hideLoading];
            self.resultModel = taskResult;
            self.adapter.adapterArray = [self.resultModel.list mutableCopy];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Override

#pragma mark - Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[ContactDoctorInfoTableViewCell class] forCellReuseIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    }
    return _tableView;
}

- (DepartmentAdapter *)adapter {
    if (!_adapter) {
        _adapter = [DepartmentAdapter new];
        _adapter.adapterDelegate = self;
    }
    return _adapter;
}
@end
