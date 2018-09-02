//
//  ChatRelationLeftTableViewCell.h
//  launcher
//
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  聊天好友分组cell

#import <UIKit/UIKit.h>
typedef void(^headViewClick)();

@class MessageRelationValidateModel;

@protocol ChatRelationLeftTableViewCellDelegate <NSObject>

- (void)ChatRelationLeftTableViewCell_SelectPassButtonWithCellPath:(NSIndexPath *)path;
- (void)ChatRelationLeftTableViewCell_SelectRefusedButtonWithCellPath:(NSIndexPath *)path;

@end

@interface ChatRelationLeftTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,assign) id<ChatRelationLeftTableViewCellDelegate> deleagte;


+ (NSString *)identifier;
- (void)setCellDate:(MessageRelationValidateModel *)model;
- (void)headViewClickBloc:(headViewClick)block;
@end
