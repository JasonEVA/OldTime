//
//  ServiceListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceListTableViewController.h"
#import "ServiceCategory.h"
#import "ServiceInfoTableViewCell.h"
#import "ServiceGoodsInfoTableViewCell.h"
#import "DoctorTeamOrgDeptSelectView.h"
#import "ServiceProviderOrgSelectViewController.h"
#import "ServiceProviderDeptSelectViewController.h"
#import "ServiceSearchModel.h"

@interface ServiceListStartViewController ()
<ServiceProviderOrgSelectDelegate,
ServiceProviderDeptSelectDelegate>
{
    ServiceCategory* category;
    ServiceListTableViewController* tvcServiceList;
    DoctorTeamOrgDeptSelectView* selectview;
    
    UIViewController* vcTableContent;
    NSInteger selectedOrgId;
    NSInteger selectedDeptId;
}
@end

@implementation ServiceListStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceCategory class]])
    {
        //category = [ServiceCategory mj_objectWithKeyValues:self.paramObject];
        category = (ServiceCategory*)self.paramObject;
        [self.navigationItem setTitle:category.name];
        //创建搜索按钮
        UIBarButtonItem* bbiSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_image"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:bbiSearch];
        
        selectview = [[DoctorTeamOrgDeptSelectView alloc]init];
        [selectview setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:selectview];
        [selectview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.mas_equalTo(@44);
        }];
        
        [selectview.orgSelectCell addTarget:self action:@selector(orgselectcellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [selectview.deptSelectCell addTarget:self action:@selector(deptselectcellClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        vcTableContent = [[UIViewController alloc]initWithNibName:nil bundle:nil];
        [self addChildViewController:vcTableContent];
        [self.view addSubview:vcTableContent.view];
        [vcTableContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(selectview.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
        
        
        tvcServiceList = [[ServiceListTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [tvcServiceList setCate:category];
        
        [vcTableContent addChildViewController:tvcServiceList];
//        [tvcServiceList.tableView setTop:0];
        [vcTableContent.view addSubview:tvcServiceList.tableView];
        
        [self tableLayout];
        
        
    }
}

- (void) tableLayout
{
    [tvcServiceList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(vcTableContent.view);
        make.top.equalTo(vcTableContent.view);
        make.bottom.equalTo(vcTableContent.view);
    }];
}

- (void) searchBarButtonClicked:(id) sender
{
    //搜索按钮点击事件 SearchServiceStartViewController
    ServiceSearchModel* searchModel = [[ServiceSearchModel alloc]init];
    searchModel.productTypeId = category.productTypeId;

    
    [HMViewControllerManager createViewControllerWithControllerName:@"SearchServiceStartViewController" ControllerObject:searchModel];
    
}

- (void) orgselectcellClicked:(id) sender
{
    [ServiceProviderOrgSelectViewController showInParentController:vcTableContent Delegate:self productTypeId:category.productTypeId];
}

- (void) deptselectcellClicked:(id) sender
{
    if (0 == selectedOrgId)
    {
        [self showAlertMessage:@"请先选择医院"];
        return;
    }
    [ServiceProviderDeptSelectViewController showInParentController:vcTableContent Delegate:self OrgId:selectedOrgId productTypeId:category.productTypeId];
}



#pragma mark - ServiceProviderOrgSelectDelegate
- (void) hosipitalSelected:(HosipitalInfo *)hosipital
{
    if (!hosipital)
    {
        return;
    }
    [selectview.orgSelectCell setSelectedName:hosipital.orgShortName];
    selectedOrgId = hosipital.orgId;
    [selectview.deptSelectCell setSelectedName:@"全部科室"];
    selectedDeptId = 0;
    
    [tvcServiceList setSelectedOrgId:selectedOrgId];
}


- (void) departmentSelected:(DepartmentInfo *)department
{
    if (!department)
    {
        return;
    }
    [selectview.deptSelectCell setSelectedName:department.depName];
    selectedDeptId = department.depId;
    
    [tvcServiceList setSelectedDeptId:selectedDeptId];
}
@end

@interface ServiceListTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger totalCount;
    NSMutableArray* serviceList;
    
    NSInteger selectedOrgId;
    NSInteger selectedDeptId;
}

@end


@implementation ServiceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadServiceList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self loadServiceList];
}

- (void) loadServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", _cate.productTypeId] forKey:@"productTypeId"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];
    
    if (selectedOrgId > 0) {
        [dicPost setValue:@[[NSString stringWithFormat:@"%ld", selectedOrgId]] forKey:@"orgIds"];
    }
    if (selectedDeptId > 0)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedDeptId] forKey:@"depId"];
    }
    if (serviceList && serviceList.count > 0)
    {
        [dicPost setValue:[NSNumber numberWithInteger:serviceList.count] forKey:@"rows"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", _cate.productTypeId] forKey:@"productTypeId"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];
    if (serviceList && serviceList.count > 0)
    {
        [dicPost setValue:[NSNumber numberWithInteger:serviceList.count] forKey:@"startRow"];
    }
    if (selectedOrgId > 0) {
        [dicPost setValue:@[[NSString stringWithFormat:@"%ld", selectedOrgId]] forKey:@"orgIds"];
    }
    if (selectedDeptId > 0)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedDeptId] forKey:@"depId"];
    }
    //ServiceListTask
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceListTask" taskParam:dicPost TaskObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) serviceListLoaded:(NSArray*) services
{
    serviceList = [NSMutableArray arrayWithArray:services];
    [self.tableView reloadData];
    
    if (serviceList.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
    }
    
}

- (void) moreServiceListLoaded:(NSArray*) services
{
    if (!serviceList)
    {
        serviceList = [NSMutableArray array];
    }
    [serviceList addObjectsFromArray:services];
    [self.tableView reloadData];
    
    if (serviceList.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
    }
}

- (void) setSelectedOrgId:(NSInteger) orgId
{
    selectedOrgId = orgId;
    selectedDeptId = 0;
    if (serviceList)
    {
        [serviceList removeAllObjects];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void) setSelectedDeptId:(NSInteger) deptId
{
    selectedDeptId = deptId;
    if (serviceList)
    {
        [serviceList removeAllObjects];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (serviceList)
    {
        return serviceList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceList[indexPath.row];
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        return 110;
    }
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceInfo* service = serviceList[indexPath.row];
    ServiceInfoTableViewCell *cell = nil;
    //TODO:判断是否是商品
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        //商品Cell
        ServiceGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceGoodsInfoTableViewCell"];
        if (!cell) {
            cell = [[ServiceGoodsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceGoodsInfoTableViewCell"];
        }
        [cell setServiceGoodsInfo:service];
        return cell;
    }
    else
    {
        //套餐服务Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceInfoTableViewCell" ];
        if (!cell)
        {
            cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
        }
        if (service.grade && service.grade > 0)
        {
            [cell setServiceInfo:service isGrade:YES];
        }else{
            [cell setServiceInfo:service isGrade:NO];
        }
    }
    
    // Configure the cell...
    if (!cell) {
         cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceList[indexPath.row];
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setUpId:service.upId];
    [serviceInfo setProductName:service.productName];
    [serviceInfo setClassify:service.classify];
    [serviceInfo setImgUrl:service.imgUrl];
    
    if (![service isGoods]) {
        //服务详情
//        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" ControllerObject:serviceInfo];
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
    }
    else
    {
        //商品详情
//        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceGoodsDetailStartViewController" ControllerObject:serviceInfo];
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
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
    
    if ([taskname isEqualToString:@"ServiceListTask"])
    {
    
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]]) {
                totalCount = numCount.integerValue;
            }
            
            NSArray* items = (NSArray*) [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多。。。
                [self moreServiceListLoaded:items];
                return;
            }
            else
            {
                [self serviceListLoaded:items];
            }

        }
        
    }
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!serviceList ||serviceList.count == 0) {
        return YES;
    }
    return NO;
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
