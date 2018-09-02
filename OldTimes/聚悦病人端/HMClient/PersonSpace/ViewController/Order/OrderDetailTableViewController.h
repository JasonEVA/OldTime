//
//  OrderDetailTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailStartViewController : HMBasePageViewController
- (instancetype)initWithOrderId:(NSString *)orderIdString;
@end

@interface OrderDetailTableViewController : UITableViewController

@end
