//
//  PersonSpaceIntegralSourceReocrdsTableViewController.h
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSpaceIntegralSourceReocrdsTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger sourceId;

- (id) initWithSourceId:(NSInteger) sourceId;
@end
