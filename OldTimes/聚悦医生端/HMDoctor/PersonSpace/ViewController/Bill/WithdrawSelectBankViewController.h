//
//  WithdrawSelectBankViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "BankCardInfo.h"

typedef void(^BankSelectBlock)(BankCardInfo* BankItem);

@interface WithdrawSelectBankViewController : UIViewController

@property (nonatomic, copy) void(^testTimeBlock)(NSDictionary* testPeriodItem);


+ (WithdrawSelectBankViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                 selectblock:(BankSelectBlock)block;
@property (nonatomic, copy) BankSelectBlock selectblock;

@end