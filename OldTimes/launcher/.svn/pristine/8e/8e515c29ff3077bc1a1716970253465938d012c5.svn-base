//
//  NewChatNewTaskView.h
//  launcher
//
//  Created by 马晓波 on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>
#import "ContactPersonDetailInformationModel.h"

/// 创建任务成功回调
typedef void(^createTaskCallback)(MessageAppModel *appModel,ContactPersonDetailInformationModel * model);
typedef void(^clickMoreCallBack)();

@interface NewChatNewTaskView : UIView

@property (nonatomic, weak) UIViewController *parentController;
@property (nonatomic, strong) NSArray *arrPersons;
@property (nonatomic) BOOL isGroupChat;

/// 当前聊天对象的userShowId
@property (nonatomic, strong) ContactPersonDetailInformationModel *currentUserModel;

- (instancetype)initCreateNewTaskBlock:(createTaskCallback)taskBlock;
- (instancetype)initCreateNewTaskWithTitle:(NSString *)title block:(createTaskCallback)taskBlock;

/// 更多选项，传入navigationController
- (void)moreOptions:(UINavigationController *(^)())moreBlock;

- (void)dismiss;

//- (void)clickMoreWithBlick:(clickMoreCallBack)block;


@end
