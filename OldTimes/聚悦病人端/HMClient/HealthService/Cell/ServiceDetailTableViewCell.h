//
//  ServiceDetailTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceInfo.h"

@interface ServiceDetailTableViewCell : UITableViewCell
{
    
}
- (void) setServiceDetail:(ServiceDetail*) detail;
- (void) setServiceIsGoods:(BOOL) isGoods;
@end

@interface ServiceDetailPriceTableViewCell : ServiceDetailTableViewCell


@end

@interface ServiceDetailProviderTableViewCell : ServiceDetailTableViewCell

@end

@interface ServiceDetailBillWayTableViewCell : ServiceDetailTableViewCell

@end

@interface ServiceGoodsDetailBillWayTableViewCell : ServiceDetailTableViewCell

@end



@interface ServiceDetailOptionTableViewCell : UITableViewCell
{
    
}

- (void) setServiceOption:(ServiceDetailOption*) option;
@end

@interface ServiceDetailDescriptionTableViewCell : ServiceDetailTableViewCell

@end
