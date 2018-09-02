//
//  IMMessageTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+MsgManager.h"
#import "MessageBaseModel+CellSize.h"
@protocol IMMessageTableViewCellDelegate;


@interface IMMessageTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, weak) id<IMMessageTableViewCellDelegate> delegate;

- (void) setMessage:(MessageBaseModel*) message;

// 配置发送者信息
- (void)configSenderInfo:(UserProfileModel *)senderProfile;
@end

@interface IMBubbleMessageTableViewCell : IMMessageTableViewCell
{
    UILabel* lbSendTime;
    UIImageView* ivPortrait;
    UILabel* lbSenderName;
    
    UIControl* msgview;
    UIImageView* ivBubble;
}

- (CGRect) bubbleFrame;
@end

@interface IMCardMessageTableViewCell : IMMessageTableViewCell

@end


@protocol IMMessageTableViewCellDelegate <NSObject>

- (void) imMessageCellClicked:(IMMessageTableViewCell*) clickedcell;

@end