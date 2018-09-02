//
//  ContactGroupingManagementViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  分组管理界面

#import "HMBaseViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@protocol ContactGroupingManagementViewControllerDelegate <NSObject>

- (void)ContactGroupingManagementViewControllerDelegateCallBack_selectModel:(MessageRelationGroupModel *)model;

@end

@interface ContactGroupingManagementViewController : HMBaseViewController
@property (nonatomic, copy)  NSArray  *arrayData; // <##>
@property (nonatomic)  BOOL  managementStatus; // <##>
@property (nonatomic, weak) id<ContactGroupingManagementViewControllerDelegate> delegate;
@property (nonatomic, strong) MessageRelationGroupModel *selectModel;
@end
