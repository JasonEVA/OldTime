//
//  DetectInputViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectInputViewController.h"
#import "ClientHelper.h"
#import "RecordHealthHistoryManager.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"

@interface DetectInputViewController : UIViewController
{
    
}

@property (nonatomic, assign) NSInteger inputType;
@property (nonatomic, retain) NSString* detectTaskId;
@property (nonatomic, retain) NSString* excTime;        //监测计划执行时间
/*
 postDetectResult
 上传检测结果
 */
- (void) postDetectResult:(id) dicResult;
@end



@interface DetectDeviceInputViewController : DetectInputViewController
{
    
}

@property (nonatomic, readonly) BOOL isAppear;
@end

@interface DetectManualInputViewController : DetectInputViewController

@end
