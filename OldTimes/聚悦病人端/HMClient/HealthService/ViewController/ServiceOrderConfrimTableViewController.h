//
//  ServiceOrderConfrimTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceOrderConfrimStartViewController : HMBasePageViewController
{
    
}

@property (nonatomic, retain) NSArray* needMsgItems;
@property (nonatomic, retain) ServiceDetail* serviceDetail;
@end

@interface ServiceOrderConfrimTableViewController : UITableViewController
{
    
}
@property (nonatomic, readonly) ServicePayWay* selectedPayway;
@end
