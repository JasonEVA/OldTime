//
//  PersonSpaceAddressBookSelectedDepViewController.h
//  HMDoctor
//
//  Created by lkl on 16/7/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookInfo.h"

typedef void(^DepNameSelectBlock)(AddressBookDepNameInfo* DepNameInfo);

@interface PersonSpaceAddressBookSelectedDepViewController : UIViewController

@property (nonatomic, copy) void(^testTimeBlock)(NSDictionary* testPeriodItem);


+ (PersonSpaceAddressBookSelectedDepViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                         selectblock:(DepNameSelectBlock)block;
@property (nonatomic, copy) DepNameSelectBlock selectblock;

@end