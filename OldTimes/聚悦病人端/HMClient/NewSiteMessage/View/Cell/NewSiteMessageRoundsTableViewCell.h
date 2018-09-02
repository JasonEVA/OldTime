//
//  NewSiteMessageRoundsTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信查房cell（红包形式）

#import <UIKit/UIKit.h>
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageRoundsTableViewCell : UITableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;

@end
