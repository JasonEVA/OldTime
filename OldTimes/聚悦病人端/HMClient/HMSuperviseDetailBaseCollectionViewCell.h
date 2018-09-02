//
//  HMSuperviseDetailBaseCollectionViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/7/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测计划图表基础cell

#import <UIKit/UIKit.h>
#import "HMSuperviseEachPointModel.h"
#import "HMSuperviseDetailModel.h"
#import "HMSuperviseEnum.h"

typedef void(^cellTouch)(BOOL isTouchDown,BOOL isTouchUp);

@interface HMSuperviseDetailBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *heightBtn;

- (void)getCellTouchStatus:(cellTouch)block;

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isShowSolidLine:(BOOL)isShowSolidLine isShowRightLinr:(BOOL)isShowRightLine type:(SESuperviseType)type;

@end
