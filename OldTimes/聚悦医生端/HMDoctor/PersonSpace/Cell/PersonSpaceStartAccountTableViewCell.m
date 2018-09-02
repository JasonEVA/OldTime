//
//  PersonSpaceStartAccountTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceStartAccountTableViewCell.h"

@interface PersonSpaceStartEstimateIncomeTotalView: UIView
{
    UILabel* lbAccount;
    UILabel* lbEstimate;
    UILabel* lbIncome;
    UIView* bottomLine;
}

- (void)setEstimateIncome:(double)income;

@end

@implementation PersonSpaceStartEstimateIncomeTotalView

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320 * kScreenScale, 30 * kScreenScale)];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbAccount = [[UILabel alloc]init];
        [self addSubview:lbAccount];
        [lbAccount setBackgroundColor:[UIColor clearColor]];
        [lbAccount setTextColor:[UIColor colorWithHexString:@"333333"]];
        [lbAccount setText:@"我的帐户"];
        [lbAccount setFont:[UIFont systemFontOfSize:14]];
        
        lbEstimate = [[UILabel alloc]init];
        [self addSubview:lbEstimate];
        [lbEstimate setBackgroundColor:[UIColor clearColor]];
        [lbEstimate setTextColor:[UIColor colorWithHexString:@"999999"]];
        [lbEstimate setText:@"待结算收益"];
        [lbEstimate setFont:[UIFont systemFontOfSize:12]];

        lbIncome = [[UILabel alloc]init];
        [self addSubview:lbIncome];
        [lbIncome setBackgroundColor:[UIColor clearColor]];
        [lbIncome setTextColor:[UIColor colorWithHexString:@"333333"]];
        [lbIncome setText:@"￥0.00"];
        [lbIncome setFont:[UIFont systemFontOfSize:12]];
       
        bottomLine = [[UIView alloc]init];
        [self addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewLayout];

    }
    return self;
}

- (void) subviewLayout
{
    [lbAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        //make.height.mas_equalTo
        make.left.equalTo(self).with.offset(10);
    }];
    
    [lbIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [lbEstimate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(lbIncome.mas_left).with.offset(-8);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.left.equalTo(self);
    }];
}

- (void)setEstimateIncome:(double)income
{
    [lbIncome setText:[NSString stringWithFormat:@"￥%.2f", income]];
}

@end

@interface PersonSpaceStartAccountBalanceView : UIView
{
    UILabel* lbBalanceTitle;
    UILabel* lbBalance;
    UIButton* withdrawbutton;
    
    NSString* balanceValue;
}

- (void) setBalance:(double) balance;
@end

@implementation PersonSpaceStartAccountBalanceView

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320 * kScreenScale, 42 * kScreenScale)];
    if (self)
    {
        lbBalanceTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 22)];
        [self addSubview:lbBalanceTitle];
        [lbBalanceTitle setBackgroundColor:[UIColor clearColor]];
        [lbBalanceTitle setFont:[UIFont systemFontOfSize:14]];
        [lbBalanceTitle setTextColor:[UIColor colorWithHexString:@"999999"]];
        [lbBalanceTitle setText:@"余额"];
    
        
        lbBalance = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 105, 22)];
        [self addSubview:lbBalance];
        [lbBalance setBackgroundColor:[UIColor clearColor]];
        [lbBalance setFont:[UIFont systemFontOfSize:20]];
        [lbBalance setTextColor:[UIColor colorWithHexString:@"E35102"]];
        [lbBalance setText:@"￥0.00"];
        
        withdrawbutton = [[UIButton alloc]init];
        [self addSubview:withdrawbutton];
        withdrawbutton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        withdrawbutton.layer.borderWidth = 0.5;
        withdrawbutton.layer.cornerRadius = 3;
        withdrawbutton.layer.masksToBounds = YES;
        
        [withdrawbutton setTitle:@"提现" forState:UIControlStateNormal];
        [withdrawbutton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [withdrawbutton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [withdrawbutton addTarget:self action:@selector(withdrawbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self showBottomLine];
        [self subviewLayout];
    }
    return self;
}

- (void)withdrawbuttonClick
{
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－提现"];
    if (!balanceValue || 100 > balanceValue.doubleValue) {
        [self showAlertMessage:@"余额不足100元，不能提现"];
        return;
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"BillWithdrawDetailViewController" ControllerObject:balanceValue];
}

- (void) setBalance:(double) balance
{
    [lbBalance setText:[NSString stringWithFormat:@"￥%.2f", balance]];
    balanceValue = [NSString stringWithFormat:@"%f",balance];
}

- (void) subviewLayout
{
    [lbBalanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(10);
    }];
    
    [lbBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(lbBalanceTitle.mas_right).with.offset(7);
    }];
    
    [withdrawbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(@(42*kScreenScale));
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}

@end

@interface PersonSpaceStartAccountOperateCell : UIControl
{
    UIImageView* ivIcon;
    UILabel* lbName;
}

- (void) setName:(NSString*) name
            Icon:(UIImage*) icon;
@end

@implementation PersonSpaceStartAccountOperateCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor colorWithHexString:@"666666"]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) setName:(NSString*) name
            Icon:(UIImage*) icon
{
    [lbName setText:name];
    [ivIcon setImage:icon];
}

- (void) subviewLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(56);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(self);
        make.left.equalTo(ivIcon.mas_right).with.offset(9);
    }];
}
@end

@interface PersonSpaceStartAccountOperateView : UIView
{
    //UILabel* lbIncome;
    PersonSpaceStartAccountOperateCell* accountCell;
    PersonSpaceStartAccountOperateCell* bankcardCell;
}
@end

@implementation PersonSpaceStartAccountOperateView

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320 * kScreenScale, 33 * kScreenScale)];
    if (self)
    {
        accountCell = [[PersonSpaceStartAccountOperateCell alloc]initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
        [self addSubview:accountCell];
        [accountCell setName:@"账单" Icon:[UIImage imageNamed:@"ic_account"]];
        [accountCell showRightLine];
        [accountCell addTarget:self action:@selector(enterBillInfoViewController) forControlEvents:UIControlEventTouchUpInside];
        
        bankcardCell = [[PersonSpaceStartAccountOperateCell alloc]initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
        [self addSubview:bankcardCell];
        [bankcardCell setName:@"银行卡" Icon:[UIImage imageNamed:@"ic_bankcard"]];
        [bankcardCell addTarget:self action:@selector(enterWithdrawalWayViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)enterBillInfoViewController
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－账单(账单明细)"];
    [HMViewControllerManager createViewControllerWithControllerName:@"BillInfoViewController" ControllerObject:nil];
}

- (void)enterWithdrawalWayViewController
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－银行卡(提现方式)"];
    [HMViewControllerManager createViewControllerWithControllerName:@"WithdrawalWayViewController" ControllerObject:nil];
}

@end

@interface PersonSpaceStartAccountTableViewCell ()
{
    PersonSpaceStartEstimateIncomeTotalView* estimateView;  //预计收益
    PersonSpaceStartAccountBalanceView* balanceview;        //余额
    PersonSpaceStartAccountOperateView* accountview;
}
@end

@implementation PersonSpaceStartAccountTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

//        
//        incomeview = [[PersonSpaceStartAccountIncomeView alloc]init];
//        [self.contentView addSubview:incomeview];
//        [incomeview setTop:balanceview.bottom];
        
        estimateView = [[PersonSpaceStartEstimateIncomeTotalView alloc]init];
        [self.contentView addSubview:estimateView];
        
        balanceview = [[PersonSpaceStartAccountBalanceView alloc]init];
        [self.contentView addSubview:balanceview];
        balanceview.top = estimateView.bottom;
        
        StaffInfo* staff = [UserInfoHelper defaultHelper].currentStaffInfo;
        [balanceview setBalance:staff.moneyBag.floatValue];
        
        accountview = [[PersonSpaceStartAccountOperateView alloc]init];
        [self.contentView addSubview:accountview];
        accountview.top = balanceview.bottom;
    }
    return self;
}

- (void) setAccount:(double)accountSum EstimatedIncome:(double)income
{
    if (accountSum)
    {
        [balanceview setBalance:accountSum];
    }
    [estimateView setEstimateIncome:income];
}

@end
