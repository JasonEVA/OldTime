//
//  AddressModel.h
//  launcher
//
//  Created by William Zhang on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define MAXLAT  200

@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy  ) NSString *fullAddress;
@property (nonatomic, copy  ) NSString *streetNumber;
@property (nonatomic, copy  ) NSString *route;
@property (nonatomic, copy  ) NSString *city;
@property (nonatomic, copy  ) NSString *stateCode;
@property (nonatomic, copy  ) NSString *postalCode;
@property (nonatomic, copy  ) NSString *countryName;

/**
 *  坐标位置    如果为（MAXLAT， MAXLAT）则说明搜索不到该位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)c;

+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type;

+ (instancetype)nullPlace;

@end
