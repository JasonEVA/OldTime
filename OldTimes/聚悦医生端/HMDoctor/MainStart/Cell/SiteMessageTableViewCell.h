//
//  SiteMessageTableViewCell.h
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信cell

#import <UIKit/UIKit.h>
@class SiteMessageModel;
@interface SiteMessageTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)setDataWithModel:(SiteMessageModel *)model;

@end
