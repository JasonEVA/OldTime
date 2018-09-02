//
//  HMCheckPatientServiceManager.h
//  HMDoctor
//
//  Created by jasonwang on 2017/2/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//  用于判断病人服务状态 类（同病人端判断接口）

#import <Foundation/Foundation.h>

//hasService 是否订购服务
typedef NS_ENUM(NSUInteger, PatientServiceStatus) {
    
    PatientServiceStatus_YES = 1,              //Y已订购
    
    PatientServiceStatus_NO  = 2               //N未订购
};

//privilege 病人权限
typedef NS_ENUM(NSUInteger, PatientPrivilege) {
    
    PatientPrivilege_YZ,              //约诊
    
    PatientPrivilege_JKJH,            //健康计划
    
    PatientPrivilege_JKBG,            //健康报告
    
    PatientPrivilege_JKDA,            //健康档案
    
    PatientPrivilege_TWZX             //图文咨询
};

typedef void(^managerCompletion)(PatientServiceStatus serviceStatus,NSArray *privilegeArray, BOOL success);

@interface HMCheckPatientServiceManager : NSObject
+ (HMCheckPatientServiceManager *)shareManager;
- (void)checkPatientServiceWithUserId:(NSString *)userId completion:(managerCompletion)completion;
@end


/*
"business_code": "SUCCESS",
"business_message": "操作成功!",
"result": {
    "hasService": "Y/N", Y已订购，N未订购
    "privilege": {
        "YZ": "约诊",
        "JKJH": "健康计划",
        "JKBG": "健康报告",
        "JKDA": "健康档案",
        "TWZX": "图文咨询"
    }
}
}
*/
