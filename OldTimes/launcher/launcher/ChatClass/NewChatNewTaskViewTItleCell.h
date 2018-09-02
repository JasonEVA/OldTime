//
//  NewChatNewTaskViewTItleCell.h
//  launcher
//
//  Created by Dee on 16/7/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^getTitleTextCallBack)(NSString *title);

@interface NewChatNewTaskViewTItleCell :UITableViewCell

+ (NSString *)identifier;

- (void)setTitle:(NSString *)title;

- (void)getTextWithBlock:(getTitleTextCallBack)block;

- (void)setEndEditing;

@end
