//
//  AppointStaffModel.h
//  HMClient
//
//  Created by yinquan on 16/11/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointStaffModel : NSObject

@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* staffTypeName;
@property (nonatomic, retain) NSString* imgUrl;

@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, assign) NSInteger remainNum;
@property (nonatomic, assign) NSInteger serviceDetId;

@end
