//
//  HMChartCellBaseBackView.h
//  HMClient
//
//  Created by jasonwang on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSuperviseEachPointModel.h"
#import "HMSuperviseDetailModel.h"
#import "HMSuperviseEnum.h"

@interface HMChartCellBaseBackView : UIView

- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target;

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isShowSolidLine:(BOOL)isShowSolidLine isShowRightLinr:(BOOL)isShowRightLine type:(SESuperviseType)type;
@end
