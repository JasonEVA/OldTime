//
//  AccountManageTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 17/3/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAccount.h"

@interface AccountManageTableViewCell : UITableViewCell

- (void) setLoginAccountModel:(LoginAccountModel*) model;

- (void) showAccountLogined:(BOOL) logined;

@end

@interface AccountManageAppendTableViewCell : UITableViewCell

@end
