//
//  BodyDetetBaseViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "PersonDevicesItem.h"
#import "DetectManageSelectViewController.h"

typedef enum : NSUInteger {
    DetectInput_None = 0x00,
    DetectInput_Device = 0x01,
    DetectInput_Manual = 0x02,
} DetectInputType;

@interface BodyDetetBaseViewController : HMBasePageViewController
{
    NSString* detectTaskId;
}

@property (nonatomic, assign) NSInteger allowInputType;

@end
