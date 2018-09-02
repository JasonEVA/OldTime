//
//  ServiceDetailViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "ServiceInfo.h"

@interface ServiceDetailTableHeaderView : UIView
{
    UIImageView* ivService;
    UIImageView* ivDefault;
}

- (void) setImageUrl:(NSString*) imgUrl;
@end

@interface ServiceDetailViewController : HMBasePageViewController

@end

@interface ServiceDetailTableViewController : UITableViewController
{
    
}

@property (nonatomic, retain) ServiceDetail* serviceDetail;

- (id) initWithServiceUpID:(NSInteger) aUpId;
- (NSArray*) serviceProductIDList;
@end
