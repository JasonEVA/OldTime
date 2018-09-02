//
//  ATModuleInteractor.h
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATModuleInteractor : NSObject

+ (instancetype)sharedInstance;

// 普通push
- (void)pushToVC:(UIViewController *)VC;

// 强制跳转rootView再push
- (void)PushToChatVC:(UIViewController *)VC;
@end
