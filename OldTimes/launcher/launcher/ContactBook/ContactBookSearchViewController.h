//
//  ContactBookSearchViewController.h
//  launcher
//
//  Created by williamzhang on 15/10/15.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  自带搜索的通讯录界面

#import "BaseViewController.h"
#import "ContactPersonDetailInformationModel+UseForSelect.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import "ContactDefine.h"

@interface ContactBookSearchViewController : BaseViewController

- (void)clickToSearch;

@property (nonatomic, weak, readonly) SelectContactTabbarView *tabbar;

/**************** 选人模式  ******************/
/** 单选模式 */
@property (nonatomic, assign) BOOL singleSelectable;
/** 能否选择自己模式 */
@property (nonatomic, assign) BOOL selfSelectable;

/** 初始化时的数据 */
@property (nonatomic, readonly) NSArray *arrayOriginalSelected;
/** 初始化时的数据 */
@property (nonatomic, readonly) NSArray *arrayUnableSelected;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchVC;

/**
 *  选择人员初始化（无已选择人员直接使用init）
 *
 *  @param selectedPeople 已选择人员(ContactPersonInfomationModel)
 *
 *  @return return
 */
- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople;

/**
 *  选择人员初始化（无已选择人员直接使用init)
 *
 *  @param selectedPeople 已选择人员(ContactPersonInfomationModel)
 *  @param unableSelectPeople 不可选择人员（同上）
 *
 *  @return return
 */
- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople unableSelectPeople:(NSArray *)unableSelectPeople;

- (void)reloadData;

/**************** 选人模式  ******************/

@end
