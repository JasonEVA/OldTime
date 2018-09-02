//
//  HMThirdEditionPatitentDiagnoseModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者信息 诊断 model

#import <Foundation/Foundation.h>

@interface HMThirdEditionPatitentDiagnoseModel : NSObject
@property (nonatomic, copy) NSString *diseaseName;      //诊断内容
@property (nonatomic) NSInteger orderIndex;   //1为主诊断 其他为次要诊断
@end
