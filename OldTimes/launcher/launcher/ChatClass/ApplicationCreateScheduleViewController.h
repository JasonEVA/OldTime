//
//  ApplicationCreateScheduleViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天新建日程界面

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@class ApplicationCreateScheduleViewController;

@interface ApplicationCreateNavigationController : BaseNavigationController
@property (nonatomic, readonly) ApplicationCreateScheduleViewController *rootVC;
@end

@interface ApplicationCreateScheduleViewController : BaseViewController

/**
 *  处理需要进行的数据
 *
 *  @param navigationController superVC
 *  @param title                转日程的标题
 *  @param completion           完成
 */
- (void)handleDataWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title completion:(void(^)())completion;

@end
