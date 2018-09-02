//
//  ServiceQRCodeViewController.h
//  HMClient
//
//  Created by yinquan on 2017/5/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceQRCodeViewController : UIViewController

- (id) initWithServiceInfo:(ServiceInfo*) serviceInfo shareUrl:(NSString*) shareUrl;

@end
