//
//  AddBankSelectBankViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddBankSelectBankViewController.h"

@interface AddBankSelectBankViewController ()<TaskObserver,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *BankNameItems;
    UITableView* BankNameTableView;
}
@end

@implementation AddBankSelectBankViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetBankListTask" taskParam:nil TaskObserver:self];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

+ (AddBankSelectBankViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                         selectblock:(BankSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    AddBankSelectBankViewController* vcBankName = [[AddBankSelectBankViewController alloc]initWithNibName:nil bundle:nil];
    [parentviewcontroller addChildViewController:vcBankName];
    [vcBankName.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vcBankName.view];
    
    [vcBankName setSelectblock:block];
    
    return vcBankName;
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
    if (BankNameItems)
    {
        return BankNameItems.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TestPeriodCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestPeriodCell"];
    }
    
    NSString *bankName = [[BankNameItems objectAtIndex:indexPath.row] valueForKey:@"bankName"];
    
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",bankName]];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDic = [BankNameItems objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(tempDic);
    }
    
    [self closeTestTimeView];
    
}
- (void) createBankNameTableView
{
    if (!BankNameItems)
    {
        return;
    }
    /*float tableheight = BankNameItems.count * 44;
     if (tableheight > self.view.height - 50)
     {
     tableheight = self.view.height- 50;
     }*/
    
    BankNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth-40, self.view.height-200)];
    [self.view addSubview:BankNameTableView];
    [BankNameTableView setDataSource:self];
    [BankNameTableView setDelegate:self];
    [BankNameTableView.layer setCornerRadius:5.0f];
    [BankNameTableView.layer setMasksToBounds:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
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
    
    if ([taskname isEqualToString:@"GetBankListTask"])
    {
        BankNameItems = (NSArray *)taskResult;
        [self createBankNameTableView];
    }
}

@end
