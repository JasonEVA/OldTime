//
//  BankCardConfirmViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BankCardConfirmViewController.h"

@interface BankCardConfirmViewController ()<TaskObserver>
{
    UILabel *lbContent;
    UILabel *lbBank;
    UILabel *lbCardNum;
    UIButton *nextButton;
    
    NSDictionary *dicBankCardInfo;
}
@end

@implementation BankCardConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"确认卡号"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSDictionary class]])
    {
        dicBankCardInfo = (NSDictionary *)self.paramObject;
    }
    
    [self initWithSubViews];
}

- (void)initWithSubViews
{
    lbContent = [[UILabel alloc] init];
    [self.view addSubview:lbContent];
    [lbContent setText:@"请核对卡号信息，确认无误"];
    [lbContent setTextColor:[UIColor commonGrayTextColor]];
    [lbContent setFont:[UIFont systemFontOfSize:13]];
    
    lbBank = [[UILabel alloc] init];
    [self.view addSubview:lbBank];
    [lbBank setText:dicBankCardInfo[@"bankName"]];
    [lbBank setTextColor:[UIColor commonTextColor]];
    [lbBank setFont:[UIFont systemFontOfSize:15]];
    

    NSString *string = dicBankCardInfo[@"cardNum"];
    NSString *valueStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSInteger count = valueStr.integerValue/4;
    CGFloat width;
    if (valueStr.length%4 == 0)
    {
        count = 4;
        width = (kScreenWidth-55)/count;
    }else{
        count = 5;
        width = (kScreenWidth-65)/count;
    }
    
    for (int i = 0; i < count; i++)
    {
        NSString *cardNum;
        if (i == count-1 && valueStr.length%4 != 0)
        {
            cardNum = [valueStr substringWithRange:NSMakeRange(i*4,valueStr.length%4)];
        }else
        {
            cardNum = [valueStr substringWithRange:NSMakeRange(i*4,4)];
        }

        lbCardNum = [[UILabel alloc] init];
        [self.view addSubview:lbCardNum];
        [lbCardNum setText:cardNum];
        [lbCardNum setFont:[UIFont systemFontOfSize:17]];
        [lbCardNum setTextColor:[UIColor commonTextColor]];
        [lbCardNum setBackgroundColor:[UIColor whiteColor]];
        [lbCardNum setTextAlignment:NSTextAlignmentCenter];
        
        [lbCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.5+ i*(width+10));
            make.top.equalTo(lbBank.mas_bottom).with.offset(18);
            make.height.mas_equalTo(@32);
            make.width.mas_equalTo(width);
        }];
    }
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"确定添加" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor mainThemeColor]];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextButton.layer setCornerRadius:2.5];
    [nextButton.layer setMasksToBounds:YES];
    
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewsLayout];
}


- (void)subViewsLayout
{
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.mas_equalTo(@5);
        make.size.mas_equalTo(CGSizeMake(240, 20));
    }];
    
    [lbBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(lbContent.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(240, 20));
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(lbCardNum.mas_bottom).with.offset(50);
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(@45);
    }];
}

- (void)nextButtonClick
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
    
    [dicPost setValue:dicBankCardInfo[@"holder"] forKey:@"accountName"];
    
    [dicPost setValue:lbBank.text forKey:@"bankName"];
    [dicPost setValue:lbCardNum.text forKey:@"cardNo"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddBankCardTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
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
    
    if ([taskname isEqualToString:@"AddBankCardTask"])
    {
        [HMViewControllerManager createViewControllerWithControllerName:@"WithdrawalWayViewController" ControllerObject:nil];
    }
}

@end
