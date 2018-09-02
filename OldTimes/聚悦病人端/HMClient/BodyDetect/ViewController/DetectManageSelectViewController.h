//
//  DetectManageSelectViewController.h
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TestDeviceSelectBlock)(NSString* testDeviceItem);

@interface DetectManageSelectViewController : UIViewController
{
    
}

+ (DetectManageSelectViewController *) createWithParentViewController:(UIViewController*) parentviewcontroller deviceType:(NSString *)deviceType selectblock:(TestDeviceSelectBlock)block;


@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) TestDeviceSelectBlock selectblock;

- (void) createDeviceSelectTableView;

@end
