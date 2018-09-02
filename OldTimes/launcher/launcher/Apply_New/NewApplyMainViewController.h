//
//  NewApplyMainViewController.h
//  launcher
//
//  Created by conanma on 16/1/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyForwardingRequest.h"

typedef enum
{
    From_Receiver = 0,
    From_CC,
}ComesFrom;

@interface NewApplyMainViewController : BaseViewController
- (instancetype)initWithFrom:(ComesFrom)ComeFrom;
@end
