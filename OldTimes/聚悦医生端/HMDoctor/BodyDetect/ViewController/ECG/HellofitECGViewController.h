//
//  HellofitECGViewController.h
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectInputViewController.h"

@interface HellofitECGViewController : DetectDeviceInputViewController

@property(nonatomic, copy) NSMutableArray *ecgData;
@property(nonatomic, assign) BOOL  isStart;
@property(nonatomic, assign) BOOL  isStop;

@end
