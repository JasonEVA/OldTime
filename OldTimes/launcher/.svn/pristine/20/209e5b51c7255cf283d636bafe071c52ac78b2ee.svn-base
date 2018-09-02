//
//  ATStaticModel.h
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ATStaticOut) {
    ATStaticNoOut,
    ATStaticIsOut
};

@interface ATStaticModel : NSObject

/** 日期时间戳 */
@property (nonatomic, assign) double Date;
/** 上班打卡时间戳 */
@property (nonatomic, assign) double OnWorkTime;
/** 上班打卡备注 */
@property (nonatomic, copy) NSString *OnWorkRemark;
/** 上班打卡状态 */
@property (nonatomic, assign) NSInteger OnWorkStatus;
/** 下班打卡时间戳 */
@property (nonatomic, assign) double OffWorkTime;
/** 下班打卡备注 */
@property (nonatomic, copy) NSString *OffWorkRemark;
/** 下班打卡状态 */
@property (nonatomic, assign) NSInteger OffWorkStatus;
/** 是否外出*/
@property (nonatomic, assign) ATStaticOut IsOut;

/** 上班打卡地点是否符合(0:不符合;1:符合) */
@property (nonatomic, assign) NSInteger OnWorkIsLoc;
/** 下班打卡地点是否符合(0:不符合;1:符合) */
@property (nonatomic, assign) NSInteger OffWorkIsLoc;

/** 上班是否异常【0-否;1-是】*/
@property (nonatomic, assign) NSInteger OnWorkIsExcep;
/** 下班是否异常【0-否;1-是】*/
@property (nonatomic, assign) NSInteger OffWorkIsExcep;



@end
