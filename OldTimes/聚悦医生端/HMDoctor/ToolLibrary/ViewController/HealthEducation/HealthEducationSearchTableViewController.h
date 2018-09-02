//
//  HealthEducationSearchTableViewController.h
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthEducationSearchTableViewController : UITableViewController
@property (nonatomic, retain) NSString* keyword;

- (id) initWithKeyword:(NSString*) keyword;
@end
