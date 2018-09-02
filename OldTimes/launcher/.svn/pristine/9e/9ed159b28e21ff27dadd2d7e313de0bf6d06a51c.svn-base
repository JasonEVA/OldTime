//
//  ATPunchCardModel.h
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATPunchCardModel : NSObject

@property (nonatomic, copy) NSString *Lat;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *Lon;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *SignId;
@property (nonatomic, strong) NSNumber *Time;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, strong) NSNumber *IsLocation;
@property (nonatomic, strong) NSNumber *SignType; //!< 考勤类型【0-未标记;1-上班;2-下班;3-外勤】

//@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, assign) BOOL isAbnormal; //!< 是否异常打卡
@property (nonatomic, assign) BOOL isFirstModel; //!< 是否是第一个模型
@property (nonatomic, assign) CGFloat cellHeight;

/** 判断打卡是否异常 */
- (void)determineWhetherAbnormalWithOnWorkTime:(NSNumber *)onWorkTime offWorkTime:(NSNumber *)offWorkTime;

@end
