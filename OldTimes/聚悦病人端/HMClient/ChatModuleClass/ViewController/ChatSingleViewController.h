//
//  ChatSingleViewController.h
//  Titans
//
//  Created by Remon Lv on 14-9-11.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  单聊窗口

#import "ChatBaseViewController.h"

@interface ChatSingleViewController : ChatBaseViewController
@property (nonatomic) BOOL isLittleHelper;        //是否为健康顾问界面
@property (nonatomic, copy) NSArray *helperList;  //健康顾问列表
@end
