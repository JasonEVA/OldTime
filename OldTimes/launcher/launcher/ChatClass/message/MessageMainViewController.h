//
//  MessageMainViewController.h
//  launcher
//
//  Created by Tab Liu on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//
//  消息记录 UI

#import "BaseViewController.h"
@class ChattingModule;
@interface MessageMainViewController : BaseViewController

/** 字符串形式的uid，用户查找数据 */
@property (nonatomic, copy) NSString *strUid;
/*是否是群聊 */
@property (nonatomic,assign) BOOL  isGroupChat;

@property(nonatomic, strong) ChattingModule  *modual;

@end

