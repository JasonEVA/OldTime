//
//  IntegralSourceListViewController.h
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IntegralSourceChoose)(NSInteger sourceId, NSString* sourceName);

@interface IntegralSourceListViewController : UIViewController

+ (void) showWithIntegralSourceChooseBlock:(IntegralSourceChoose) block selectedSourceId:(NSInteger) selectedSourceId;
@end
