//
//  BloodSugarDetectTestPeriodViewController.m
//  HMClient
//
//  Created by lkl on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectTestPeriodViewController.h"

@interface BloodSugarDetectTestPeriodViewController ()
<TaskObserver,UITableViewDataSource,UITableViewDelegate>
{
    NSString *periodsTaskId;
    NSArray *testtimeitems;
    UITableView* testtiemTableView;
}

@property (nonatomic, assign) BOOL isDeviceTest;      //是否设备监测
@property (nonatomic, copy) TestPeriodSelectBlock selectblock;

@end

@implementation BloodSugarDetectTestPeriodViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (testtimeitems)
    {
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@"XT" forKey:@"kpiCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PostUserTestPeriodTask" taskParam:dicPost TaskObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

+ (BloodSugarDetectTestPeriodViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                  isDevice:(BOOL) isDevice
                                                               selectblock:(TestPeriodSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    BloodSugarDetectTestPeriodViewController* vctesttime = [[BloodSugarDetectTestPeriodViewController alloc]initWithNibName:nil bundle:nil];
    [vctesttime setIsDeviceTest:isDevice];
    [parentviewcontroller addChildViewController:vctesttime];
    [vctesttime.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vctesttime.view];
    
    [vctesttime setSelectblock:block];
    return vctesttime;
}


- (void) closeControlClicked:(id) sender
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (testtimeitems)
    {
        return testtimeitems.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TestPeriodCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestPeriodCell"];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    NSString *testPeriod = [[testtimeitems objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",testPeriod]];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDic = [testtimeitems objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(tempDic);
    }
    
    [self closeTestTimeView];
}
- (void) createTestTimeTableView
{
    if (!testtimeitems)
    {
        return;
    }
    float tableheight = testtimeitems.count * 45;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height- 50;
    }
    
    testtiemTableView = [[UITableView alloc]init];
    [self.view addSubview:testtiemTableView];
    [testtiemTableView setDataSource:self];
    [testtiemTableView setDelegate:self];
    [testtiemTableView.layer setCornerRadius:5.0f];
    [testtiemTableView.layer setMasksToBounds:YES];
    
    [testtiemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(tableheight);
    }];
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

}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (taskId)
    {
        NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
        if (!taskname && 0 < taskname.length) {
            return;
        }
        if ([taskname isEqualToString:@"PostUserTestPeriodTask"])
        {
            testtimeitems = (NSArray *)taskResult;
            [self createTestTimeTableView];
        }
    }
}


@end
