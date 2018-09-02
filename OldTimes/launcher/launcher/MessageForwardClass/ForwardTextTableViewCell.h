//
//  ForwardTextTableViewCell.h
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  转发文字Cell

#import "ForwardBaseTableViewCell.h"

@interface ForwardTextTableViewCell : ForwardBaseTableViewCell

+ (CGFloat)heightForMessage:(NSString *)message;

@end
