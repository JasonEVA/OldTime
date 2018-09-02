//
//  AssessmentTemplateSelectViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentTemplateSelectViewController.h"
#import "AssessmentMessionModel.h"

@interface AssessmentTemplateSelectViewController ()
{
    AssessmentTemplateSelectTableViewController *tvcTemplateCategory;
    AssessmentCategoryDetailsModel *detailsModel;
}

@end

@interface AssessmentTemplateSelectTableViewController ()<TaskObserver>
{
    AssessmentCategoryDetailsModel *detailsModel;
}
@property (nonatomic, assign) NSInteger assessmentCategoryId;
@property (nonatomic, assign) NSInteger deptId;
@property (nonatomic, strong) NSArray *assessmentTemplateList;

//患者id
@property (nonatomic, copy)NSString *patientUserId;
@end

@implementation AssessmentTemplateSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"选择评估表"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AssessmentCategoryDetailsModel class]])
    {
        detailsModel = (AssessmentCategoryDetailsModel *)self.paramObject;
        
    }
    
    [self createTemplateCategoryTable];
}

//创建评估表分类列表
- (void) createTemplateCategoryTable
{
    tvcTemplateCategory = [[AssessmentTemplateSelectTableViewController alloc]init];
    tvcTemplateCategory.assessmentCategoryId = detailsModel.categoryId;
    tvcTemplateCategory.deptId = detailsModel.deptId;
    tvcTemplateCategory.patientUserId = detailsModel.patientUserId;
    [self addChildViewController:tvcTemplateCategory];
    [self.view addSubview:tvcTemplateCategory.tableView];
    
    [tvcTemplateCategory.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@implementation AssessmentTemplateSelectTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",_assessmentCategoryId] forKey:@"assessmentCategoryId"];
    [dicPost setValue:[NSNumber numberWithInteger:_deptId] forKey:@"deptId"];
    
    [self.tableView showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AssessmentTemplateListTask" taskParam:dicPost TaskObserver:self];
}


#pragma mark -- UITableViewDelegate And UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assessmentTemplateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentTemplateModel *templateModel = [_assessmentTemplateList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor commonTextColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setText:templateModel.templateName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentTemplateModel *templateModel = [_assessmentTemplateList objectAtIndex:indexPath.row];
    templateModel.patientUserId = _patientUserId;
    [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentTemplateDetailViewController" ControllerObject:templateModel];
}

#pragma mark -- TaskObserver

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"AssessmentTemplateListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            _assessmentTemplateList = (NSArray *)taskResult;
            [self.tableView reloadData];
        }
    }
}

@end
