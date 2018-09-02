//
//  AnaerobicExerciseBodyView.h
//  Shape
//
//  Created by Andrew Shen on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 无氧运动人体部位图

#import <UIKit/UIKit.h>

@interface AnaerobicExerciseBodyView : UIView

- (instancetype)initWithPositiveSide:(BOOL)positive;
- (void)configViewSide:(BOOL)positive;
@end
