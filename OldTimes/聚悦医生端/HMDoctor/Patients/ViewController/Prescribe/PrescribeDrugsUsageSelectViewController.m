//
//  PrescribeDrugsUsageSelectViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeDrugsUsageSelectViewController.h"


@interface PrescribeDrugsUsageSelectViewController ()<TaskObserver,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* prescribeDrugsUsageTableView;
    
    NSMutableArray *drugsItem;
}
@end

@implementation PrescribeDrugsUsageSelectViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    if ([_drugsUsage isEqualToString:@"usage"])
    {
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
        
        [self.view showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"DrugsUsageListTask" taskParam:nil TaskObserver:self];
    }
    
    if ([_drugsUsage isEqualToString:@"frequency"])
    {
        [self.view showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"DrugsFrequencyListTask" taskParam:nil TaskObserver:self];
    }

    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

+ (PrescribeDrugsUsageSelectViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                       drugsUsage:(NSString *)usage
                                                  selectblock:(DrugUsageSelectBlock)block;
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    PrescribeDrugsUsageSelectViewController* vcPrescribeDrugsUsage = [[PrescribeDrugsUsageSelectViewController alloc]initWithNibName:nil bundle:nil];
    vcPrescribeDrugsUsage.drugsUsage = usage;
    [parentviewcontroller addChildViewController:vcPrescribeDrugsUsage];
    [vcPrescribeDrugsUsage.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vcPrescribeDrugsUsage.view];
    
    [vcPrescribeDrugsUsage setSelectblock:block];
    
    return vcPrescribeDrugsUsage;
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
    if (drugsItem)
    {
        return drugsItem.count;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }

    if ([_drugsUsage isEqualToString:@"usage"])
    {
        DrugsUsagesInfo *drug = [drugsItem objectAtIndex:indexPath.row];
        [cell.textLabel setText:drug.drugsUsageName];
    }
    if ([_drugsUsage isEqualToString:@"frequency"])
    {
        DrugsFrequencyInfo *frequency = [drugsItem objectAtIndex:indexPath.row];
        [cell.textLabel setText:frequency.drugsFrequencyCode];
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrugsUsagesInfo *bandCardInfo = [drugsItem objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(bandCardInfo);
    }
    
    [self closeTestTimeView];
    
}
- (void) createPrescribeDrugsUsageTableView
{
    if (!drugsItem)
    {
        return;
    }
    
    float tableheight;
    if (drugsItem.count > 5){
        
       tableheight = 5 * 44;
        
    }else{
        tableheight = drugsItem.count * 44;
    }
    
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height- 50;
    }
    
    prescribeDrugsUsageTableView = [[UITableView alloc]init];
    [self.view addSubview:prescribeDrugsUsageTableView];
    [prescribeDrugsUsageTableView setDataSource:self];
    [prescribeDrugsUsageTableView setDelegate:self];
    [prescribeDrugsUsageTableView.layer setCornerRadius:5.0f];
    [prescribeDrugsUsageTableView.layer setMasksToBounds:YES];
    
    [prescribeDrugsUsageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(tableheight);
    }];
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
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
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"DrugsUsageListTask"])
    {
        drugsItem = [[NSMutableArray alloc] init];
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTemp in taskResult)
            {
                DrugsUsagesInfo* drug = [DrugsUsagesInfo mj_objectWithKeyValues:dicTemp];
                [drugsItem addObject:drug];
            }
            [self createPrescribeDrugsUsageTableView];
        }

    }
    if ([taskname isEqualToString:@"DrugsFrequencyListTask"])
    {
        drugsItem = [[NSMutableArray alloc] init];
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTemp in taskResult)
            {
                DrugsFrequencyInfo* drug = [DrugsFrequencyInfo mj_objectWithKeyValues:dicTemp];
                [drugsItem addObject:drug];
            }
            [self createPrescribeDrugsUsageTableView];
        }
    }
}

@end
