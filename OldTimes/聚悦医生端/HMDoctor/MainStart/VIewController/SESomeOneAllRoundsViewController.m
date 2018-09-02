//
//  SESomeOneAllRoundsViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESomeOneAllRoundsViewController.h"
#import "SESearchTableViewCell.h"
#import "RoundsMessionModel.h"
#import "UIBarButtonItem+BackExtension.h"
#import "RoundsDetailViewController.h"

#define PAGESIZE           20

@interface SESomeOneAllRoundsViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic) NSInteger pageNum;

@end

@implementation SESomeOneAllRoundsViewController

- (instancetype)initWithUserName:(NSString *)userName userId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.title = userName;
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp:)];

    self.pageNum = 1;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self startGetSomeAllRoundsRequest];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainThemeColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startGetSomeAllRoundsRequest {
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@(self.pageNum) forKey:@"pageNum"];
    [dicPost setValue:@(PAGESIZE) forKey:@"pageSize"];
    [dicPost setValue:self.userId forKey:@"userId"];

    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SEGetSomeALLRoundsRequest" taskParam:dicPost TaskObserver:self];
    

}
#pragma mark - event Response
- (void)rightClick {
    
}

- (void)backUp:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无内容" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"i"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SESearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SESearchTableViewCell at_identifier]];
    [cell fillDataWithModel:self.dataList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoundsMessionModel* mession = self.dataList[indexPath.row];
    
    if ([mession.status isEqualToString:@"N"]) {
        // 待反馈
        [self at_postError:@"用户未反馈"];
    }
    else if ([mession.status isEqualToString:@"0"]) {
        // 未填写
        //待查房，不能查看
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0 OperateCode:kPrivilegeEditOperate];
        if (editPrivilege)
        {
            //跳转到填写查房表界面
            RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:NO];
            __weak typeof(self) weakSelf = self;
            [VC fillFinish:^{
                weakSelf.pageNum = 1;
                [weakSelf.dataList removeAllObjects];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf startGetSomeAllRoundsRequest];
            }];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    else if ([mession.status isEqualToString:@"1"]) {
        // 已填写
        //已填写,跳转到查房详情页面
        RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:YES];
        [self.navigationController pushViewController:VC animated:YES];
        
    }

}

#pragma mark - request Delegate
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
    if (taskError != StepError_None) {
        [self at_hideLoading];
        
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
    [self at_hideLoading];
    
    if ([taskname isEqualToString:@"SEGetSomeALLRoundsRequest"])
    {
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
//        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        
        
        if (!list || ![list isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if (list.count) {
            if (self.pageNum < 2) {
                // 第一页
                [self.dataList removeAllObjects];
            }
            
            [self.dataList addObjectsFromArray:list];
            [self.tableView reloadData];
            
            if (self.pageNum >= 2 ) {
                // 分页加载滚到原地
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataList.count - list.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            else {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            
            if (self.pageNum >= 2) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            self.pageNum ++;
            
            
        }
        else {
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:65];
        [_tableView registerClass:[SESearchTableViewCell class] forCellReuseIdentifier:[SESearchTableViewCell at_identifier]];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startGetSomeAllRoundsRequest)];

    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end


