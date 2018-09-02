//
//  HMSEMainStartHealthClassCollectionViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  健康课堂

#import <UIKit/UIKit.h>
@class HealthEducationItem;
@interface HMSEMainStartHealthClassCollectionViewCell : UICollectionViewCell
- (void)fillDataWithModel:(HealthEducationItem *)model;
@end
