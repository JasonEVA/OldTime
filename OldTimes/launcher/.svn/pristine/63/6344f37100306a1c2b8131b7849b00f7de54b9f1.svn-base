//
//  EventSuperTableViewCell.h
//  launcher
//
//  Created by TabLiu on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  事件消息模型 的 父类

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "RedPoint.h"


static NSString * pass    = @"APPROVE"; 
static NSString * pending = @"WAITING";
static NSString * ongoing = @"IN_PROGRESS";
static NSString * unPass  = @"DENY";
static NSString * Back_to  = @"CALL_BACK";

@interface EventSuperTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView * bgView;                   // 圆角白色背景
@property (nonatomic,strong) UIView * line1;                    // 上下滑线
@property (nonatomic,strong) UIImageView * titleView;           // 标题背景色
@property (nonatomic,strong) UILabel *lbKind;                   // 应用种类
@property (nonatomic,strong) UILabel * eventContentLabel;       // 事件标题(简介)
@property (nonatomic,strong) UILabel * eventStatusLabel;        // 事件的状态
@property (nonatomic,strong) UILabel * eventTypeLabel;          // 事件的类型
@property (nonatomic,strong) UILabel * sendManLabel;            // 建立事件的人的名字
@property (nonatomic,strong) UILabel * sendTimeLabel;           // 事件建立的时间
@property (nonatomic,strong) UILabel *  fromLabel;              // 来自...
@property (nonatomic,strong) UIImageView * eventTypeIconImage;  // 事件类型图标
@property (nonatomic, strong) RedPoint *redpoint;             //未读标记

+ (NSString *)identifier;

- (void)setEventLabelTextWithEventStatusType:(NSString *)type;

- (void)setReadHidden;

- (void)setEventSendManLabel:(NSString *)name;
- (void)setLabelKindNale:(NSString *)name;
@end
