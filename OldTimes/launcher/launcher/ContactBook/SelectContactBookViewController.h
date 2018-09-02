//
//  SelectContactBookViewController.h
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  新的选择人界面

#import "BaseViewController.h"

typedef enum : NSUInteger {
    /// 聊天无关时使用
    selectContact_none = 0,
    /// 创建群组
    selectContact_createGroup = 2,
    /// 单聊时创建群组
    selectContact_singleCreateGroup,
    /// 聊天时添加成员
    selectContact_addPeople,
} SelectContactType;

@interface SelectContactBookViewController : BaseViewController

- (void)selectedPeople:(void (^)(NSArray *))selectedPeopleBlock;

/** 单选模式 */
@property (nonatomic, assign) BOOL singleSelectable;
/** 能否选择自己模式 */
@property (nonatomic, assign) BOOL selfSelectable;
@property (nonatomic) BOOL isMission;
/**
 *  选择人员初始化（无已选择人员直接使用init）
 *
 *  @param selectedPeople 已选择人员(ContactPersonInfomationModel or 用户登录账号)
 *
 *  @return return
 */
- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople;

/**
 *  选择人员初始化（无已选择人员直接使用init)
 *
 *  @param selectedPeople 已选择人员(ContactPersonInfomationModel or 用户登录账号)
 *  @param unableSelectPeople 不可选择人员（同上）
 *
 *  @return return
 */
- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople unableSelectPeople:(NSArray *)unableSelectPeople;

// 创建群组
@property (nonatomic) SelectContactType selectType;     // 区分是群里加人或者创建群
@property (nonatomic, strong) NSString *groupID;        // 群ID
@property (nonatomic, copy) NSString *currentUserID;

@end
