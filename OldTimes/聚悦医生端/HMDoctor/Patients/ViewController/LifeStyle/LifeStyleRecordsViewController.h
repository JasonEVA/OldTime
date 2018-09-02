//
//  LifeStyleRecordsViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeStyleRecordsViewController : UIViewController
{
    
}

- (id) initWithUserId:(NSString*) aUserId;
- (void)refreshDataWithUserID:(NSString *)userID;
@end
