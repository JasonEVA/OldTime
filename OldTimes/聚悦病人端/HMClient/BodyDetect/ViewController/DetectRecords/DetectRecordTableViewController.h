//
//  DetectRecordTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClientHelper.h"

#define  kDetectRecordTablePageSize         20

@interface DetectRecordTableViewController : UITableViewController
{
    NSMutableArray* recordItems;
    UIWebView* webview;
    NSInteger totalCount;
    
    NSString* userId;
}

- (id) initWithUserId:(NSString*) aUserId;
- (void) detectRecordsLoaded:(NSArray*) items;

- (NSString*) detectRecordTaskName;
@end
