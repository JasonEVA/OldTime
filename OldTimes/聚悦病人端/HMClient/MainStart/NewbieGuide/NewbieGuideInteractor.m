//
//  NewbieGuideInteractor.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewbieGuideInteractor.h"
#import "NewbieGuideMainViewController.h"

@implementation NewbieGuideInteractor

+ (void)presentNewbieGuideWithGuideType:(NewbieGuidePageType)guideType presentingViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NewbieGuideMainViewController *guideVC = [[NewbieGuideMainViewController alloc] initWithNewbieGuideType:guideType];
    [viewController presentViewController:guideVC animated:animated completion:nil];
}

+ (BOOL)showedNewbieGuideWithType:(NewbieGuidePageType)guideType {
    BOOL showed = [NewbieGuideMainViewController newbieGuideShowedForGuideType:guideType];
    return showed;
}
@end
