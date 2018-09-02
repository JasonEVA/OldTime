//
//  HMTZMainDiagramDataModel.h
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMTZMainDiagramDataModel : NSObject
@property (nonatomic, copy) NSString *nowTz;      // 当前体重
@property (nonatomic, copy) NSString *lastTimeTz; // 比上次体重
@property (nonatomic, copy) NSString *b15dayTz;   // 比15天前体重
@property (nonatomic, copy) NSString *JWInitValue;  // 参照体重（设置理想体重时的体重，作为减肥参照）
@property (nonatomic, copy) NSString *aimValue;   // 理想体重
@end
