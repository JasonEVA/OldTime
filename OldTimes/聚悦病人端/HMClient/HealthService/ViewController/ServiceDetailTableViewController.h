//
//  ServiceDetailTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceDetailTableHeaderView : UIView
{
    UIImageView* ivService;
    UIImageView* ivDefault;
}

- (void) setImageUrl:(NSString*) imgUrl;
@end


@interface ServiceDetailStartViewController : HMBasePageViewController

@end

@interface ServiceDetailTableViewController : UITableViewController
{
    
}

@property (nonatomic, retain) ServiceDetail* serviceDetail;

- (id) initWithServiceUpID:(NSInteger) aUpId;
- (NSArray*) serviceProductIDList;
@end
