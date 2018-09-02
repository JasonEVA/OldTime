//
//  InitializeAdvertiseViewController.h
//  HMClient
//
//  Created by yinquan on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseInfo.h"

@interface InitializeAdvertiseViewController : UIViewController

+ (void) showInParentViweController:(UIViewController*) parentViewController
                      advertiseInfo:(AdvertiseInfo*) advertiseInfo;

- (id) initWithAdvertiseInfo:(AdvertiseInfo*) advertise;

@end
