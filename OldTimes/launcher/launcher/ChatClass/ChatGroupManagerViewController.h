//
//  ChatGroupManagerViewController.h
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群聊设置界面

#import "BaseViewController.h"

@class ChatGroupManagerViewController;
@protocol ChatGroupManagerViewControllerDelegate <NSObject>

@optional
- (void)chatGroupManagerViewControllerDidChangedGroupName:(BOOL)didChanged NewGroupName:(NSString *)newGroupName OldGroupName:(NSString *)oldGroupName;

@end

@interface ChatGroupManagerViewController : BaseViewController

@property (nonatomic, copy)  NSString  *groupID; // 群ID
@property (nonatomic, weak) id <ChatGroupManagerViewControllerDelegate> delegate;
@end
