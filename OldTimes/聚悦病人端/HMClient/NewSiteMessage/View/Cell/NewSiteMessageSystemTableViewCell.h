//
//  NewSiteMessageSystemTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  新版站内信系统消息cell

#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageSystemTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
@end
