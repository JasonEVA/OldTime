//
//  ServiceOrderConfirmInfoTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceOrderConfirmInfoTableViewCell : UITableViewCell
{
    
}

- (void) setServiceDetail:(ServiceDetail*) serviceDetail;
@end

@interface ServiceOrderConfirmPriceTableViewCell : UITableViewCell
{
    
}

- (void) setServicePrice:(float) servicePrice;
@end

@interface ServiceOrderConfirmPaywayTableViewCell : UITableViewCell
{
    
}

- (void) setPayway:(ServicePayWay*) payway;

- (void) setIsSelected:(BOOL) isSelected;
@end