//
//  ServiceNeedMessageViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "ServiceInfo.h"

@interface ServiceNeedMessageViewController : HMBasePageViewController
{
    
}

@property (nonatomic, retain) ServiceDetail* serviceDetail;
@end

@interface ServiceNeedMessageTableViewController : UITableViewController
{
    
}
- (NSArray*) makeNeedMsgItems;
- (id) initWithNeedMsgItems:(NSArray*) msgItems;
@end
