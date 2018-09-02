//
//  ServiceCategoryTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceCategoryTableViewController.h"
#import "ServiceCategoryTableViewCell.h"

@interface ServiceCategoryStartViewController ()
{
    UIView* tableline;
    ServiceCategoryTableViewController* tvcCategory;
}
@end

@implementation ServiceCategoryStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"服务分类"];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    tableline = [[UIView alloc]initWithFrame:CGRectMake(0, 14, self.view.width, 0.5)];
    [self.view addSubview:tableline];
    [tableline setBackgroundColor:[UIColor commonControlBorderColor]];
    
    tvcCategory = [[ServiceCategoryTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcCategory];
    [tvcCategory.tableView setTop:14];
    [self.view addSubview:tvcCategory.tableView];
    
    [self tableviewLayout];
}

- (void) tableviewLayout
{
    [tvcCategory.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(tableline.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

@end

@interface ServiceCategoryTableViewController ()
<TaskObserver>
{
    NSArray* cateItems;
}
@end

@implementation ServiceCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    
    [self loadCategoryList];
}

- (void) loadCategoryList
{
    //
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceCategoryListTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) categoryItemsLoaded:(NSArray*) items
{
    cateItems = [NSArray arrayWithArray:items];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
   
    if (cateItems)
    {
        return cateItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCategoryTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceCategoryTableViewCell"];
    }
    // Configure the cell...
    ServiceCategory* cate = cateItems[indexPath.row];
    [cell setServiceCategory:cate];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ServiceListStartViewController
    ServiceCategory* cate = cateItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceListStartViewController" ControllerObject:cate];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
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
    
    if ([taskname isEqualToString:@"ServiceCategoryListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* lstResult = (NSArray*) taskResult;
            [self categoryItemsLoaded:lstResult];
        }
    }
}
@end
