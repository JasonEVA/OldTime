//
//  SESiteMessageNoticeTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第二版站内信公告cell

#import <UIKit/UIKit.h>
@class SiteMessageLastMsgModel;
@interface SESiteMessageNoticeTableViewCell : UITableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
@end
