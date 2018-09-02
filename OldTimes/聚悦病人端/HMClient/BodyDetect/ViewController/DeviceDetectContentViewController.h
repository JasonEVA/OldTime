//
//  DetectInputContentViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientHelper.h"

static NSString *const BloodPressureDetectResultNotify = @"BloodPressureDetectResultValue";

@interface DeviceDetectContentViewController : UIViewController
{
    
}
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, retain) id detectResult;
@end
