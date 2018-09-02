//
//  HosipitalSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgTeamSelectViewController.h"


@protocol HosipitalSelectDelegate <NSObject>

- (void) hosipitalSelected:(HosipitalInfo*) hosipital;

@end

@interface HosipitalSelectViewController : OrgTeamSelectViewController
{
    
}


+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<HosipitalSelectDelegate>) delegate;
@end
