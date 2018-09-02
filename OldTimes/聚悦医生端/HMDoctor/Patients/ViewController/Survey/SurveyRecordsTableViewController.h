//
//  SurveyRecordsTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyRecordsTableViewController : UITableViewController
{
    NSArray *surveyTypes;
}

- (id) initWithUserId:(NSString*) aUserId;
- (void)refreshDataWithUserID:(NSString *)userID;

@end

@interface InterrogationRecordsTableViewController : SurveyRecordsTableViewController

@end

