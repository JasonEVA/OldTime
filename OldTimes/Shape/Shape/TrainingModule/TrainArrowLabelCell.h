//
//  TrainArrowLabelCell.h
//  Shape
//
//  Created by jasonwang on 15/11/3.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainArrowLabelCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UILabel *label;

- (void)setTitel:(NSString *)titel strenth:(NSInteger)strenth;
@end
