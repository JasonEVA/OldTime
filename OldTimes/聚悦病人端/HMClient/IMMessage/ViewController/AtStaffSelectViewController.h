//
//  AtStaffSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AtSelectStaffBlock)(StaffInfo*);

@interface AtStaffSelectViewController : UIViewController
{
    
}
+ (void) showInParentController:(UIViewController*) parentController
                      StaffList:(NSArray*) staffList
             AtSelectStaffBlock:(AtSelectStaffBlock)block;
@end
