//
//  relationGroupInfoModel.h
//  MintcodeIM
//
//  Created by kylehe on 16/3/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  

#import <Foundation/Foundation.h>

@interface relationGroupInfoModel : NSObject

@property(nonatomic, copy) NSNumber  *relationGroupId;

@property(nonatomic, copy) NSString  *appName;

@property(nonatomic, copy) NSString  *relationGroupName;

@property(nonatomic, copy) NSNumber  *defaultNameFlag;

@property(nonatomic, copy) NSNumber  *creataDate;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
