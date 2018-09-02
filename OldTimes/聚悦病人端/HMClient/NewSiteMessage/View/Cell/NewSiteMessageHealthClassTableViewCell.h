//
//  NewSiteMessageHealthClassTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/2/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 健康课堂cell

#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageHealthClassTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
