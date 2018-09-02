//
//  OrderPaywayChooseTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

typedef void(^OrderPaywayChooseBlock)(ServicePayWay* payway);

@interface OrderPaywayChooseViewController : UIViewController
{
    
}

+ (void) showInPerantController:(UIViewController*) parentController
                        Payways:(NSArray*)payways
                    ChooseBlock:(OrderPaywayChooseBlock)block;
@end

@interface OrderPaywayChooseTableViewController : UITableViewController

@end
