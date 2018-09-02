//
//  RoundsTemplateListViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateListViewController.h"
#import "RoundsTemplateTableViewCell.h"

@interface RoundsTemplateListTableViewController : UITableViewController
<TaskObserver>
{
    NSArray* templateItems;
}

@property (nonatomic, readonly) RoundsTemplateCategoryWithUserModel* categoryModel;

- (id) initWithCategoryModel:(RoundsTemplateCategoryWithUserModel*) categoryModel;
@end

@interface RoundsTemplateListViewController ()
{
    NSString* targetUserId;
    RoundsTemplateCategoryWithUserModel* categoryModel;
    RoundsTemplateListTableViewController* tvcTamplateList;
}
@end

@implementation RoundsTemplateListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择查房类"];
    if (self.paramObject && [self.paramObject isKindOfClass:[RoundsTemplateCategoryWithUserModel class]])
    {
        categoryModel = (RoundsTemplateCategoryWithUserModel*) self.paramObject;
    }

    [self createTamplateListTable];
}

- (void) createTamplateListTable
{
    tvcTamplateList = [[RoundsTemplateListTableViewController alloc]initWithCategoryModel:categoryModel];
    [self addChildViewController:tvcTamplateList];
    [self.view addSubview:tvcTamplateList.tableView];
    
    [tvcTamplateList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

@implementation RoundsTemplateListTableViewController

- (id) initWithCategoryModel:(RoundsTemplateCategoryWithUserModel *)categoryMode
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _categoryModel = categoryMode;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self loadTemplateModels];
}

- (void) loadTemplateModels
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", _categoryModel.categoryId] forKey:@"roundsCategoryId"];
    [dicPost setValue:[NSNumber numberWithInteger:_categoryModel.deptId] forKey:@"deptId"];
    [self.tableView showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsTemplateListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (templateItems)
    {
        return templateItems.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsTemplateTableViewCell* cell = (RoundsTemplateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RoundsTemplateTableViewCell"];
    if (!cell)
    {
        cell = [[RoundsTemplateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundsTemplateTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RoundsTemplateModel* templateModel = templateItems[indexPath.row];
    [cell setRoundsTemplateModel:templateModel];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsTemplateModel* templateModel = templateItems[indexPath.row];
    RoundsTemplateWithUserModel* model = [[RoundsTemplateWithUserModel alloc]initWithRoundsTemplateModel:templateModel];
    [model setTargetUserId:_categoryModel.targetUserId];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"RoundsTemplateDetailViewController" ControllerObject:model];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
    
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
    
    if ([taskname isEqualToString:@"RoundsTemplateListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            templateItems = (NSArray*) taskResult;
            [self.tableView reloadData];
        }
    }
}
@end


