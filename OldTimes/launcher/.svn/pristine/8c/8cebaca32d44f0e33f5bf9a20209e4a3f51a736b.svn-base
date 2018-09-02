//
//  ATClockViewBL.h
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATClockViewBL : NSObject

/**  根据2个经纬度计算距离  */
- (double)lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
/** IOS 计算两个经纬度之间的距离 */
-(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

/**
 *  计算打卡位置是否在指定位置
 *
 *  @param cLat     用户当前的位置纬度
 *  @param cLog     用户当前的位置经度
 *  @param dLat     指定位置纬度
 *  @param dLog     指定位置经度
 *  @param distance 打卡规定的距离
 *
 *  @return Bool
 */
- (BOOL)calculateWhetherInDesignatedAreasWithCLat:(double)cLat cLog:(double)cLog designatedLat:(double)dLat designatedLog:(double)dLog distance:(CGFloat)distance;

@end
