//
//  LoginAccountTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 17/3/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginAccount.h"

@interface LoginAccountTableViewCell : UITableViewCell

- (void) setLoginAccountModel:(LoginAccountModel*) model;

- (void) showAccountLogined:(BOOL) logined;
@end
