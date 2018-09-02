//
//  MuscleImageView.h
//  Shape
//
//  Created by Andrew Shen on 15/10/22.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 肌肉图片控件

#import <UIKit/UIKit.h>

@interface MuscleImageView : UIImageView

- (instancetype)initWithImage:(UIImage *)image  highlightedImage:highlightedImage target:(id)target gestureAction:(SEL)gestureAction tag:(NSInteger)tag;

@end
