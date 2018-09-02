//
//  HealthPlanMessionTableViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanMessionStartWebViewViewController : HMBasePageViewController

@end


@interface HealthPlanMessionTableViewController : UITableViewController

@property (nonatomic, retain) NSString* keyword;
@property (nonatomic, assign) BOOL isSearch;

- (id)initWithKeyword:(NSString *)keyword;

- (id) initWithStatusList:(NSArray*) statusList;
@end
