//
//  HMRecentMedicalModel.h
//  HMDoctor
//
//  Created by lkl on 2017/3/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRecentMedicalModel : NSObject

//"DRUG_SPECIFICATIONS": "10mg*20片/盒",
//"DRUGS_FREQUENCY_NAME": "每日四次",
//"DRUG_DOSAGE": 3,
//"DRUG_DOSAGE_TITLE": "g",
//"DRUGS_USAGE_NAME": "静脉注射",
//"DRUG_NAME": "盐酸尼卡地平缓释片",
//"DRUG_ORG": "哈药六厂",

@property (nonatomic, copy) NSString *DRUG_SPECIFICATIONS;
@property (nonatomic, copy) NSString *DRUGS_FREQUENCY_NAME;
@property (nonatomic, copy) NSString *DRUG_DOSAGE;    //结局
@property (nonatomic, copy) NSString *DRUG_DOSAGE_TITLE;
@property (nonatomic, copy) NSString *DRUGS_USAGE_NAME;
@property (nonatomic, copy) NSString *DRUG_NAME;
@property (nonatomic, copy) NSString *DRUG_ORG;

@end
