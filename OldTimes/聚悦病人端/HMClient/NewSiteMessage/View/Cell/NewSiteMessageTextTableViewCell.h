//
//  NewSiteMessageTextTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//   第二版站内信纯文本cell
#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageTextTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
