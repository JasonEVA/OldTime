//
//  FoodVolumeSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodListItem.h"

typedef void(^FoodVolumeSelectBlock)(NSInteger vol);

@interface FoodVolumeSelectViewController : UIViewController
{
    
}

+ (void) showInParentController:(UIViewController*) parentcontroller
                       FoodInfo:(FoodListItem*) foodInfo
          FoodVolumeSelectBlock:(FoodVolumeSelectBlock) block;
@end
