//
//  TrainProgressView.h
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainProgressView : UIView

@property (nonatomic, strong) UIImageView *progressView;
@property (nonatomic, strong) UILabel *totalPtogressLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *precentLb;
@property (nonatomic, strong) UIView *hideView;
- (void)setMyProgress:(CGFloat)progress;
@end
