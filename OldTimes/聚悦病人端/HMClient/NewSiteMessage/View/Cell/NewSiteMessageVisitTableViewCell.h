//
//  NewSiteMessageVisitTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版随访cell（有个小人）

#import "NewSiteMessageBubbleBaseTableViewCell.h"
@class SiteMessageLastMsgModel;

@interface NewSiteMessageVisitTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
