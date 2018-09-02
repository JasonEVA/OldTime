//
//  ChatGroupSelectAtUserViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群组选择@人员选择界面

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@class ContactPersonDetailInformationModel;

@interface ChatGroupSelectAtUserNavigationViewController : BaseNavigationController

/** 传入群ID */
- (instancetype)initWithGroupID:(NSString *)groupID;

- (void)selectedPeople:(void (^)(ContactPersonDetailInformationModel *selectModel))selectedBlock;
/**
 *  传入评论可以@的人员数组
 */
- (instancetype)initWithCanSelectedMembers:(NSArray *)members;
@end
