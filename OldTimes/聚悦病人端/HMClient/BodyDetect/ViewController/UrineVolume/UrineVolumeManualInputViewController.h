//
//  UrineVolumeManualInputViewController.h
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectInputViewController.h"

@interface UrineVolumeManualInputViewController : DetectManualInputViewController

@end

typedef enum : NSUInteger {
    UrineVolumeDayTime,
    UrineVolumeNightTime,
} UrineVolumeTimeType;


@interface UrineVolumePeriodControl : UIControl
{
    
}
@property (nonatomic, readonly) UrineVolumeTimeType timetype;
@end