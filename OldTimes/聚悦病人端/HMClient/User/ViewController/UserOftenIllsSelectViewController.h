//
//  UserOftenIllsSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/7/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserOftenIllSelectBlock)(NSArray* selectedIllIds);

@interface UserOftenIllsSelectViewController : UIViewController
{
    
}

+ (void) showInParentController:(UIViewController*) parentController
                      OftenIlls:(NSArray*) oftenIlls
                    SelectBlock:(UserOftenIllSelectBlock)block;
@end
