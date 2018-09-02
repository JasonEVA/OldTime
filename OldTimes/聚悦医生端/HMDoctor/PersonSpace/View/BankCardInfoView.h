//
//  BankCardInfoView.h
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardInfoView : UIView

@end

@interface BankCardholderView : UIView

@property (nonatomic, retain) UITextField *tfCardName;
@property (nonatomic, retain) UIButton *iconButton;

@end

@interface BankCardNumView : UIView

@property (nonatomic, retain) UITextField *tfCardNum;

@end

@interface BankNameControl : UIControl

@property (nonatomic, retain) UILabel *lbBankName;

@end