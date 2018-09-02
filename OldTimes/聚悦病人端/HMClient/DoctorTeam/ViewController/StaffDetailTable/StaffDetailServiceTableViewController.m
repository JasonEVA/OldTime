//
//  StaffDetailServiceTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailServiceTableViewController.h"
#import "ServiceInfoTableViewCell.h"

@interface StaffDetailServiceTableViewController ()
<TaskObserver>
{
    NSArray* serviceItems;
}
@end

@implementation StaffDetailServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffServicesTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (serviceItems)
    {
        return serviceItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

- (CGFloat) footerHeight:(NSInteger) section
{
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeight:section];
    
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceInfoTableViewCell"];

    if (!cell)
    {
        cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
    }
    // Configure the cell...
    ServiceInfo* service = serviceItems[indexPath.row];
    
    if (service.grade && service.grade > 0)
    {
        [cell setServiceInfo:service isGrade:YES];
    }else{
        [cell setServiceInfo:service isGrade:NO];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceItems[indexPath.row];
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setProductName:service.productName];
    [serviceInfo setUpId:service.upId];
    [serviceInfo setClassify:service.classify];
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
    //[self.tableView.mj_footer endRefreshing];
    if (StepError_None != taskError) {
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
    
    if (!taskname || 0 == taskname)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"StaffServicesTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* services = (NSArray*) taskResult;
            serviceItems = [NSArray arrayWithArray:services];
            [self.tableView reloadData];
        }
    }
}
@end
