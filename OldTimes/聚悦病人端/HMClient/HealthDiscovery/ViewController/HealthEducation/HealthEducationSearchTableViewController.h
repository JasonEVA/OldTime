//
//  HealthEducationSearchTableViewController.h
//  HMClient
//
//  Created by yinquan on 16/12/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthEducationSearchTableViewController : UITableViewController

@property (nonatomic, retain) NSString* keyword;

- (id) initWithKeyword:(NSString*) keyword;

@end
