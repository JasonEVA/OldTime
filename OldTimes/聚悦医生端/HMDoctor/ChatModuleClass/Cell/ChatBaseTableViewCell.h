//
//  ChatBaseTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/12/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天最底层Cell

#import "BaseSelectTableViewCell.h"
#import "ChatBubbleConfig.h"
#import "MenuImageView.h"

@class ChatBaseTableViewCell;
@class MenuImageView;

@protocol ChatBaseTableViewCellDelegate <NSObject>

@optional

- (BOOL)chatBaseTableViewCellIsEdtingMode:(ChatBaseTableViewCell *)cell;
- (BOOL)chatBaseTableViewCellCanBecomeFirstResponder:(ChatBaseTableViewCell *)cell menuImageView:(MenuImageView *)menuImageView;

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToEmphasisAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCancelEmphasisAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCopyAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToRecallAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToScheduleAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMissionAtIndexPath:(NSIndexPath *)indexPath;

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToForwardAtIndexPath:(NSIndexPath *)indexPath;

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMoreAtIndexPath:(NSIndexPath *)indexPath;

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell pressHeadAtIndexPath:(NSIndexPath *)indexPath;
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell longPressHeadAtIndexPath:(NSIndexPath *)indePath;

@end

@interface ChatBaseTableViewCell : BaseSelectTableViewCell <MenuImageViewDelegate>

@property (nonatomic, weak) id<ChatBaseTableViewCellDelegate> delegate;
/// 气泡
@property (nonatomic, strong) MenuImageView *imgViewBubble;

@property (nonatomic, assign) BOOL isSelectedImportant;

@property (nonatomic, assign)  long long  cellMsgID; // <##>

+ (NSString *)identifier;
+ (CGFloat)heightForShowUserNickName:(BOOL)show;

- (NSIndexPath *)getIndexPath;

@end
