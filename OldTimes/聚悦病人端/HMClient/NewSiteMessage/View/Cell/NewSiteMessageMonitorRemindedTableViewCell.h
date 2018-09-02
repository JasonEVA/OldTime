//
//  NewSiteMessageMonitorRemindedTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信监测提醒cell

#import "NewSiteMessageItemBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageMonitorRemindedTableViewCell : NewSiteMessageItemBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
