//
//  CoordinationContactsAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  联系人adapter

#import "ATTableViewAdapter.h"

typedef NS_ENUM(NSUInteger, ContactsSelectType) {
    ContactsSelectTypeNone, // 不可选
    ContactsSelectTypeSingleSelect, // 单选
    ContactsSelectTypeMutableSelect, // 多选包含全选
    ContactsSelectTypeMutableSelectWithoutSelectAll, // 多选不包含全选

};

@protocol CoordinationContactsAdapterDelegate <NSObject>

@optional
- (void)coordinationContactsAdapterDelegateCallBack_headerLongPressed;

- (void)coordinationContactsAdapterDelegateCallBack_clickedWithCellData:(id)cellData;
- (void)coordinationContactsAdapterDelegateCallBack_selectContact:(NSArray *)selectedContacts selectState:(BOOL)selectState;
@end

@interface CoordinationContactsAdapter : ATTableViewAdapter
@property (nonatomic, weak)  id<CoordinationContactsAdapterDelegate>  customeDelegate; // <##>
@property (nonatomic)  BOOL  onlyRelations; // 是否只是好友不包含群组

- (instancetype)initWithSelectType:(ContactsSelectType)selectType selectedContacts:(NSArray *)selectedContacts nonSelectableContacts:(NSArray *)nonSelectableContacts NS_DESIGNATED_INITIALIZER;

- (void)configSelectContacts:(NSArray *)selectContacts reload:(BOOL)reload;

@end
