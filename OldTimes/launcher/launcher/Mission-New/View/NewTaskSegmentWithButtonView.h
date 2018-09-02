//
//  NewTaskSegmentWithButtonView.h
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  优先度选择View

#import <UIKit/UIKit.h>

/**
 *  从左到右为2高，1中，3低
 */
@interface NewTaskSegmentWithButtonView : UIControl

/** 未选择返回0 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end
