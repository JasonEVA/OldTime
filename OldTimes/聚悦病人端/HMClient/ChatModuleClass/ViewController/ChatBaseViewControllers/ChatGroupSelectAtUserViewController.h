//
//  ChatGroupSelectAtUserViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群组选择@人员选择界面

#import "HMBaseNavigationViewController.h"

@class ContactInfoModel;

@interface ChatGroupSelectAtUserNavigationViewController : HMBaseNavigationViewController

/** 传入群ID */
- (instancetype)initWithGroupID:(NSString *)groupID;

- (void)selectedPeople:(void (^)(ContactInfoModel *selectModel))selectedBlock;

@end
