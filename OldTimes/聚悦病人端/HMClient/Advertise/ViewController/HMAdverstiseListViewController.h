//
//  HMAdverstiseListViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMAdvertiseCell.h"

@interface HMAdverstiseListViewController : UIViewController
{
    
}

@property (nonatomic, assign) CGFloat viewHeight;

- (void) advertiseListLoaded:(NSArray*) advertises;
@end
