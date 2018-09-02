//
//  PrescribeStartViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeStartViewController.h"
#import "PatientInfo.h"
#import "PrescribeStartTableViewCell.h"
#import "PrescribeListStartTableViewCell.h"
#import "PrescribeInfo.h"
#import "PrescribeCreateRecipeViewController.h"
#import "UserAlertInfo.h"
#import "HMThirdEditionPatitentInfoModel.h"

#define kPrescribeTaskPageSize 1000
@interface PrescribeStartViewController ()<TaskObserver>
{
    PatientInfo *info;
    PrescribeStartTableViewController *tvcPrescribeStart;
}
@end

@interface PrescribeStartTableViewController ()<TaskObserver>
{
    
    NSMutableArray *PrescribeItem;
    
}

@end

@implementation PrescribeStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && ([self.paramObject isKindOfClass:[PatientInfo class]] || [self.paramObject isKindOfClass:[UserAlertInfo class]]))
    {
        info = (PatientInfo *)self.paramObject;
        UserAlertInfo *alertInfo = (UserAlertInfo *)self.paramObject;
        info.testResulId = alertInfo.testResulId;
    }
    if (!info.sex) {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (空, 00)", info.userName]];
        [self startPatientInfoRequest];
    }
    else {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", info.userName, info.sex, info.age]];
    }

    
    [self initWithSubViews];
}

- (void)startPatientInfoRequest {
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",info.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}

- (void) initWithSubViews
{
    tvcPrescribeStart = [[PrescribeStartTableViewController alloc]initWithStyle:UITableViewStylePlain];
    //[tvcPatients.tableView setFrame:rtTable];
    tvcPrescribeStart.patientinfo = info;
    [self addChildViewController:tvcPrescribeStart];
    [self.view addSubview:tvcPrescribeStart.tableView];

    UIButton* createRecipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:createRecipeButton];
    [createRecipeButton setTitle:@"新增建议" forState:UIControlStateNormal];
    [createRecipeButton setBackgroundColor:[UIColor mainThemeColor]];
    [createRecipeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createRecipeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [createRecipeButton.layer setCornerRadius:5.0f];
    [createRecipeButton.layer setMasksToBounds:YES];
    
    [createRecipeButton addTarget:self action:@selector(createRecipeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [createRecipeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    
    [tvcPrescribeStart.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(createRecipeButton.mas_top).with.offset(-10);
    }];
    
}



- (void)createRecipeButtonClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeCreateRecipeViewController" ControllerObject:info];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
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
    
    if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"])
    {
        HMThirdEditionPatitentInfoModel *model = (HMThirdEditionPatitentInfoModel *)taskResult;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", model.userInfo.userName, model.userInfo.sex, model.userInfo.age]];
        info.userName = model.userInfo.userName;
        info.sex = model.userInfo.sex;
        info.age = model.userInfo.age;
        
    }
    
}

@end


@implementation PrescribeStartTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //请求数据
    [self reloadDataPost];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
}

- (void)reloadDataPost
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", _patientinfo.userId] forKey:@"userId"];
    NSInteger rows = kPrescribeTaskPageSize;
    /*if (customTasks && 0 < customTasks.count)
     {
     rows = customTasks.count;
     }*/
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"size"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PrescribeListTask" taskParam:dicPost TaskObserver:self];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PrescribeItem.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrescribeInfo* prescribe = [PrescribeItem objectAtIndex:indexPath.section];
    
    PrescribeListStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescribeListStartTableViewCell"];
    
    if (!cell)
    {
        cell = [[PrescribeListStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrescribeListStartTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.buttonCopy setTag:indexPath.section];
    [cell.buttonCopy addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setPrescribeInfo:prescribe];
    
    return cell;
}

//设置可以进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrescribeInfo* prescribe = [PrescribeItem objectAtIndex:indexPath.section];
    //已停止的处方不可编辑
    if([prescribe.status isEqualToString:@"R"])
    {
        return NO;
    }
    return YES;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrescribeInfo* prescribe = [PrescribeItem objectAtIndex:indexPath.section];
    
    //取消
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *cancelRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"取消");
        
        [strongSelf reloadDataPost];
        
    }];
    
    [cancelRowAction setBackgroundColor:[UIColor commonCuttingLineColor]];
    
    //停止处方
    
    UITableViewRowAction *stopRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"停止" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        
        [dicPost setValue:prescribe.userRecipeId forKey:@"userRecipeId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"StopRecipeTask" taskParam:dicPost TaskObserver:strongSelf];
        
    }];
    
    [stopRowAction setBackgroundColor:[UIColor mainThemeColor]];
    
    return @[cancelRowAction,stopRowAction];
    //return @[stopRowAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //处方详情 H5页面
    PrescribeInfo* prescribe = [PrescribeItem objectAtIndex:indexPath.section];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"PrescrbeStartDetailViewController" ControllerObject:prescribe];
}


- (void) copyButtonClick:(UIButton *)sender
{
    PrescribeInfo* prescribe = [PrescribeItem objectAtIndex:sender.tag];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    [tempArr addObject:prescribe];
    [tempArr addObject:_patientinfo];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeCreateRecipeViewController" ControllerObject:tempArr];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
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
    
    if ([taskname isEqualToString:@"PrescribeListTask"])
    {
        NSDictionary* dicResult = (NSDictionary*)taskResult;
        
        PrescribeItem = [dicResult valueForKey:@"list"];
        [self.tableView reloadData];
    }
    
   else if ([taskname isEqualToString:@"StopRecipeTask"])
    {
        [self reloadDataPost];
    }
}

@end
