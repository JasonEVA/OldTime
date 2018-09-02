//
//  HealthHistoryTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthHistoryTableViewController : UITableViewController
{
    NSInteger type; //类型-1门诊、2住院、3体检
    NSString* userId;
}

- (id) initWithUserId:(NSString*) aUserId;
@end
