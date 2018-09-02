//
//  HMWeightHistoryCollectionViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSuperviseDetailModel;

@interface HMWeightHistoryCollectionViewCell : UICollectionViewCell

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isSelected:(BOOL)isSelected;

@end
