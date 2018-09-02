//
//  NewSiteSystemTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/6/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//  站内信系统消息样式cell

#import <UIKit/UIKit.h>
#import "SiteMessageLastMsgModel.h"

@interface NewSiteSystemTableViewCell : UITableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
@end
