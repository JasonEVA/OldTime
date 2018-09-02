//
//  ServiceShareViewController.h
//  HMClient
//
//  Created by yinquan on 2017/5/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceShareViewController : UIViewController


//ServiceInfo

+ (void) showInParentController:(UIViewController*) parentController
                    ServiceInfo:(ServiceInfo*) serviceInfo;

@end
