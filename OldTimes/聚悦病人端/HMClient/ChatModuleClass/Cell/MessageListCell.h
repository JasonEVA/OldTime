//
//  MessageListCell.h
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactDetailModel;

//@interface MessageListCell : SWTableViewCell
@interface MessageListCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

// 设置单元格内容
- (void)setModel:(ContactDetailModel *)model;

@end
