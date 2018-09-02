//
//  RoundsTemplateCategoryListViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateCategoryListViewController.h"
#import "RoundsTemplateTableViewCell.h"

@interface RoundsTemplateCategoryTableViewController : UITableViewController
<TaskObserver>
{
    NSArray* categoryListModels;
}

@property (nonatomic, readonly) NSString* targetUserId;

- (id) initWithTargetUserId:(NSString*) targetUserId;
@end

@interface RoundsTemplateCategoryListViewController ()
{
    RoundsTemplateCategoryTableViewController* tvcCategory;
    NSString* targetUserId;
}

@end

@implementation RoundsTemplateCategoryListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择查房表分类"];
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        targetUserId = (NSString*) self.paramObject;
    }
    
    [self createCategoryTable];
}

- (void) createCategoryTable
{
    tvcCategory = [[RoundsTemplateCategoryTableViewController alloc]initWithTargetUserId:targetUserId];
    [self addChildViewController:tvcCategory];
    [self.view addSubview:tvcCategory.tableView];
    
    [tvcCategory.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

@implementation RoundsTemplateCategoryTableViewController

- (id) initWithTargetUserId:(NSString*) targetUserId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _targetUserId = targetUserId;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self loadCategoryModels];
}

- (void) loadCategoryModels
{
    
    [self.tableView.superview showWaitView];
    //RoundsTemplateListTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsTemplateCategoryListTask" taskParam:nil TaskObserver:self];
}

/*
//创建测试数据
- (void) createCategoryModels
{
    NSArray* cateNames = @[@"高血压", @"糖尿病", @"高血糖"];
    RoundsTemplateCategoryListModel* heartBloodBriefsCategroyListModel = [[RoundsTemplateCategoryListModel alloc]init];
    [heartBloodBriefsCategroyListModel setDepId:0x1100];
    [heartBloodBriefsCategroyListModel setDepName:@"心血内科"];
    [heartBloodBriefsCategroyListModel setIsExpended:YES];
    
    NSMutableArray* heartBloodBriefsCategroyList = [NSMutableArray array];
    for (NSString* catename in cateNames)
    {
        RoundsTemplateCategoryModel* categoryModel = [[RoundsTemplateCategoryModel alloc]init];
        [categoryModel setRoundsTemplateCategoryName:catename];
        [heartBloodBriefsCategroyList addObject:categoryModel];
    }
    [heartBloodBriefsCategroyListModel setCategoryList:heartBloodBriefsCategroyList];
    
    RoundsTemplateCategoryListModel* endocrineDepartmentCategroyListModel = [[RoundsTemplateCategoryListModel alloc]init];
    [endocrineDepartmentCategroyListModel setDepId:0x1101];
    [endocrineDepartmentCategroyListModel setDepName:@"内分泌科"];
    NSMutableArray* endocrineDepartmentCategroyList = [NSMutableArray array];
    for (NSString* catename in cateNames)
    {
        RoundsTemplateCategoryModel* categoryModel = [[RoundsTemplateCategoryModel alloc]init];
        [categoryModel setRoundsTemplateCategoryName:catename];
        [endocrineDepartmentCategroyList addObject:categoryModel];
    }
    [endocrineDepartmentCategroyListModel setCategoryList:endocrineDepartmentCategroyList];
    
    RoundsTemplateCategoryListModel* generalSurgeryDepartmentCategroyListModel = [[RoundsTemplateCategoryListModel alloc]init];
    [generalSurgeryDepartmentCategroyListModel setDepId:0x1102];
    [generalSurgeryDepartmentCategroyListModel setDepName:@"普外科"];
    NSMutableArray* generalSurgeryDepartmentCategroyList = [NSMutableArray array];
    for (NSString* catename in cateNames)
    {
        RoundsTemplateCategoryModel* categoryModel = [[RoundsTemplateCategoryModel alloc]init];
        [categoryModel setRoundsTemplateCategoryName:catename];
        [generalSurgeryDepartmentCategroyList addObject:categoryModel];
    }
    [generalSurgeryDepartmentCategroyListModel setCategoryList:generalSurgeryDepartmentCategroyList];
    categoryListModels = @[heartBloodBriefsCategroyListModel, endocrineDepartmentCategroyListModel, generalSurgeryDepartmentCategroyListModel];
    [self.tableView reloadData];
}
*/
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (categoryListModels)
    {
        return categoryListModels.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RoundsTemplateCategoryListModel* listModel = categoryListModels[section];
    if (!listModel.isExpanded)
    {
        return 0;
    }
    NSArray* cateList = listModel.details;
    if (cateList)
    {
        return cateList.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsTemplateCategoryTableViewCell* cell = (RoundsTemplateCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RoundsTemplateCategoryTableViewCell"];
    if (!cell)
    {
        cell = [[RoundsTemplateCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundsTemplateCategoryTableViewCell"];
    }
    
    RoundsTemplateCategoryListModel* listModel = categoryListModels[indexPath.section];
    RoundsTemplateCategoryModel* cateModel = listModel.details[indexPath.row];
    [cell setRoundsTemplateCategoryModel:cateModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIControl* headerview = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview showTopLine];
    [headerview showBottomLine];
    
    UIImageView* ivArrow = [[UIImageView alloc]init];
    [headerview addSubview:ivArrow];
    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.left.equalTo(headerview).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UILabel* departmentLable = [[UILabel alloc]init];
    [headerview addSubview:departmentLable];
    [departmentLable setFont:[UIFont font_30]];
    [departmentLable setTextColor:[UIColor commonTextColor]];
    [departmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(40);
        make.centerY.equalTo(headerview);
    }];
    RoundsTemplateCategoryListModel* listModel = categoryListModels[section];
    [departmentLable setText:listModel.deptName];
    [headerview setTag:0x2400 + section];
    
    [headerview addTarget:self action:@selector(departHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (listModel.isExpanded){
        
        [ivArrow setImage:[UIImage imageNamed:@"im-retract"]];
    }
    else{
        [ivArrow setImage:[UIImage imageNamed:@"im-spread"]];
    }
    return headerview;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [footerview showTopLine];
    return footerview;
}

- (void) departHeaderViewClicked:(id) sender
{
    UIControl* headerview = (UIControl*) sender;
    NSInteger section = headerview.tag - 0x2400;
    RoundsTemplateCategoryListModel* listModel = categoryListModels[section];
    [listModel setIsExpanded:!listModel.isExpanded];
    [self.tableView reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsTemplateCategoryListModel* listModel = categoryListModels[indexPath.section];
    RoundsTemplateCategoryModel* cateModel = listModel.details[indexPath.row];
    RoundsTemplateCategoryWithUserModel* userCateModel = [[RoundsTemplateCategoryWithUserModel alloc]initWithRoundsTemplateCategoryModel:cateModel];
    [userCateModel setTargetUserId:_targetUserId];
    [HMViewControllerManager createViewControllerWithControllerName:@"RoundsTemplateListViewController" ControllerObject:userCateModel];
    
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
    if (taskError != StepError_None) {
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
    if ([taskname isEqualToString:@"RoundsTemplateCategoryListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            categoryListModels = (NSArray*) taskResult;
            [self.tableView reloadData];
        }
    }
}
@end
