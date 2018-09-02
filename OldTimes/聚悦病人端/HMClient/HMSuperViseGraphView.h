//
//  HMSuperViseGraphView.h
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测记录曲线图

#import <UIKit/UIKit.h>

@interface HMSuperViseGraphView : UIView

- (void)fillDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr;

- (void)fillDataWithArrayOne:(NSArray *)arrayOne arrayTwo:(NSArray *)arrayTwo maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr;

- (void)fillFLSZDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr;
@end
