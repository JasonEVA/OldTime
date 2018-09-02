//
//  TrainFinishInputView.h
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TrainFinishInputViewDelegate <NSObject>

- (void)TrainFinishInputViewDelegate_callBack;

@end

@interface TrainFinishInputView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *finishTitelLb;
@property (nonatomic, strong) UILabel *todayDataLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *actionLb;
@property (nonatomic, strong) UILabel *action;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) UILabel *cost;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, assign)  id <TrainFinishInputViewDelegate>  delegate; // 委托
@end
