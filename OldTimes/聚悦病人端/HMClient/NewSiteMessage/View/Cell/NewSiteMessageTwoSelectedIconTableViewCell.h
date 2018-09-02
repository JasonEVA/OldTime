//
//  NewSiteMessageTwoSelectedIconTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//  第二版站内信 底部两个选框cell

#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

typedef void(^ButtonClick)(NSInteger tag);
@interface NewSiteMessageTwoSelectedIconTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)btnClick:(ButtonClick)block;
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
@end
