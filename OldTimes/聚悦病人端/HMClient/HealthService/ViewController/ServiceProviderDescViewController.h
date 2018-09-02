//
//  ServiceProviderDescViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProviderDescViewController : UIViewController

+ (void) showInParentViewController:(UIViewController*) parentController
                       ProviderDesc:(NSString*) desc;
@end
