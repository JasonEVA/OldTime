//
//  DetectRecordsSEContrastTableViewController.h
//  HMClient
//
//  Created by lkl on 2017/5/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectRecordOverallTimeView.h"

@interface DetectRecordsSEContrastTableViewController : UITableViewController

@property (nonatomic, assign) DetectTimeType timetype;
- (id)initWithUserId:(NSString *)aUserId;

@end
