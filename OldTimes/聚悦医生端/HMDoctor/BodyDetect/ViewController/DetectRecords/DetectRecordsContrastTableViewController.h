//
//  DetectRecordsContrastTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectRecordOverallTimeView.h"

@interface DetectRecordsContrastTableViewController : UITableViewController
{
    
}

@property (nonatomic, assign) DetectTimeType timetype;

- (id) initWithUserId:(NSString*) aUserId;
@end
