//
//  ContactBookDeptmentViewController.h
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  部门显示界面

#import "BaseViewController.h"
#import "ContactDefine.h"

@class ContactDepartmentImformationModel, ContactPersonDetailInformationModel;

typedef void(^ContactDepartmentSelectContactBlock)(ContactPersonDetailInformationModel *);

@interface ContactBookDeptmentViewController : BaseViewController

/**
 *  正常显示部门
 *
 *  @param currenModel    当前部门
 *  @param deptmentsArray 所有部门
 *
 *  @return 0.0
 */
- (instancetype)initWithCurrentDeptment:(ContactDepartmentImformationModel *)currenModel;

/**
 *  搜索部门
 *
 *  @param currenModel    当前部门
 *  @param deptmentsArray 所有部门
 *  @param tabbar         底部选择栏（nil时则为不是搜索状态）
 *
 *  @return 0.0
 */
- (instancetype)initWithCurrentDeptment:(ContactDepartmentImformationModel *)currenModel tabbar:(SelectContactTabbarView *)tabbar;

/** 选择部门☑️ */
- (void)reloadData:(void (^)())reloadBlock;

@end
