//
//  HealthDetectAlertTimesView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthDetectAlertTimesCountBlock)(NSInteger count);

@interface HealthDetectAlertTimesViewController : UIViewController

@property (nonatomic, readonly) NSMutableArray* alertTimeModels;

- (id) initWithAlertTimesModels:(NSArray*) alerts countBlock:(HealthDetectAlertTimesCountBlock) block;

@end
