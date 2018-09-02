//
//  NewbieGuideMainViewController.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBaseViewController.h"
#import "NewbieGuidePageTypeEnum.h"

@interface NewbieGuideMainViewController : HMBaseViewController

+ (BOOL)newbieGuideShowedForGuideType:(NewbieGuidePageType)guideType;

- (instancetype)initWithNewbieGuideType:(NewbieGuidePageType)guideType;

@end
