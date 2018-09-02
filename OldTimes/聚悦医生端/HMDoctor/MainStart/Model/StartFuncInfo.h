//
//  StartFuncInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //患者管理
//    StartFunc_Patients,         //我的患者
    StartFunc_PatientsFree,     // 随访患者
    StartFunc_PatientsCharge,   // 收费患者
    StartFunc_Prescription,     //开处方
    StartFunc_Interrogation,    //问诊表
    StartFunc_Survey,           //随访表
    StartFunc_Concern,          //医生关怀
    
    StartFunc_Examination,      //检验检查

    //工作组
    StartFunc_Workgroup,        //工作组
    
    //工具库
    StartFunc_Format,           //医学公式
    StartFunc_Medication,       //用药助手
    StartFunc_Disease,          //疾病指南
    StartFunc_CaseHistory,      //病历案例
    StartFunc_Nutrition,        //营养库
    StartFunc_MedicalInformation,        //医疗咨询
    StartFunc_HosiptionInformation,        //院内咨询
    
    StartFunc_Custom = 0xFFF,           //自定义
} StartFuncIndex;

@interface StartFuncInfo : NSObject
<NSCoding>
{
    
}

@property (nonatomic, assign) NSInteger funcIndex;
@property (nonatomic, assign) BOOL isMust;          //是否必须
@property (nonatomic, assign) BOOL isValid;         //是否已开通

@property (nonatomic, retain) NSString* funcName;
@property (nonatomic, retain) NSString* funcIconName;

@end

@interface StartFuncInfoHelper : NSObject
{
    
}

@property (nonatomic, retain) NSArray* startFuncItems;

@property (nonatomic, retain) NSArray* modifyFuncItems;

+ (StartFuncInfoHelper*) defaultHelper;
@end
