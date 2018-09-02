//
//  DepartmentSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DepartmentSelectViewController.h"



@interface DepartmentSelectViewController ()
<TaskObserver,
DepartmentSelectDelegate>
{
    NSInteger orgId;
    UIControl* closecontrol;
}

@property (nonatomic, weak) id<DepartmentSelectDelegate> delegate;

- (id) initWithOrgId:(NSInteger) aOrgId;
@end

@interface DepartmentSelectTableViewController : UITableViewController
{
    NSArray* departments;
}

@property (nonatomic, weak) id<DepartmentSelectDelegate> selectDelegate;
- (id) initWithDepartments:(NSArray*) departmentItems;
@end

@implementation DepartmentSelectViewController

- (id) initWithOrgId:(NSInteger) aOrgId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        orgId = aOrgId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    closecontrol = [[UIControl alloc]init];
    [self.view addSubview:closecontrol];
    [closecontrol setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.and.top.equalTo(self.view);
    }];
    
    [closecontrol addTarget:self action:@selector(closecontrolClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self loadDepartments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closecontrolClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<DepartmentSelectDelegate>) delegate
                          OrgId:(NSInteger) orgId
{
    if (!parentController)
    {
        return;
    }
    
    NSArray* childlist = [parentController childViewControllers];
    for (UIViewController* vcChild in childlist)
    {
        if ([vcChild isKindOfClass:[OrgTeamSelectViewController class]])
        {
            return;
        }
    }
    
    DepartmentSelectViewController* vcSelect = [[DepartmentSelectViewController alloc]initWithOrgId:orgId];
    [vcSelect setDelegate:delegate];
    
    [parentController addChildViewController:vcSelect];
    [parentController.view addSubview:vcSelect.view];
    
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
}

- (void) loadDepartments
{
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", orgId] forKey:@"orgId"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceProviderDeptListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - DepartmentSelectDelegate
- (void) departmentSelected:(DepartmentInfo *)department
{
    if (department)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(departmentSelected:)])
        {
            [_delegate departmentSelected:department];
        }
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId && 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname && 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceProviderDeptListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSMutableArray* departmentItems = [NSMutableArray arrayWithArray:(NSArray*) taskResult] ;
            if (0 == departmentItems.count)
            {
                [self showAlertMessage:@"没有获取到相应科室。"];
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
                return;
            }
            DepartmentInfo* department = [[DepartmentInfo alloc]init];
            [department setDepName:@"所有科室"];
            [departmentItems insertObject:department atIndex:0];
            
            CGFloat maxHeihgt = self.view.height/2;
            if (maxHeihgt > departmentItems.count * 44)
            {
                maxHeihgt = departmentItems.count * 44;
            }
            DepartmentSelectTableViewController* tvcSelect = [[DepartmentSelectTableViewController alloc]initWithDepartments:departmentItems];
            [self addChildViewController:tvcSelect];
            [tvcSelect setSelectDelegate:self];
            [self.view addSubview:tvcSelect.tableView];
            [tvcSelect.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.view);
                make.height.mas_equalTo([NSNumber numberWithFloat:maxHeihgt]);
            }];
            
            
        }
        
    }
}

@end

@implementation DepartmentSelectTableViewController

- (id) initWithDepartments:(NSArray *)departmentItems
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        departments = [NSArray arrayWithArray:departmentItems];
    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (departments)
    {
        return departments.count;;
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

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HosipitalSelectTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HosipitalSelectTableCell"];
    }
    
    DepartmentInfo* department = departments[indexPath.row];
    [cell.textLabel setText:department.depName];
    [cell.textLabel setFont:[UIFont font_30]];
    [cell.textLabel setTextColor:[UIColor commonTextColor]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentInfo* department = departments[indexPath.row];
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(departmentSelected:)])
    {
        [_selectDelegate departmentSelected:department];
    }
}
@end
