//
//  RoundsRecordsTableViewController.h
//  HMDoctor
//
//  Created by lkl on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundsRecordsTableViewController : UITableViewController

- (id) initWithUserId:(NSString*) aUserId;
- (void)refreshDataWithUserID:(NSString *)userID;

@end
