//
//  ChatNewTaskView.h
//  launcher
//
//  Created by Lars Chen on 15/10/8.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天新建任务

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>
#import "ContactPersonDetailInformationModel.h"

/// 创建任务成功回调
typedef void(^createTaskCallback)(MessageAppModel *appModel,ContactPersonDetailInformationModel * model);

@interface ChatNewTaskView : UIView

@property (nonatomic, weak) UIViewController *parentController;
@property (nonatomic, strong) NSArray *arrPersons;
@property (nonatomic) BOOL isGroupChat;

/// 当前聊天对象的userShowId
@property (nonatomic, copy) NSString *currentUserShowId;

- (instancetype)initCreateNewTaskBlock:(createTaskCallback)taskBlock;
- (instancetype)initCreateNewTaskWithTitle:(NSString *)title block:(createTaskCallback)taskBlock;

/// 更多选项，传入navigationController
- (void)moreOptions:(UINavigationController *(^)())moreBlock;

- (void)dismiss;

@end
