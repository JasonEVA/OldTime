//
//  RelationListTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  好友列表页cell

#import "BaseSelectTableViewCell.h"

@class MessageRelationInfoModel;
typedef void(^addOrConnectBlock)(BOOL isAdded);

typedef NS_ENUM(NSInteger,RelationListTableViewCellType) {
    CellType_Define = 0, // 默认是 好友列表页cell(只有头像,昵称)
    CellType_userinfo_phone // 包含电话号码
};

@interface RelationListTableViewCell : BaseSelectTableViewCell

@property(nonatomic, assign) BOOL  showAddBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(RelationListTableViewCellType)type;

- (void)setCellDate:(MessageRelationInfoModel *)model;

- (void)isAdded:(BOOL)isAdd;

- (void)addOrConnectedwithBlock:(addOrConnectBlock)block;

@end
