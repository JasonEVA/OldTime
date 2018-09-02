//
//  FriendSelectViewController.h
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"

typedef void(^FriendSelectBlock)(FriendInfo* friendinfo);

@interface FriendSelectViewController : UIViewController

+ (FriendSelectViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                    item:(NSArray *)item
                                                             selectblock:(FriendSelectBlock)block;
@property (nonatomic, copy) FriendSelectBlock selectblock;


@property (nonatomic, retain) NSArray* friendItem;

@end