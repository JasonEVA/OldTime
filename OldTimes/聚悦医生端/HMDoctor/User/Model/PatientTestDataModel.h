//
//  PatientTestDataModel.h
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientTestDataModel : NSObject

@property(nonatomic, copy) NSString  *testValue;

@property(nonatomic, copy) NSString  *kpiCode;

@property(nonatomic, copy) NSString  *kpoiName;

@property(nonatomic, copy) NSString  *testTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
