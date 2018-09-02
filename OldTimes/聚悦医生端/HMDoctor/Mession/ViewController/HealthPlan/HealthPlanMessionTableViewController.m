//
//  HealthPlanMessionTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanMessionTableViewController.h"

#import "HealthPlanMessionTableViewCell.h"
#import "ClientHelper.h"
#import "UIBarButtonItem+BackExtension.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HealthPlanSummaryViewController.h"

@interface HealthPlanMessionStartWebViewViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@interface HealthPlanMessionTableViewController ()
<TaskObserver>
{
    NSMutableArray* messions;
    NSInteger totalCount;
}



@property (nonatomic, retain) NSArray* status;
@end

@implementation HealthPlanMessionStartWebViewViewController

- (void)dealloc {
    NSLog(@"webview销毁了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp:)];
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    //NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    NSString *str = [NSString stringWithFormat:@"%@/jkjh_hzlb.htm?vType=YS&staffId=%ld&staffRole=%@",kZJKHealthDataBaseUrl, curStaff.staffId, staffRole];
    
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    //[webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
}

- (void)backUp:(UIBarButtonItem *)btn
{
    //[self popViewControllerAnimated:YES];
    if ([webview canGoBack])
    {
        [webview goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [webview closeWaitView];
    if ([error code] == NSURLErrorCancelled)
    {
        return;
    }
    [self showAlertMessage:[NSString stringWithFormat:@"%@",error]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [webview showWaitView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webview closeWaitView];
}

@end






#define kHealthPlanMessionPageSize          20

@interface HealthPlanMessionTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end
@implementation HealthPlanMessionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setEmptyDataSetSource:self];
    [self.tableView setEmptyDataSetDelegate:self];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHealthPlans)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    
    //搜索进来的界面
    /*
    if (_isSearch)
    {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHealthPlans)];
        MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
        refHeader.lastUpdatedTimeLabel.hidden = YES;
        [self.tableView.mj_header beginRefreshing];
    }
    */
}

- (id) initWithStatusList:(NSArray*) statusList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _status = statusList;
        _isSearch = NO;
    }
    return self;
}

//搜索进来的界面
- (id)initWithKeyword:(NSString *)keyword
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _keyword = keyword;
        _isSearch = YES;
    }
    return self;
}

- (void) setKeyword:(NSString *)keyword
{
    _keyword = keyword;
    if (messions) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [messions removeAllObjects];
        [self.tableView reloadData];
    }
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadHealthPlans];
}

- (void) loadHealthPlans
{
    if (self.status && 0 == self.status.count)
    {
        //没有任何处理健康计划权限
        
        //[self showBlankView];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kHealthPlanMessionPageSize;
    if (messions && 0 < messions.count) {
        rows = messions.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_status)
    {
        [dicPost setValue:_status forKey:@"status"];
    }
    if (_keyword)
    {
        [dicPost setValue:_keyword forKey:@"searchUserName"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreHealthPlans
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    NSInteger startRow = 0;
    if (messions)
    {
        startRow = messions.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    
    NSInteger rows = kHealthPlanMessionPageSize;
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_status)
    {
        [dicPost setValue:_status forKey:@"status"];
    }
    if (_keyword)
    {
        [dicPost setValue:_keyword forKey:@"searchUserName"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) healthPlanMessionsListLoaded:(NSArray*) items
{
    
    
    messions = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
    if (messions.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthPlans)];
    }
}

- (void) moreHealthPlanMessionLoaded:(NSArray*) items
{
    if (!messions)
    {
        messions = [NSMutableArray array];
    }
    [messions addObjectsFromArray:items];
    [self.tableView reloadData];
    
    if (messions.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthPlans)];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (messions)
    {
        return messions.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthPlanMessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanMessionTableViewCell"];
    if (!cell)
    {
        cell = [[HealthPlanMessionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanMessionTableViewCell"];
    }
    
    // Configure the cell...
    HealthPlanMessionInfo* healthPlan = messions[indexPath.row];
    [cell setHealthPlan:healthPlan];
    [cell.operateButton setTag:0x100 + indexPath.row];
    [cell.operateButton addTarget:self action:@selector(operateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.archiveButton setTag:0x101 + indexPath.row];
    [cell.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanMessionInfo* healthPlan = messions[indexPath.row];
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:healthPlan.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看监控计划权限
        return;
    }
    //跳转健康计划详情界面 
    //2017-10-31 版本需求修改界面跳转 by YinQ
    HealthPlanSummaryViewController* healthPlanViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:healthPlan.userId];
    if (healthPlan.healthyId)
    {
        [healthPlanViewController setHealthyPlanId:[NSString stringWithFormat:@"%ld", healthPlan.healthyId]];
    }
    [self.navigationController pushViewController:healthPlanViewController animated:YES];

}

//跳转档案详情
- (void) archiveButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    UIButton* btn = (UIButton*) sender;
    NSInteger tagIndex = btn.tag - 0x101;
    HealthPlanMessionInfo* healthPlan = messions[tagIndex];

    //2017-10-31版本 界面修改调整 by Jason
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)healthPlan.userId]];
}

- (void) operateButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    UIButton* btn = (UIButton*) sender;
    NSInteger tagIndex = btn.tag - 0x100;
    HealthPlanMessionInfo* healthPlan = messions[tagIndex];

    switch (healthPlan.status)
    {
        case 1:
        {
            //制定健康计划
            
            BOOL makePrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:healthPlan.status OperateCode:kPrivilegeEditOperate];
            if (!makePrivilege) {
                //没有制定计划的权限
                break;
            }
             //2017-10-31 版本需求修改界面跳转 by Jason
            NSInteger userIdInt = healthPlan.userId;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];
            [detectViewController setFormulatePlan:YES];
            [self.navigationController pushViewController:detectViewController animated:YES];
            
            break;
        }
        case 2:
        {
            StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            if (healthPlan.approveStaffId != staff.staffId)
            {
                //不是指定给我的
                return;
            }
            //待确定
            BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:healthPlan.status OperateCode:kPrivilegeConfirmOperate];
            if (!viewPrivilege)
            {
                //没有查看健康计划权限
                return;
            }
            NSInteger userIdInt = healthPlan.userId;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];
            
            [self.navigationController pushViewController:detectViewController animated:YES];
        }
            break;
            
        default:
        {
            BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:healthPlan.status OperateCode:kPrivilegeEditOperate];
            if (!editPrivilege)
            {
                //没有查看监控计划权限
                return;
            }
            
            NSInteger userIdInt = healthPlan.userId;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];

            [self.navigationController pushViewController:detectViewController animated:YES];
        }
            break;
    }
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (self.tableView.mj_header && [self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
    if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
        if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
        {
            [self.tableView.superview closeWaitView];
        }
        else
        {
            if (totalCount <= messions.count)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.tableView.mj_footer endRefreshing];
            }
        }
    }
    
//    if (0 == totalCount)
//    {
//        [self showBlankView];
//    }
//    else
//    {
//        [self closeBlankView];
//    }

}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"HealthPlanListTask"])
    {
        NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskname];
        if (!dicPost || ![dicPost isKindOfClass:[NSDictionary class]])
        {
            NSArray* statusItems = [dicPost valueForKey:@"status"];
            if (![self statusListIsCurrentStatus:statusItems])
            {
                return;
            }

        }
        
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *items = [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载
                [self moreHealthPlanMessionLoaded:items];
                return;
            }
            else
            {
                [self healthPlanMessionsListLoaded:items];
            }
            
            
        }
    }
    
}

- (BOOL) statusListIsCurrentStatus:(NSArray*) statusItems
{
    BOOL isCurrent = NO;
    if (!statusItems || 0 == self.status) {
        return YES;
    }
    
    if (statusItems && self.status)
    {
        if (statusItems.count != self.status.count)
        {
            return isCurrent;
        }
        
        for (id obj in statusItems)
        {
            if (![obj isKindOfClass:[NSString class]]) {
                return isCurrent;
            }
            NSString* numStatus = (NSString*) obj;
            BOOL isExistedStatus = NO;
            for (NSString* numCurStatus in self.status)
            {
                if (numStatus.integerValue == numCurStatus.integerValue)
                {
                    isExistedStatus = YES;
                    break;
                }
            }
            if (!isExistedStatus) {
                return isCurrent;
            }
        }
        
        isCurrent = YES;
    }
    
    return isCurrent;
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_isSearch) {
        return nil;
    }
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!messions || messions.count == 0) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_isSearch)
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        return [[NSAttributedString alloc] initWithString:@"未找到任何健康计划" attributes:attributes];
    }
    return nil;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
}

@end
