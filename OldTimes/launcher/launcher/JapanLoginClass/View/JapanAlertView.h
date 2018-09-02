//
//  JapanAlertView.h
//  launcher
//
//  Created by williamzhang on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日本alertView

#import <UIKit/UIKit.h>

typedef void(^JapanAlertClickedBlock)(NSInteger index);

@interface JapanAlertView : UIView

+ (instancetype)alertViewImage:(UIImage *)image
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                 buttonsTitles:(NSArray *)buttonsTitles;

- (void)clickAtIndex:(JapanAlertClickedBlock)clickedBlock;
- (void)show;

@end
