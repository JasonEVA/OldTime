//
//  PatientModel.h
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PatientTestDataModel;
@interface PatientModel : NSObject


@property(nonatomic, strong) NSNumber  *age;
@property(nonatomic, copy) NSString   *illName;
@property(nonatomic, copy) NSString   *imgUrl;
@property(nonatomic, copy) NSString  *sex;
@property(nonatomic, copy) NSString  *userID;
@property(nonatomic, copy) NSString  *userName;
@property(nonatomic, strong) PatientTestDataModel  *userTestDatas;

- (instancetype)initWithDitc:(NSDictionary *)dict;

@end
