//
//  AddBankCardViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BankCardInfoView.h"
#import "AddBankSelectBankViewController.h"

@interface AddBankCardViewController ()
{
    UILabel *lbBind;
    BankCardholderView *holderView;
    BankCardNumView *cardNumView;
    BankNameControl *bankNameControl;
    UILabel *lbExplain;
    UIButton *nextButton;
}
@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加银行卡"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self initWithSubViews];
}

- (void)initWithSubViews
{
    lbBind = [[UILabel alloc] init];
    [self.view addSubview:lbBind];
    [lbBind setText:@"请绑定持卡人本人的银行卡"];
    [lbBind setTextColor:[UIColor commonGrayTextColor]];
    [lbBind setFont:[UIFont systemFontOfSize:13]];

    holderView = [[BankCardholderView alloc] init];
    [self.view addSubview:holderView];
    [holderView.iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    cardNumView = [[BankCardNumView alloc] init];
    [self.view addSubview:cardNumView];

    bankNameControl = [[BankNameControl alloc] init];
    [self.view addSubview:bankNameControl];
    [bankNameControl addTarget:self action:@selector(bankNameControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    lbExplain = [[UILabel alloc] init];
    [self.view addSubview:lbExplain];
    [lbExplain setText:@"我们使用智能加密，保障您的用卡安全"];
    [lbExplain setTextColor:[UIColor commonGrayTextColor]];
    [lbExplain setFont:[UIFont systemFontOfSize:13]];

    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor mainThemeColor]];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextButton.layer setCornerRadius:2.5];
    [nextButton.layer setMasksToBounds:YES];
    
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [self subViewsLayout];
}

- (void)iconButtonClick
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"持卡人说明" message:@"为保证账户资金安全，只能绑定您本人的银行卡" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    //[self.view showAlertMessage:@"为保证账户资金安全，只能绑定您本人的银行卡"];
}

- (void)bankNameControlClick
{
    [self.view endEditing:YES];
    
    [AddBankSelectBankViewController createWithParentViewController:self selectblock:^(NSDictionary *BankItem) {
        
        bankNameControl.lbBankName.text = BankItem[@"bankName"];
        
    }];
}

- (void)nextButtonClick
{
    NSString *bankholder = holderView.tfCardName.text;
    NSString *bankNum = cardNumView.tfCardNum.text;
    NSString *bankName = bankNameControl.lbBankName.text;
    
    if (!bankholder || bankholder.length <= 0)
    {
        [self.view showAlertMessage:@"持卡人姓名不能为空"];
        return;
    }
    
    if (!bankNum || bankNum.length <= 0)
    {
        [self.view showAlertMessage:@"卡号不能为空"];
        return;
    }
    
    NSString *valueStr = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isRight = [self checkCardNo:valueStr];
    
    if (!isRight) {
        [self.view showAlertMessage:@"卡号输入错误"];
        return;
    }
    
    /*if (bankNum.length < 16)
    {
        [self.view showAlertMessage:@"卡号输入错误"];
        return;
    }*/
    
    if (!bankName || [bankName isEqualToString:@"请选择银行"])
    {
        [self.view showAlertMessage:@"请选择银行"];
        return;
    }

    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setValue:bankholder forKey:@"holder"];
    [dicParam setValue:bankNum forKey:@"cardNum"];
    [dicParam setValue:bankName forKey:@"bankName"];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"BankCardConfirmViewController" ControllerObject:dicParam];
}

- (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

- (void)subViewsLayout
{
    [lbBind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(34);
    }];
    
    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbBind.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(47);
    }];
    
    [cardNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(47);
    }];
    
    [bankNameControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNumView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(47);
    }];
    
    [lbExplain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(bankNameControl.mas_bottom);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(lbExplain.mas_bottom);
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(@45);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

