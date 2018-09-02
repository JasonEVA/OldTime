//
//  HMThirdEditionPatitentHealthRiskModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者信息 健康风险 model

#import <Foundation/Foundation.h>

@interface HMThirdEditionPatitentHealthRiskModel : NSObject
@property (nonatomic, copy) NSArray *assessResult;      //内容
@property (nonatomic) NSInteger moudleType;             //编号
@property (nonatomic, copy) NSString *moudleTypeName;   //名称
@end
