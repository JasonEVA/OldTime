//
//  ApplicationCreateMissionViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天新建任务界面

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@class MessageAppModel, ContactPersonDetailInformationModel;

typedef void(^createTaskCallback)(MessageAppModel *appModel,ContactPersonDetailInformationModel * model);

@class ApplicationCreateMissionViewController;

@interface ApplicationCreateMissionNavigationController : BaseNavigationController
@property (nonatomic, readonly) ApplicationCreateMissionViewController *rootVC;
@end

@interface ApplicationCreateMissionViewController : BaseViewController

/// 当前聊天对象 (为nil时为群聊模式)
@property (nonatomic, strong) NSString *currentUserShowId;

/**
 *  处理需要进行的数据
 *
 *  @param navigationController superVC
 *  @param title                转任务的标题
 *  @param completion           完成
 */
- (void)handleDataWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title completion:(createTaskCallback)completion;

@end
