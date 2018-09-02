//
//  DetectRecordOverallTimeView.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DetectTime_Daily = 1,
    DetectTime_Weekly,
    DetectTime_Monthly,
} DetectTimeType;

@protocol DetectRecordTimeViewDelegate <NSObject>

- (void) timeTypeSelected:(DetectTimeType) timetype;

@end

//整体趋势时间周期选择器
@interface DetectRecordOverallTimeView : UIView
{
    
}
@property (nonatomic, assign) DetectTimeType selectedTimeType;
@property (nonatomic, weak) id<DetectRecordTimeViewDelegate> delegate;

@end

//时段对比时间周期选择器
@interface DetectRecordContrastTimeView : UIView
{
    
}
@property (nonatomic, assign) DetectTimeType selectedTimeType;
@property (nonatomic, weak) id<DetectRecordTimeViewDelegate> delegate;
@end


