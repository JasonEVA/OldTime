//
//  PersonCommitIDCardViewController.h
//  HMClient
//
//  Created by yinquan on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

typedef void(^CommitIDCardHandleBlock)();

@interface PersonCommitIDCardViewController : UIViewController

+ (void) showWithHandleBlock:(CommitIDCardHandleBlock) handleBlock;
@end
