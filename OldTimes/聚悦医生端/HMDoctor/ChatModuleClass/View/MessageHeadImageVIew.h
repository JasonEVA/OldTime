//
//  MessageHeadImageVIew.h
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  曼信列表单元格头部ImageView

#import <UIKit/UIKit.h>

@class ContactDetailModel;

@interface MessageHeadImageVIew : UIView

/// 设置应用app图片角标
- (void)setImage:(UIImage *)image InfoCount:(NSInteger)count;
/// 设置聊天头像角标
- (void)setImageWithContactModel:(ContactDetailModel *)model;
- (void)setImage:(UIImage *)image imgUrlstring:(NSString *)imgurlstr InfoCount:(NSInteger)count;
@end
