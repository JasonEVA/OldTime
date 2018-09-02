//
//  BloodPressurePeriodSelectViewController.m
//  HMClient
//
//  Created by lkl on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressurePeriodSelectViewController.h"
#import "BloodPressureThriceDetectModel.h"

@interface BloodPressurePeriodSelectViewController ()<UITableViewDataSource,UITableViewDelegate,TaskObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataListArray;

@end

@implementation BloodPressurePeriodSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view showWaitView];
    if ([_type isEqualToString:@"period"]) {
        [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectPeriodTask" taskParam:nil TaskObserver:self];
    }
    else{
        [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectBodyStatusTask" taskParam:nil TaskObserver:self];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeControlClicked
{
    if (_selectblock)
    {
        _selectblock(nil);
    }
    [self closeTestTimeView];
}

- (void) closeTestTimeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

+ (BloodPressurePeriodSelectViewController *) createWithParentViewController:(UIViewController*) parentviewcontroller setUpType:(NSString *)setUpType selectblock:(SetupSelectSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    
    BloodPressurePeriodSelectViewController *selectVC = [[BloodPressurePeriodSelectViewController alloc] initWithNibName:nil bundle:nil];
    selectVC.type = setUpType;
    [parentviewcontroller addChildViewController:selectVC];
    [selectVC.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:selectVC.view];
    
    [selectVC setSelectblock:block];
    return selectVC;
}

- (void)createTableView
{
    if (_dataListArray.count == 0) {
        return;
    }
    
    float tableheight = _dataListArray.count * 45 + 30;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height - 50;
    }
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(tableheight);
    }];
    
}

#pragma mark - tableViewDatasouceAndDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    if ([_type isEqualToString:@"period"]) {
        [lbtitle setText:@"请选择时段"];
    }
    else{
        [lbtitle setText:@"请选择测量状态"];
    }
    
    [lbtitle setFont:[UIFont font_26]];
    [lbtitle setTextColor:[UIColor mainThemeColor]];
    [headerView addSubview:lbtitle];
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectTestDeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    BloodPressureThriceDetectModel *model = _dataListArray[indexPath.row];
    [cell.textLabel setText:model.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectblock)
    {
        _selectblock(_dataListArray[indexPath.row]);
    }
    
    [self closeTestTimeView];
}


#pragma mark - Init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView.layer setCornerRadius:10.0f];
        [_tableView.layer setMasksToBounds:YES];
    }
    return _tableView;
}

#pragma mark -- TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
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
    
    if ([taskname isEqualToString:@"BloodPressureThriceDetectPeriodTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            _dataListArray = (NSArray *)taskResult;
            [self createTableView];
        }
    }
    
    if ([taskname isEqualToString:@"BloodPressureThriceDetectBodyStatusTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            _dataListArray = (NSArray *)taskResult;
            [self createTableView];
        }
    }
}
@end
