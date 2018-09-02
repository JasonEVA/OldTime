//
//  UIView+ImageProgress.h
//  HMClient
//
//  Created by lkl on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZJKWaitViewTag 0x3510

@interface UIView (ImageProgress)

- (void) showImageWaitView;
- (void) closeImageWaitView;


@end