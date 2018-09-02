//
//  HMBottomShotView.h
//  HMClient
//
//  Created by jasonwang on 2016/10/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//  底部弹出选择view

#import <UIKit/UIKit.h>
typedef void (^shotBlock)(NSInteger tag);
@interface HMBottomShotView : UIView
- (void)btnClick:(shotBlock)block;
@end
