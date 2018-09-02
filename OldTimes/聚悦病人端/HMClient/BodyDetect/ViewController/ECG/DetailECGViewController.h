//
//  DetailECGViewController.h
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectResultViewController.h"
#import "HeartRateDetectRecord.h"

@interface DetailECGViewController : BodyDetectResultViewController

- (void) detectResultLoaded:(HeartRateDetectResult*) result;

@end
