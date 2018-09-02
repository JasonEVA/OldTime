//
//  HMSuperviseDetailXAxisCollectionViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/7/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测计划图表X轴cell

#import <UIKit/UIKit.h>
#import "HMSuperviseEnum.h"

@interface HMSuperviseDetailXAxisCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *dayLb;

- (void)fillDataWithDate:(NSDate *)date isHide:(BOOL)isHide showDay:(BOOL)showDay showMonth:(BOOL)showMonth showYear:(BOOL)showYear superviseScreeningType:(SESuperviseScreening)type;
@end
