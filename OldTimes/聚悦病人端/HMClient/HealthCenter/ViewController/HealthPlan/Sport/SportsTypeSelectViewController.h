//
//  SportsTypeSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSportsDetail.h"

typedef void(^SportsTypeSelectBlock)(RecommandSportsType* sportsType);

@interface SportsTypeSelectViewController : UIViewController

+ (void) showInParentController:(UIViewController*) parentController
                    SportsTypes:(NSArray*) types
          SportsTypeSelectBlock:(SportsTypeSelectBlock)block;
@end
