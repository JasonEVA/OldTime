//
//  AddBankSelectBankViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BankSelectBlock)(NSDictionary* BankItem);

@interface AddBankSelectBankViewController : UIViewController

@property (nonatomic, copy) void(^testTimeBlock)(NSDictionary* testPeriodItem);


+ (AddBankSelectBankViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                         selectblock:(BankSelectBlock)block;
@property (nonatomic, copy) BankSelectBlock selectblock;

@end
