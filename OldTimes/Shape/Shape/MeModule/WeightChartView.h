//
//  WeightChartView.h
//  Shape
//
//  Created by Andrew Shen on 15/11/17.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Weight;
@interface WeightChartView : UIView

- (void)setChartDateComponents:(NSArray<NSDateComponents *> *)components weightData:(NSArray<Weight *> *)weightData;
@end
