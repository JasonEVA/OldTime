//
//  JWSegmentView.h
//  HMClient
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  自定义 UISegmentedControl

#import <UIKit/UIKit.h>

typedef void(^JWSegmentBlock)(NSInteger selectedTag);

@interface JWSegmentView : UIView

@property (nonatomic) BOOL isDisable;

- (instancetype)initWithFrame:(CGRect)frame
                     titelArr:(NSArray<NSString *> *)titelArr
                       tagArr:(NSArray *)tagArr
         titelSelectedJWColor:(UIColor *)titelSelectedJWColor
       titelUnSelectedJWColor:(UIColor *)titelUnSelectedJWColor
                  lineJWColor:(UIColor *)lineJWColor
                  backJWColor:(UIColor *)backJWColor
                  lineWidth:(CGFloat)lineWidth
                        block:(JWSegmentBlock)block;

- (void)configSelectItemWithTag:(NSInteger)tag;

@end
