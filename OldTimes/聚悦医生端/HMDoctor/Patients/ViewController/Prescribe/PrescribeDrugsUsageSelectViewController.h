//
//  PrescribeDrugsUsageSelectViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrugsUsagesInfo.h"

typedef void(^DrugUsageSelectBlock)(id drugUsage);

@interface PrescribeDrugsUsageSelectViewController : UIViewController

@property (nonatomic, copy) void(^drugUsageBlock)(NSDictionary* drugUsageItem);


+ (PrescribeDrugsUsageSelectViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                       drugsUsage:(NSString *)usage
                                                         selectblock:(DrugUsageSelectBlock)block;
@property (nonatomic, copy) DrugUsageSelectBlock selectblock;


@property (nonatomic, copy) NSString* drugsUsage;

@end
