//
//  NewSiteMessageBubbleBaseTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信带气泡基类cell

#import <UIKit/UIKit.h>
#import "LeftTriangle.h"
#import "NSDate+MsgManager.h"
#import "AvatarUtil.h"

#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 130)   // 文字最大宽度

@interface NewSiteMessageBubbleBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgViewHeadIcon;         // 头像
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) LeftTriangle *leftTri; // 尖角
@property (nonatomic, strong) UILabel *nikeNameLb;   //昵称


- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor;
@end
