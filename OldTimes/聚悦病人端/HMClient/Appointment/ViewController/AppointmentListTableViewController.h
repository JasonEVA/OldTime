//
//  AppointmentListTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentListTableViewController : UITableViewController
{
    
}

@property (nonatomic, assign) NSInteger totalCount;

- (void) setAppointStatus:(NSString*) status;

@end
