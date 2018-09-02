//
//  WithdrawSelectBankViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WithdrawSelectBankViewController.h"
#import "BillWithdrawDetailTableViewCell.h"

@interface WithdrawSelectBankViewController ()<TaskObserver,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* BankNameTableView;

    NSMutableArray *bankCardList;

}
@end

@implementation WithdrawSelectBankViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BankCardListTask" taskParam:dicPost TaskObserver:self];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

+ (WithdrawSelectBankViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                         selectblock:(BankSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    WithdrawSelectBankViewController* vcBankName = [[WithdrawSelectBankViewController alloc]initWithNibName:nil bundle:nil];
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
    if (bankCardList)
    {
        return bankCardList.count;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    BankCardInfo *bandCardInfo = [bankCardList objectAtIndex:indexPath.row];
    
    BillWithdrawBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillWithdrawBankCardTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillWithdrawBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillWithdrawBankCardTableViewCell"];
    }
    [cell.ivRightArrow setHidden:YES];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setBankCardInfo:bandCardInfo];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *tempDic = [bankCardList objectAtIndex:indexPath.row];
    BankCardInfo *bandCardInfo = [bankCardList objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(bandCardInfo);
    }
    
    [self closeTestTimeView];
    
}
- (void) createBankNameTableView
{
    if (!bankCardList)
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
    [self.view closeWaitView];
    if (StepError_None != taskError) {
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
    
    if ([taskname isEqualToString:@"BankCardListTask"])
    {
        //NSLog(@"%@",taskResult);
        bankCardList = [[NSMutableArray alloc] init];
        
        if ([taskResult isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dicBankCard in taskResult)
            {
                BankCardInfo* bankCardInfo = [BankCardInfo mj_objectWithKeyValues:dicBankCard];
                [bankCardList addObject:bankCardInfo];
            }
        }

        if (bankCardList.count == 0)
        {
            [self.view removeFromSuperview];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有绑定银行卡" delegate:nil cancelButtonTitle:@"去绑定" otherButtonTitles:nil, nil];
            [alert setDelegate:self];
            [alert show];
        }else
        {
            [self createBankNameTableView];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [HMViewControllerManager createViewControllerWithControllerName:@"AddBankCardViewController" ControllerObject:nil];
}

@end
