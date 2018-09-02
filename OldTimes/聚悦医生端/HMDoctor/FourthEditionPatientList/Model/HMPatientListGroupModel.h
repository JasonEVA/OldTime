//
//  HMPatientListGroupModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第四版患者列表集团model

#import <Foundation/Foundation.h>

@interface HMPatientListGroupModel : NSObject
@property (nonatomic) NSInteger blocId; // 集团id
@property (nonatomic, copy) NSString *blocName; // 集团名
@property (nonatomic) BOOL isSelected; // 是否被选中

@end
