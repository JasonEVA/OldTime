//
//  UIViewController+modalPresent.h
//  launcher
//
//  Created by williamzhang on 15/12/29.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (modalPresent)

/// 半透明弹出VC
- (void)modalPresentViewController:(UIViewController *)viewControllerToPresent;

@end
