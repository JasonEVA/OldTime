//
//  NewSiteMessageMedicationRemindTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用药提醒cell

#import "NewSiteMessageItemBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageMedicationRemindTableViewCell : NewSiteMessageItemBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
