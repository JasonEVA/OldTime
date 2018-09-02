//
//  SurveryStartViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
@class HMNewPatientSelectViewController;
@interface SurveryStartViewController : HMBasePageViewController
{
    HMNewPatientSelectViewController* tvcPatients;
}
@end

@interface InterrogationStartViewController : SurveryStartViewController

@end
