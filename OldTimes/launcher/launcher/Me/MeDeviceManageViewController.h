//
//  MeDeviceManageViewController.h
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^quitActionBlock)();

@interface MeDeviceManageViewController : BaseViewController

- (void)quiteActionsWithBlock:(quitActionBlock)quit;

@end
