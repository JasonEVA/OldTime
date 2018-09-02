//
//  InitializeAdvertiseViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseInfo.h"

@interface InitializeAdvertiseViewController : UIViewController

+ (void) showInParentViweController:(UIViewController*) parentViewController
                      advertiseInfo:(AdvertiseInfo*) advertiseInfo;

- (id) initWithAdvertiseInfo:(AdvertiseInfo*) advertise;

@end
