//
//  RecentlyAppointmentModel.h
//  HMClient
//
//  Created by yinquan on 2017/10/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentlyAppointmentModel : NSObject

@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* staffTypeName;

@end
