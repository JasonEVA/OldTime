//
//  BloodSugarAddDietViewController.h
//  HMClient
//
//  Created by lkl on 2017/7/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodSugarDetectRecord.h"

@interface BloodSugarAddDietViewController : UIViewController

- (instancetype)initWithDetectRecord:(DetectRecord *)record photos:(NSArray *)photos diet:(NSString *)diet;

@end
