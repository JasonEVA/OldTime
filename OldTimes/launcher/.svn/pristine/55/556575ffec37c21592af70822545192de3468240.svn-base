//
//  PlaceModel.h
//  launcher
//
//  Created by William Zhang on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  google 地址搜索

#import "AddressModel.h"

@interface PlaceModel : AddressModel

@property (nonatomic, copy  ) NSString *googleId;
@property (nonatomic, copy  ) NSString *googleIconPath;
@property (nonatomic, copy  ) NSString *googleRef;
@property (nonatomic, assign) double   rating;
@property (nonatomic, strong) NSArray  *types;

/**
 *  无法搜索到位置的地址
 *
 *  @param name 地址名称
 *
 *  @return id
 */
- (instancetype)initWithName:(NSString *)name;

@end
