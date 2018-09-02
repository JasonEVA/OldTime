//
//  GooglePlaceFinderDAL.h
//  launcher
//
//  Created by William Zhang on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  google 搜索地址

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GooglePlaceFinderDALDelegate;

@interface GooglePlaceFinderDAL : NSObject

/**
 *  搜索地址
 *
 *  @param placeName 地址相关信息
 *  @param center    搜索位置坐标
 */
- (void)findPlacesNamed:(NSString *)placeName near:(CLLocationCoordinate2D)center;
- (void)findMore;

@property (nonatomic, weak) id<GooglePlaceFinderDALDelegate> delegate;

@end


@protocol GooglePlaceFinderDALDelegate <NSObject>

/** 获取地址，remain为是否还有 */
- (void)GooglePlaceFinderDALDelegateCallBack_FindPlaces:(NSArray *)places remain:(BOOL)remain;
- (void)GooglePlaceFinderDALDelegateCallBack_FindMorePlaces:(NSArray *)places remain:(BOOL)remain;
- (void)GooglePlaceFinderDALDelegateCallBack_FailWithError:(NSError *)error;

@end