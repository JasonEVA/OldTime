//
//  DeviceSelectTableViewController.h
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonDevicesItem;

@interface DeviceSelectDeviceViewController : HMBasePageViewController

@end

@interface DeviceSelectTableViewController : UITableViewController

@property (nonatomic, strong) PersonDevicesItem* deviceItem;

@end
