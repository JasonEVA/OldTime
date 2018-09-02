//
//  HMSelectGroupsViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//  选择群组vc（只选群）

#import "HMBaseViewController.h"
@class NewPatientGroupListInfoModel;

typedef void(^GroupsSelectedBlock)(NSArray<NewPatientGroupListInfoModel *> *selectedPatients);

@interface HMSelectGroupsViewController : HMBaseViewController

- (instancetype)initWithSelectedGroups:(NSArray *)selectedGroup;
//确定选择回调block方法
- (void)getSelectedGroup:(GroupsSelectedBlock)block;

@end
