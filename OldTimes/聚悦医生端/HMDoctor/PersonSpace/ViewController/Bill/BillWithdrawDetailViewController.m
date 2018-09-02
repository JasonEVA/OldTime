//
//  BillWithdrawDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillWithdrawDetailViewController.h"
#import "BillWithdrawDetailTableViewCell.h"
#import "WithdrawSelectBankViewController.h"

typedef enum : NSInteger{
    
    BillWithdrawBalanceSection,
    BillWithdrawBankCardSection,
    BillWithdrawAmountSection,
    BillWithdrawConfirmSection,
    BillWithdrawDetailSectionCount,

}BillWithdrawDetail;

@interface BillWithdrawDetailViewController ()
{
    BillWithdrawDetailTableViewController *tvcBillWithdrawDetail;
}
@end

@implementation BillWithdrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"余额转出"];
    
    /*UIButton* WithdrawalShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [WithdrawalShowBtn setTitle:@"提现说明" forState:UIControlStateNormal];
    [WithdrawalShowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [WithdrawalShowBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [WithdrawalShowBtn addTarget:self action:@selector(WithdrawalShowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* BBWithdrawalShow = [[UIBarButtonItem alloc]initWithCustomView:WithdrawalShowBtn];
    [self.navigationItem setRightBarButtonItem:BBWithdrawalShow];*/
    
    tvcBillWithdrawDetail = [[BillWithdrawDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcBillWithdrawDetail];
    [self.view addSubview:tvcBillWithdrawDetail.tableView];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        NSString* str = (NSString *)self.paramObject;
        tvcBillWithdrawDetail.accountSum = str.doubleValue;
    }
    
    [tvcBillWithdrawDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface BillWithdrawDetailTableViewController ()<TaskObserver>
{
    NSString *bankCardId;
}
@end

@implementation BillWithdrawDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setScrollEnabled:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return BillWithdrawDetailSectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case BillWithdrawBalanceSection:
        case BillWithdrawAmountSection:
        case BillWithdrawConfirmSection:
            return 47;
            break;
            
        case BillWithdrawBankCardSection:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == BillWithdrawConfirmSection) {
        return 30;
    }else
    {
        return 15;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
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
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case BillWithdrawBalanceSection:
        {
            cell = [self setBillWithdrawDetailTableCell];
        }
            break;
            
        case BillWithdrawBankCardSection:
        {
            cell = [self setBillWithdrawBankCardTableCell];
        }
            break;
            
        case BillWithdrawAmountSection:
        {
            cell = [self setBillWithdrawMoneyTableCell];
        }
            break;
            
        case BillWithdrawConfirmSection:
        {
            cell = [self setBillWithdrawConfirmTableCell];
        }
            break;
            
            
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BillWithdrawDetailTableViewCell *) setBillWithdrawDetailTableCell
{
    BillWithdrawDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillWithdrawDetailTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillWithdrawDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillWithdrawDetailTableViewCell"];
    }
    [cell.lbAmount setText:[NSString stringWithFormat:@"￥%.2f",_accountSum]];
    return cell;
}

- (BillWithdrawBankCardTableViewCell *) setBillWithdrawBankCardTableCell
{
    BillWithdrawBankCardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillWithdrawBankCardTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillWithdrawBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillWithdrawBankCardTableViewCell"];
    }
    
    return cell;
}

- (BillWithdrawMoneyTableViewCell *) setBillWithdrawMoneyTableCell
{
    BillWithdrawMoneyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillWithdrawMoneyTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillWithdrawMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillWithdrawMoneyTableViewCell"];
    }
    
    return cell;
}


- (BillWithdrawConfirmTableViewCell *) setBillWithdrawConfirmTableCell
{
    BillWithdrawConfirmTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillWithdrawConfirmTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillWithdrawConfirmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillWithdrawConfirmTableViewCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //键盘下落
    [self.view endEditing:YES];
    
    switch (indexPath.section)
    {
        //选择提现银行卡
        case BillWithdrawBankCardSection:
        {
            BillWithdrawBankCardTableViewCell *cell = (BillWithdrawBankCardTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:BillWithdrawBankCardSection]];
          
            [WithdrawSelectBankViewController createWithParentViewController:self selectblock:^(BankCardInfo *BankItem) {
                
                [cell setBankCardInfo:BankItem];
                bankCardId = BankItem.bankCardId;
            }];
        }
            break;
        
        //确定提现
        case BillWithdrawConfirmSection:
        {
            BillWithdrawMoneyTableViewCell *cell = (BillWithdrawMoneyTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:BillWithdrawAmountSection]];
            
            //BillWithdrawDetailTableViewCell *amountCell = (BillWithdrawDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:BillWithdrawBalanceSection]];
            
            if (!bankCardId) {
                [self.tableView.superview showAlertMessage:@"您还没选择提现银行卡"];
                return;
            }
            
            NSString *money = cell.tfMoney.text;

            if (!money || money.length <= 0) {
                [self.tableView.superview showAlertMessage:@"请输入提现金额"];
                return;
            }
            
            if (money.floatValue > _accountSum) {
                [self.tableView.superview showAlertMessage:@"提现金额不可超过账户余额！"];
                return;
            }
            
            if (money.floatValue < 100)
            {
                [self showAlertMessage:@"最低提现金额100元"];
                return;
            }
            
            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            [dicPost setValue:bankCardId forKey:@"bankCardId"];
            
            [dicPost setValue:@"4" forKey:@"type"];
            
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            if (curStaff)
            {
                [dicPost setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"objId"];
            }
            
            [dicPost setValue:money forKey:@"money"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"WithdrawTask" taskParam:dicPost TaskObserver:self];
            
        }
            break;
            
        default:
            break;
    }
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
    
    if ([taskname isEqualToString:@"WithdrawTask"])
    {
        //NSLog(@"%@",taskResult);
        [self.navigationController popViewControllerAnimated:YES];
        [self.view showAlertMessage:@"提现成功，我们将在72小时内转账到您的银行卡账户！"];
    }
}

@end
