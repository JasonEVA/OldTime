//
//  ChatLeftVideoTableViewCell.h
//  PalmDoctorPT
//
//  Created by Lars Chen on 15/7/7.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  左边视频聊天Cell

#import <UIKit/UIKit.h>

@interface ChatLeftVideoTableViewCell : UITableViewCell
{
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewBubble;    // 气泡
    UIImageView *_imgViewImage;     // 图片
    UILabel     *_lbName;           // 姓名
    UIActivityIndicatorView *_viewIndicator;    // 旋转指示器
}

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier Target:(id)target Action:(SEL)action ActionHead:(SEL)actionHead ActionLong:(SEL)actionLong;

// 显示消息
- (void)showImageMessage:(NSString *)imageUrl Tag:(NSInteger)tag;

// 显示位置截图
- (void)showPositionMessage:(NSString *)imageUrl Tag:(NSInteger)tag;

// 设置头像
- (void)setHeadIconWithUrl:(NSString *)imgUrl;

/** 加载指示器关闭开启
 */
- (void)setImageLoading:(BOOL)loading;

@end
