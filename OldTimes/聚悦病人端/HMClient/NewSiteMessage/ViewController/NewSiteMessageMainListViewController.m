//
//  NewSiteMessageMainListViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMainListViewController.h"
#import "NewSiteMessageMainListAdapater.h"
#import "NewSiteMessageMainListTableViewCell.h"
#import "ATModuleInteractor+NewSiteMessage.h"
#import "NewSiteMessageGetMainListRequest.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface NewSiteMessageMainListViewController ()<ATTableViewAdapterDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NewSiteMessageMainListAdapater *adapter;

@end

@implementation NewSiteMessageMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"站内信";
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //将推送消息session标记已读，去除外面红点
    [[MessageManager share] sendReadedRequestWithUid:@"PUSH@SYS" messages:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startMainListRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startMainListRequest {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetMainListRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
    
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - NewSiteMessageMainListAdapaterDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    [[ATModuleInteractor sharedInstance] gotoTypeVCWithType:cellData];
}
#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];

    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"NewSiteMessageGetMainListRequest"]) {
        NSArray *temp = (NSArray *)taskResult;
        self.adapter.adapterArray = temp.mutableCopy;
        [self.tableView reloadData];
    }
    
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView registerClass:[NewSiteMessageMainListTableViewCell class] forCellReuseIdentifier:[NewSiteMessageMainListTableViewCell at_identifier]];

        _tableView.rowHeight = 75;
    }
    return _tableView;
}

- (NewSiteMessageMainListAdapater *)adapter
{
    if (!_adapter) {
        _adapter = [NewSiteMessageMainListAdapater new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        }
    return _adapter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
