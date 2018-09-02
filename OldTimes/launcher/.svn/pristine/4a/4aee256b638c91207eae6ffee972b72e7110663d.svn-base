//
//  ApplicationCreateNewMissionViewController.h
//  launcher
//
//  Created by 马晓波 on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@class MessageAppModel, ContactPersonDetailInformationModel;

typedef void(^createTaskCallback)(MessageAppModel *appModel,ContactPersonDetailInformationModel * model);

@class ApplicationCreateNewMissionViewController;

@interface ApplicationCreateNewMissionNavigationController : BaseNavigationController
@property (nonatomic, readonly) ApplicationCreateNewMissionViewController *rootVC;
@end

@interface ApplicationCreateNewMissionViewController : BaseViewController

/// 当前聊天对象 (为nil时为群聊天模式 default: myself)
@property (nonatomic, strong) ContactPersonDetailInformationModel *currentUserModel;

/**
 *  处理需要进行的数据
 *
 *  @param navigationController superVC
 *  @param title                转任务的标题
 *  @param completion           完成
 */
- (void)handleDataWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title completion:(createTaskCallback)completion;

@end