//
//  ChatGroupViewController.h
//  launcher
//
//  Created by Lars Chen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群聊窗口

#import "ChatBaseViewController.h"

typedef void(^titlechangeBlock)(NSString *grouptitle,NSString *avatar);

@interface ChatGroupViewController : ChatBaseViewController

- (void)changeGroupTitleWithBlcok:(titlechangeBlock)block;

@end