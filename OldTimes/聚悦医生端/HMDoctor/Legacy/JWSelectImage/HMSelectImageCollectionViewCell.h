//
//  HMSelectImageCollectionViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//  选择图片cell

#import <UIKit/UIKit.h>

typedef void(^deleteImageBlock)();

@interface HMSelectImageCollectionViewCell : UICollectionViewCell
- (void)fillDataWithImage:(UIImage *)image showDeleteBtn:(BOOL)show;
- (void)deleteImageClick:(deleteImageBlock)block;
@end
