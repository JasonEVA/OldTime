//
//  SurveyMoudlesTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMoudlesTableViewController.h"
#import "NewPatientListInfoModel.h"
#import "SurveyRecord.h"
 #import "SurveyMoudleHeaderView.h"

@interface SurveyMoudlesStartViewController ()
<TaskObserver>
{
    NSArray* patients;
    
}
@end

@implementation SurveyMoudlesStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"随访模版"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]])
    {
        patients = (NSArray*) self.paramObject;
    }
    
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(surveyConfirmBBIClicked:)];
    [self.navigationItem setRightBarButtonItem:bbi];
    
    [self createMouleTable];
}

- (void) createMouleTable
{
    //创建随访模版列表
    tvcSurveyMoudles = [[SurveyMoudlesTableViewController alloc]initWithSurveyType:1];
    [self addChildViewController:tvcSurveyMoudles];
    [self.view addSubview: tvcSurveyMoudles.tableView];
    [tvcSurveyMoudles.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
}

- (void) surveyConfirmBBIClicked:(id) sender
{
    NSArray* selectMoudles = tvcSurveyMoudles.selectedMoudles;
    if (!selectMoudles || 0 == selectMoudles.count)
    {
        [self showNoMoudleMessage];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSMutableArray* userIds = [NSMutableArray array];
    for (NewPatientListInfoModel* patient in patients)
    {
        [userIds addObject:[NSString stringWithFormat:@"%ld", patient.userId]];
    }
    [dicPost setValue:userIds forKey:@"userIds"];
    
    NSMutableArray* moudleIds = [NSMutableArray array];
    for (SurveryMoudle* moudle in selectMoudles)
    {
        [moudleIds addObject:[NSString stringWithFormat:@"%ld", (long)moudle.surveyMoudleId]];
    }
    [dicPost setValue:moudleIds forKey:@"moudleIds"];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    
    [self.view showWaitView];
    //PostSurveyMoudlesTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"PostSurveyMoudlesTask" taskParam:dicPost TaskObserver:self];
}

- (void) showNoMoudleMessage
{
    [self showAlertMessage:@"请选择随访模版"];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self showSendSuccessMessage];
    return;
}

- (void) showSendSuccessMessage
{
    [self at_postSuccess:@"发送随访成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

#import "SurveyRecordsTableViewCell.h"

@interface SurveyMoudlesTableViewController ()
<TaskObserver>
{
    NSInteger selectedIndex;
    NSArray* moudleGroups;
}
@end

@implementation SurveyMoudlesTableViewController

- (id) initWithSurveyType:(NSInteger) type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        surveyType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //SurveyMoudlesTask
    [self loadSurveyMoudles];
}

- (void) loadSurveyMoudles
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:surveyType] forKey:@"surveyType"];
    [self.tableView showWaitView];
    [self.tableView setScrollEnabled:NO];
    _selectedMoudles = [NSMutableArray array];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyMoudlesTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (moudleGroups)
    {
        return moudleGroups.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == selectedIndex)
    {
        SurveryMoudleGroup* group = moudleGroups[section];
        NSArray* moudles = group.surveyMoudles;
        if (moudles)
        {
            return moudles.count;
        }
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 59;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SurveyMoudleHeaderView* headerview = [[SurveyMoudleHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 59)];
    SurveryMoudleGroup* group = moudleGroups[section];
    [headerview setIllName:group.illName];
    [headerview setTag:(0x1000 + section)];
    [headerview addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerview setIsSelected:(selectedIndex == section)];
    return headerview;
}

- (void) headerClicked:(id) sender
{
    if (![sender isKindOfClass:[SurveyMoudleHeaderView class]])
    {
        return;
    }
    SurveyMoudleHeaderView* headerview = (SurveyMoudleHeaderView*) sender;
    NSInteger section = headerview.tag - 0x1000;
    if (section == selectedIndex)
    {
        return;
    }
    selectedIndex = section;
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveryMoudleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveryMoudleTableViewCell"];
    if (!cell)
    {
        cell = [[SurveryMoudleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveryMoudleTableViewCell"];
    }
    // Configure the cell...
    SurveryMoudleGroup* group = moudleGroups[indexPath.section];
    NSArray* moudles = group.surveyMoudles;
    SurveryMoudle* moudle = moudles[indexPath.row];
    [cell setMoudleName:moudle.surveyMoudleName];
    [cell.previewButton setTag:(0x1000 * indexPath.section + indexPath.row)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setIsSelected:[self surveyMoudleIsSelected:moudle]];
    [cell.previewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (BOOL) surveyMoudleIsSelected:(SurveryMoudle*) moudle
{
    if (!_selectedMoudles && 0 == _selectedMoudles.count) {
        return NO;
    }
    for (SurveryMoudle* selmoudle in _selectedMoudles)
    {
        if (moudle == selmoudle) {
            return YES;
        }
    }
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveryMoudleGroup* group = moudleGroups[indexPath.section];
    NSArray* moudles = group.surveyMoudles;
    SurveryMoudle* moudle = moudles[indexPath.row];
    
    if ([self surveyMoudleIsSelected:moudle])
    {
        [_selectedMoudles removeObject:moudle];
    }
    else
    {
        [_selectedMoudles addObject:moudle];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) previewButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* previewButton = (UIButton*) sender;
    NSInteger tag = previewButton.tag;
    NSInteger section = tag / 0x1000;
    NSInteger row = tag % 0x1000;
    SurveryMoudleGroup* group = moudleGroups[section];
    NSArray* moudles = group.surveyMoudles;
    SurveryMoudle* moudle = moudles[row];
    
    //跳转到随访／问诊模版详情 SurveyMoudleDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMoudleDetailViewController" ControllerObject:moudle];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
    [self.tableView setScrollEnabled:YES];
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!moudleGroups || 0 == moudleGroups.count)
    {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
        [self.tableView reloadData];
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
    
    if (taskResult && [taskResult isKindOfClass:[NSArray class]])
    {
        moudleGroups = (NSArray*) taskResult;
       // [self.tableView reloadData];
        
    }
}

@end

@implementation InterrogationMoudlesStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"问诊模版"];
}

- (void) createMouleTable
{
    //创建随访模版列表
    tvcSurveyMoudles = [[SurveyMoudlesTableViewController alloc]initWithSurveyType:4];
    [self addChildViewController:tvcSurveyMoudles];
    [self.view addSubview: tvcSurveyMoudles.tableView];
    [tvcSurveyMoudles.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void) showNoMoudleMessage
{
    [self showAlertMessage:@"请选择问诊模版"];
}

- (void) showSendSuccessMessage
{
    [self.navigationController popViewControllerAnimated:YES];
    [self at_postSuccess:@"发送问诊成功"];
}
@end
