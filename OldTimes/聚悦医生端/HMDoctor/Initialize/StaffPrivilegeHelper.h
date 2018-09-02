//
//  StaffPrivilegeHelper.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>  

@protocol StaffPrivilegeJSObjectProtocol <JSExport>

- (NSString*) getUserPermission:(NSString*) operate;

@end



#pragma mark - PrivilegeMode
//预警
static NSString* const kPrivilegeWarmMode = @"YJ";
//随访
static NSString* const kPrivilegeSurveyMode = @"SFRW";
//约诊
static NSString* const kPrivilegeAppointmentMode = @"YZ";
//建档
static NSString* const kPrivilegeCreateDocumentMode = @"JD";
//阶段评估
static NSString* const kPrivilegeAssessmentMode = @"JDPG";
//单次评估
static NSString* const kPrivilegeSingleAssessmentMode = @"DCPG";
//健康计划
static NSString* const kPrivilegeHealthPlanMode = @"JKJH";
//健康报告
static NSString* const kPrivilegeHealthReportMode = @"JKBG";

//发送随访
static NSString* const kPrivilegeCreateSurveytMode = @"FSSF";
//发送问诊
static NSString* const kPrivilegeCreateInterrogationtMode = @"WZ";
//开处方
static NSString* const kPrivilegeCreatePrescriptionMode = @"CF";
//发送关怀
static NSString* const kPrivilegeCreateCareMode = @"FSGH";
//发送评估
static NSString* const kPrivilegeCreateAccessmentMode = @"FSPG";
//查房
static NSString* const kPrivilegeRoundsMode = @"DCF";

#pragma mark - PrivilegeCode
//查看
static NSString* const kPrivilegeViewOperate = @"VIEW";
//处理
static NSString* const kPrivilegeProcessOperate = @"PROCESS";
//回复
static NSString* const kPrivilegeReplyOperate = @"REPLY";
//确认
static NSString* const kPrivilegeConfirmOperate = @"CONFIRM";
//选择疾病类型
static NSString* const kPrivilegeChooseIllOperate = @"CHOOSE-ILL";
//一般建档评估
static NSString* const kPrivilegeNormalAssessOperate = @"NORMAL-ASSESS";
//治疗风险评估
static NSString* const kPrivilegeTreatAssessOperate = @"TREAT-ASSESS";
//并发症风险评估
static NSString* const kPrivilegeComplicationAssessOperate = @"COMPLICATION-ASSESS";
//录入诊断
static NSString* const kPrivilegeAddDiagnoseOperate = @"ADD-DIAGNOSE";
//提交给医生
static NSString* const kPrivilegeSubmitOperate = @"SUBMIT";
//编辑
static NSString* const kPrivilegeEditOperate = @"EDIT";
//生成报告[REPORT]
static NSString* const kPrivilegeReportOperate = @"REPORT";


@interface StaffPrivilegeHelper : NSObject

+ (StaffPrivilegeHelper*) defaultHelper;

+ (void) savePrivilege:(NSDictionary*) dicPrivilege;

+ (BOOL) staffHasPrivilege:(NSString*) mode
                    Status:(NSInteger) status
               OperateCode:(NSString*) code;
+ (BOOL) staffHasPrivilegeWithOperateKey:(NSString *)operateKey;
@end

@interface StaffPrivilegeJSHelper : NSObject<StaffPrivilegeJSObjectProtocol>
{
    
}
@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;

@end
