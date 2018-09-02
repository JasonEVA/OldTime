//
//  CalendarTextFieldTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建📅textfield cell

#import <UIKit/UIKit.h>

@interface CalendarTextFieldTableViewCell : UITableViewCell

@property (nonatomic, readonly) NSString *cellText;

+ (NSString *)identifier;

- (void)setTitle:(NSString *)titile;

- (void)textEndEditingBlock:(void (^)(NSString *))textBlock;

@end
