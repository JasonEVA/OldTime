//
//  BillWithdrawDetailTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardInfo.h"

@interface BillWithdrawDetailTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *lbAmount;  

@end

@interface BillWithdrawBankCardTableViewCell : UITableViewCell

@property(nonatomic, retain) UIImageView *ivRightArrow;
- (void)setBankCardInfo:(BankCardInfo *)bankCard;

@end

@interface BillWithdrawMoneyTableViewCell : UITableViewCell
@property (nonatomic, retain) UITextField *tfMoney;
@end

@interface BillWithdrawConfirmTableViewCell : UITableViewCell

@end