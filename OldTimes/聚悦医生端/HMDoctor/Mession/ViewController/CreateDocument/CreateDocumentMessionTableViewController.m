//
//  CreateDocumentMessionTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentMessionTableViewController.h"
#import "CreateDocumentMessionTableViewCell.h"

static const NSInteger kCreateDocutmentPageSize = 15;

@interface CreateDocumentMessionTableViewController ()
<TaskObserver>
{
    NSMutableArray* messionsList;
    NSInteger totalCount;
}
@property (nonatomic, readonly) NSArray* statusList;
@end

@implementation CreateDocumentMessionTableViewController

- (id) initWithStatus:(NSArray*) statusList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _statusList = statusList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //TODO:
    if (_statusList )
    {
        if (0 == _statusList.count)
        {
            //没有处理状态
            if (messionsList)
            {
                [messionsList removeAllObjects];
            }
            
            [self showBlankView];
            [self createDocumentMessionsLoaded:nil];
            return;
        }
    }
    
    [self loadMessionList];
    
}



- (void) loadMessionList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
   
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    if (staffRole)
    {
        [dicPost setValue:staffRole forKey:@"staffRole"];
    }
    
    NSInteger startRow = 0;
    NSInteger rows = kCreateDocutmentPageSize;
    if (messionsList && kCreateDocutmentPageSize < messionsList.count)
    {
        rows = messionsList.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_statusList )
    {
        if (0 == _statusList.count)
        {
            //没有处理状态
            if (messionsList)
            {
                [messionsList removeAllObjects];
            }
            
            [self showBlankView];
            [self createDocumentMessionsLoaded:nil];
            return;
        }
        [dicPost setValue:_statusList forKey:@"status"];
    }
    [self.tableView showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentMessionListTask" taskParam:dicPost TaskObserver:self];
}


- (void) loadMoreMessionList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    if (staffRole)
    {
        [dicPost setValue:staffRole forKey:@"staffRole"];
    }
    
    NSInteger startRow = 0;
    NSInteger rows = kCreateDocutmentPageSize;
    if (messionsList && kCreateDocutmentPageSize < messionsList.count)
    {
        startRow = messionsList.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_statusList )
    {
        if (0 == _statusList.count)
        {
            //没有处理状态
            if (messionsList)
            {
                [messionsList removeAllObjects];
            }
            
            [self showBlankView];
            [self createDocumentMessionsLoaded:nil];
            return;
        }
        [dicPost setValue:_statusList forKey:@"status"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentMessionListTask" taskParam:dicPost TaskObserver:self];
}

- (void) createDocumentMessionsLoaded:(NSArray*) items
{
    messionsList = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
}

- (void) createDocumentMoreMessionsLoaded:(NSArray*) items
{
    if (!messionsList)
    {
        messionsList = [NSMutableArray array];
    }
    [messionsList addObjectsFromArray:items];
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (messionsList)
    {
        return messionsList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateDocumentMessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateDocumentMessionTableViewCell"];
    if (!cell)
    {
        cell = [[CreateDocumentMessionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreateDocumentMessionTableViewCell"];
    }
    
    // Configure the cell...
    CreateDocumetnMessionInfo* mession = messionsList[indexPath.row];
    [cell setCreateDocumentMession:mession];
    [cell.viewButton setTag:0x210 + indexPath.row];
    [cell.viewButton addTarget:self action:@selector(viewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) viewButtonClicked:(id) sender
{
    UIButton* button = (UIButton*) sender;
    NSInteger row = button.tag - 0x210;
    CreateDocumetnMessionInfo* mession = messionsList[row];
    if (1 == mession.status)
        //    if (NO)
    {
        //待录入， 跳转到选择疾病界面
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:mession.status OperateCode:kPrivilegeChooseIllOperate];
        if (!editPrivilege)
        {
            //没有查看建档评估权限
            [self showAlertMessage:@"对不起，您没有该权限。"];
            return;
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"ChooseDocumentChooseIllViewController" ControllerObject:mession];
        return;
    }
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:mession.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看建档评估权限
        [self showAlertMessage:@"对不起，您没有该权限。"];
        return;
    }
    //跳转到建档评估详情界面 CreateDocumentAssessmentDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentAssessmentDetailViewController" ControllerObject:mession];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateDocumetnMessionInfo* mession = messionsList[indexPath.row];
    if (1 == mession.status)
        //    if (NO)
    {
        //待录入， 跳转到选择疾病界面
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:mession.status OperateCode:kPrivilegeChooseIllOperate];
        if (!editPrivilege)
        {
            //没有查看建档评估权限
            [self showAlertMessage:@"对不起，您没有该权限。"];
            return;
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"ChooseDocumentChooseIllViewController" ControllerObject:mession];
        return;
    }
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:mession.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看建档评估权限
        [self showAlertMessage:@"对不起，您没有该权限。"];
        return;
    }
    //跳转到建档评估详情界面 CreateDocumentAssessmentDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentAssessmentDetailViewController" ControllerObject:mession];
    
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
    [self.tableView.superview closeWaitView];
    
    if (self.tableView.mj_footer)
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if (0 == totalCount)
    {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
    
    if (messionsList)
    {
        if (messionsList.count < totalCount)
        {
            //还有未加载的数据
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessionList)];
        }
        else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
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
    
    if ([taskname isEqualToString:@"CreateDocumentMessionListTask"])
    {
        if(taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            NSArray* items = [dicResult valueForKey:@"list"];
            if (!items || ![items isKindOfClass:[NSArray class]])
            {
                return;
            }
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];

            
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多
                [self createDocumentMoreMessionsLoaded:items];
                return;
            }
            else
            {
                [self createDocumentMessionsLoaded:items];
            }

            
            
            if (items && [items isKindOfClass:[NSArray class]])
            {
                [self createDocumentMessionsLoaded:items];
            }
            
        }
    }
}

@end
