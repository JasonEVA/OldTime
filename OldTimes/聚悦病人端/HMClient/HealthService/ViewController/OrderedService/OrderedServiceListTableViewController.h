//
//  OrderedServiceListTableViewController.h
//  HMClient
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isHaveService)(BOOL isHaveService);
@interface OrderedServiceListTableViewController : UITableViewController
- (void)acquireServiceStatus:(isHaveService)isHave;
@end
