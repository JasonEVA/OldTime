//
//  DetectRecordsSEOverallTableViewController.h
//  HMClient
//
//  Created by lkl on 2017/5/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectRecordOverallTimeView.h"

@interface DetectRecordsSEOverallTableViewController : UITableViewController

@property (nonatomic, assign) DetectTimeType timetype;

- (id)initWithUserId:(NSString *)aUserId;

@end

