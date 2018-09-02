//
//  MessionInfo.h
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessionInfo : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSString* patientName;
@property (nonatomic, retain) NSString* patientPortrait;
@property (nonatomic, retain) NSString* messionName;
@property (nonatomic, retain) NSString* messionComment;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* messionDate;

@end
