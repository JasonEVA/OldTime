//
//  ServiceProviderOrgSelectViewController.h
//  HMClient
//
//  Created by yinquan on 16/12/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HosipitalInfo.h"
#import "OrgTeamSelectViewController.h"

@protocol ServiceProviderOrgSelectDelegate <NSObject>

- (void) hosipitalSelected:(HosipitalInfo*) hosipital;

@end

@interface ServiceProviderOrgSelectViewController : OrgTeamSelectViewController

+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<ServiceProviderOrgSelectDelegate>) delegate
                  productTypeId:(NSInteger) productTypeId;

@end
