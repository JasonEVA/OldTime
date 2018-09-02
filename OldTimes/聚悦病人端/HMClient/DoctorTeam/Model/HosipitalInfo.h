//
//  HosipitalInfo.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HosipitalInfo : NSObject

@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, retain) NSString* orgShortName;

@end

@interface DepartmentInfo : NSObject

@property (nonatomic, retain) NSString* depName;
@property (nonatomic, assign) NSInteger depId;
@end