//
//  AppMessageTableViewCell.h
//  launcher
//
//  Created by Tab Liu on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//
//  消息记录 cell -> APP

#import <UIKit/UIKit.h>
#import "RedPoint.h"
#import <MintcodeIM/MintcodeIM.h>

@interface AppMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * headImageView;           //头像
@property (nonatomic,strong) UILabel * messageLabel;                //聊天内容
@property (nonatomic,strong) UILabel * typeLabel;                   //消息类型
@property (nonatomic,strong) UILabel * nameLabel;                   //发送人姓名
@property (nonatomic,strong) UILabel * timeLabel;                   //事件 发生 时间
@property (nonatomic,strong) UIImageView * timeIcoImageView;        //钟表->图片
@property (nonatomic,strong) UILabel  * sendTimeLabel;              //发送时间
@property (nonatomic,strong) UIImageView * accessoryIcoImageView;   //附件图标
@property (nonatomic,strong) UIImageView * messageIcoImageView;     //消息
@property (nonatomic,strong) UIImageView * locationIcoImageView;    //位置图标
@property (nonatomic,strong) UILabel * locationLabel;               //位置
//@property (nonatomic,strong) RedPoint * unreadMark;                 //未读标志

@property (nonatomic,strong) NSString * uidStr;
@property (nonatomic,assign) BOOL  isGroup;

- (void)setCellData:(MessageBaseModel *)model;

- (void)setSearchCellData:(MessageBaseModel *)model searchText:(NSString *)text;

@end
