//
//  CoordinationContactsSelectAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  联系人选择adapter

#import "ATTableViewAdapter.h"

typedef NS_ENUM(NSUInteger, ContactsSelectType) {
    ContactsSelectTypeNone, // 不可选
    ContactsSelectTypeSingleSelect, // 单选
    ContactsSelectTypeMutableSelect, // 多选包含全选
    ContactsSelectTypeMutableSelectWithoutSelectAll, // 多选不包含全选
    
};

@protocol CoordinationContactsSelectAdapterDelegate <NSObject>

- (void)coordinationContactsSelectAdapterDelegateCallBack_sectionSelectStateChangedWithChangedContacts:(NSArray *)changedContacts;

@end

@interface CoordinationContactsSelectAdapter : ATTableViewAdapter

@property (nonatomic, strong) NSMutableArray<NSString *>    *sectionData; // <##>
@property (nonatomic, weak)  id<CoordinationContactsSelectAdapterDelegate>  customDelegate; //

@property (nonatomic, strong)  NSMutableArray  *arraySelectedContacts; // 已选的人，可以修改

/**
 *  选人数据初始化
 *
 *  @param selectType            选人类型
 *  @param selectedContacts      已选人员，可以修改
 *  @param nonSelectableContacts 不可选人员，不可修改
 *
 *  @return 
 */
- (instancetype)initWithSelectType:(ContactsSelectType)selectType selectedContacts:(NSArray *)selectedContacts nonSelectableContacts:(NSArray *)nonSelectableContacts NS_DESIGNATED_INITIALIZER;

- (void)configDataSource:(NSArray *)dataSource;

// 取消选中对象
- (void)deselectDataObject:(id)model;
@end
