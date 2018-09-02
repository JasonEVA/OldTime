//
//  HMSomeOneMessageHistoryTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//  某群成员所有聊天记录cell

#import <UIKit/UIKit.h>

@class MessageBaseModel;
@class UserProfileModel;

@interface HMSomeOneMessageHistoryTableViewCell : UITableViewCell
- (void)fillDataWithMessageModel:(MessageBaseModel *)model profileModel:(UserProfileModel *)profileModel;

@end
