//
//  OrderServiceDetView.h
//  HMClient
//
//  Created by yinquan on 16/11/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderedServiceModel.h"

@interface OrderServiceDetView : UIView

- (void) setServiceDet:(UserServiceDet*) serviceDet;
@end

@interface OrderPackageServiceDetView : OrderServiceDetView

@end

@interface OrderValueAddedServiceDetView : OrderServiceDetView

@end
