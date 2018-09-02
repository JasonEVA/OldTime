//
//  PersonServiceComPlainContentTableViewCell.h
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
// 含有一个文本框的cell

#import <UIKit/UIKit.h>

typedef void(^getContentCallBackBlock)(NSString *content);

@interface PersonServiceComPlainContentTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)getContentWithBlock:(getContentCallBackBlock)block;

@end
