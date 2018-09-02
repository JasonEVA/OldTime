//
//  ContactBookTableView.h
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  通讯录搜索tableView

#import <UIKit/UIKit.h>
#import "ContactDefine.h"

@class ContactPersonDetailInformationModel, ContactDepartmentImformationModel;

@class BaseViewController;

typedef void(^ContactBookTableViewSelectContactBlock)(ContactPersonDetailInformationModel *);
/** 点击部门 */
typedef void(^ContactBookTableViewSelectDeptmentBlock)(ContactDepartmentImformationModel *selectedModel, NSArray *allDeptmentArray);
/** 部门选中☑️ */
typedef void(^ContactBoolTableViewSelectDeptmentSelectBlock)(ContactDepartmentImformationModel *selectedModel);


@interface ContactBookTableView : UIView
/** 部门和人员混合数组 */
@property(nonatomic, strong) NSMutableArray  *mixModelArr;

- (instancetype)initWithSuperViewController:(BaseViewController *)superViewController;
- (instancetype)initWithSuperViewController:(BaseViewController *)superViewController tabbar:(SelectContactTabbarView *)tabbar;

- (void)selectContact:(ContactBookTableViewSelectContactBlock)contactBlock;
/** 点击部门 */
- (void)selectDeptment:(ContactBookTableViewSelectDeptmentBlock)deptmentBlock;

- (void)reloadData;

- (void)startGetCompanyDeptRequest;
@end
