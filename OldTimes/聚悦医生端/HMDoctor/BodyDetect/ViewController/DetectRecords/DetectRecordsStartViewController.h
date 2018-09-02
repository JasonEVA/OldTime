//
//  DetectRecordsStartViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface DetectRecordsStartViewController : UIViewController
{
    
}


- (id) initWithUserId:(NSString*) userId;

- (void)refreshDataWithUserID:(NSString *)userID;
@end
