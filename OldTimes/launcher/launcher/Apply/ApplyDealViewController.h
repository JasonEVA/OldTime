//
//  ApplyDealViewController.h
//  launcher
//
//  Created by Conan Ma on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyForwardingRequest.h"

typedef enum
{
    From_Receiver = 0,
    From_CC,
}ComesFrom;

@interface ApplyDealViewController : BaseViewController

- (instancetype)initWithFrom:(ComesFrom)ComeFrom;
@end
