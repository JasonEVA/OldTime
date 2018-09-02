//
//  AddAerobicDataView.h
//  Shape
//
//  Created by Andrew Shen on 15/10/29.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  添加有氧数据弹出框

#import <UIKit/UIKit.h>

typedef void(^AddWeightAndFatBlock)(CGFloat weight , NSString *fatRange , BOOL confirm);
@interface AddAerobicDataView : UIView


- (void)setWeight:(CGFloat)weight fatRange:(NSString *)fatRange callBack:(AddWeightAndFatBlock)callBack;
@end
