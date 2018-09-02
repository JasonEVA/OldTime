//
//  WithdrawalWayViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WithdrawalWayViewController.h"
#import "WithdrawalWayTableViewCell.h"
#import "BankCardInfo.h"

@interface WithdrawalWayViewController ()
{
    WithdrawalWayTableViewController *tvcWithdrawalWay;
}

@end

@implementation WithdrawalWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"提现方式"];
    
    UIButton* WithdrawalShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [WithdrawalShowBtn setImage:[UIImage imageNamed:@"icon_home_add"] forState:UIControlStateNormal];
    [WithdrawalShowBtn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* BBWithdrawalShow = [[UIBarButtonItem alloc]initWithCustomView:WithdrawalShowBtn];
    [self.navigationItem setRightBarButtonItem:BBWithdrawalShow];
    
    tvcWithdrawalWay = [[WithdrawalWayTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcWithdrawalWay];
    [self.view addSubview:tvcWithdrawalWay.tableView];
    [tvcWithdrawalWay.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];

}
- (void)addBankCard
{
    [HMViewControllerManager createViewControllerWithControllerName:@"AddBankCardViewController" ControllerObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end



@interface WithdrawalWayTableViewController ()<TaskObserver>
{
    NSMutableArray *bankCardList;
}
@end

@implementation WithdrawalWayTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];

    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BankCardListTask" taskParam:dicPost TaskObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    //[self.tableView setScrollEnabled:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankCardList.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardInfo *bandCardInfo = [bankCardList objectAtIndex:indexPath.row];
    
    WithdrawalWayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WithdrawalWayTableViewCell"];
    if (!cell)
    {
        cell = [[WithdrawalWayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WithdrawalWayTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setBankCardInfo:bandCardInfo];
    
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
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
        
        [self.tableView reloadData];
    }
}

@end