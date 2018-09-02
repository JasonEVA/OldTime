//
//  CalendarButtonsTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  会议、事件 编辑、删除Cell

#import <UIKit/UIKit.h>

@interface CalendarButtonsTableViewCell : UITableViewCell

+ (NSString *)identifier;
- (void)clickedButton:(void(^)(NSInteger index)) clickAtIndexBlock;

@end
