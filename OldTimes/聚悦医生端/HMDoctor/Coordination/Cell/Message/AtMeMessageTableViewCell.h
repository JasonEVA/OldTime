//
//  AtMeMessageTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/12/7.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBaseModel;

@interface AtMeMessageTableViewCell : UITableViewCell

+ (NSString *)identifer;
+ (CGFloat)height;

- (void)setDataWithModel:(MessageBaseModel *)model;

@end
