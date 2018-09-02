//
//  WithdrawalWayTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardInfo.h"

@interface WithdrawalWayTableViewCell : UITableViewCell

- (void)setBankCardInfo:(BankCardInfo *)bankCard;
@property(nonatomic, retain)UILabel *lbBankType;

@end
