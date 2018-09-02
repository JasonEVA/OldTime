//
//  NewbieGuideInteractor.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//  新手指引页面管理器

#import <Foundation/Foundation.h>
#import "NewbieGuidePageTypeEnum.h"

@interface NewbieGuideInteractor : NSObject

+ (void)presentNewbieGuideWithGuideType:(NewbieGuidePageType)guideType presentingViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (BOOL)showedNewbieGuideWithType:(NewbieGuidePageType)guideType;
@end
