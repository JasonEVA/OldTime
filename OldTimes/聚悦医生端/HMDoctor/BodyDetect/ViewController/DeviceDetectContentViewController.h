//
//  DetectInputContentViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientHelper.h"
#import "JYBluetoothManager.h"

static NSString *const BloodPressureDetectResultNotify = @"BloodPressureDetectResultValue";

@interface DeviceDetectContentViewController : UIViewController <JYBluetoothManagerDelegate>
{
    
}
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, retain) id detectResult;
@property (nonatomic, copy) NSString *userId;
@end
