//
//  CDASelectCommitDoctorViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitDoctorSelectedBlock)(NSInteger staffId);

@interface CDASelectCommitDoctorViewController : UIViewController

+ (void) showInParentController:(UIViewController*) parentController
                         userId:(NSInteger) userId
      commitDoctorSelectedBlock:(CommitDoctorSelectedBlock)block;
@end
