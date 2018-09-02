//
//  SenderApplyViewController.h
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  自己发送申请界面

#import "BaseViewController.h"
#import "ApplyGetSendListModel.h"

@interface ApplySenderViewController : BaseViewController

@property(nonatomic, strong) UILabel  *countLbl;

- (void)refreshData;

@end
