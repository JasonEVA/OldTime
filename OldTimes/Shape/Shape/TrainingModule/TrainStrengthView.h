//
//  TrainStrengthView.h
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  训练强度闪电view

#import <UIKit/UIKit.h>

@interface TrainStrengthView : UIView

@property (nonatomic, strong) UIImageView *light1;
@property (nonatomic, strong) UIImageView *light2;
@property (nonatomic, strong) UIImageView *light3;
@property (nonatomic, strong) UIImageView *light4;
@property (nonatomic, strong) UIImageView *light5;

- (void)setTrainStrengLevel:(NSInteger)strengthLevel;
@end
