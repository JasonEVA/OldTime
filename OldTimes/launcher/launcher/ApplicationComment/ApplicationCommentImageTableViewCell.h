//
//  ApplicationCommentImageTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用评论图片Cell

#import <UIKit/UIKit.h>

@class ApplicationCommentModel;

@interface ApplicationCommentImageTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)dataWithModel:(ApplicationCommentModel *)model;

- (void)clickToSee:(void(^)(id))clickBlock;

@end
