//
//  ClientHelper.h
//  AFRequsetDemon
//
//  Created by YinQ on 15/4/16.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PlantformConfig.h"

//http://adam1212.vicp.net:9999/uniqueComservice/

//测试环境
#ifdef YuYouNetowrk
//测试环境
#define kBaseUrl    @"http://182.92.8.118"
#define kZJKEvaluationDataBaseUrl       @"http://182.92.8.118:94"
#define kZJKBaseUrl         [NSString stringWithFormat:@"%@:10018/uniqueComservice2/", kBaseUrl]
#define kZKSRZBaseUrl       [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@":10009/jy"]

#elif kSimulation_Netwrok
//仿真
//#define kBaseUrl    @"http://fz.joyjk.com/"
#define kBaseUrl    @"http://www.joyjk.cn/"

#define kZJKBaseUrl         [NSString stringWithFormat:@"%@/uniqueComservice2/", kBaseUrl]
#define kZJKEvaluationDataBaseUrl       [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"jdh5"]

#define kZKSRZBaseUrl       [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"/jy"]

#else

#define kBaseUrl    @"http://www.juyuejk.com"

#define kZJKBaseUrl         [NSString stringWithFormat:@"%@/uniqueComservice2/", kBaseUrl]
#define kZJKEvaluationDataBaseUrl       [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"/jdh5"]
#define kZKSRZBaseUrl       [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"/jy"]

#endif




//聚悦平台
#ifdef kPlantform_JuYue
#ifdef YuYouNetowrk

#define kZJKHealthDataBaseUrl        [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@":10009/jy"]

//#define kZJKHealthDataBaseUrl       @"http://10.0.0.134:8080"
#define kBaseShopUrl @"http://test.joyjk.com/shop/jkglsc/newc"

#define HMVersions                  @"(内测版)"
#elif kSimulation_Netwrok
//仿真环境
//#define kZJKHealthDataBaseUrl        [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"jdh5/jy"]
#define kZJKHealthDataBaseUrl        [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"/jy"]
#define kBaseShopUrl @"http://www.joyjk.cn/shop/jkglsc/newc"
#define HMVersions                  @"(仿真版)"
#else
#define kZJKHealthDataBaseUrl        [[NSString stringWithFormat:@"%@", kBaseUrl] stringByAppendingString:@"/jy"]
#define kBaseShopUrl @"http://www.juyuejk.com/shop/jkglsc/newc"
#define HMVersions                  @""
#endif
#endif

//重医平台
#ifdef kPlantform_ChongYi
#ifdef YuYouNetowrk
#define kZJKHealthDataBaseUrl       @"http://10.0.0.222:10007/cy"
#else
#define kZJKHealthDataBaseUrl       @"http://123.56.74.172:10031/cy"
#endif
#endif

//西南平台
#ifdef kPlantform_XiNan
#ifdef YuYouNetowrk
#define kZJKHealthDataBaseUrl       @"http://10.0.0.222:10007/xn"
#else
#define kZJKHealthDataBaseUrl       @"http://123.56.74.172:10032/xn"
#endif
#endif




#define kZJKBaseUrlPath     @"base.do?do=httpInterface&module=%@&method="



#define kZJKBasePostPath     [NSString stringWithFormat:@"%@%@", kZJKBaseUrl, kZJKBaseUrlPath]
#define kZJKPostIamgeUrl     [NSString stringWithFormat:@"%@%@", kZJKBaseUrl, @"base.do?method=uploadPic"]

#define kZJKPostFileUrl     [NSString stringWithFormat:@"%@%@", kZJKBaseUrl, @"base.do?method=uploadFile"]
//#define kZJKPostIamgeUrl     @"http://adam1212.vicp.net:9999/uniqueComservice/base.do?method=uploadPic"

typedef void (^SuccessBlock)(NSURLSessionDataTask * task , id responseObject);
typedef void (^FailedBlock)(NSURLSessionDataTask * task , NSError *error);

@interface ClientHelper : NSObject

+ (NSString*) postBaseUrl:(NSString*)method;
+ (NSString*) postUserServiceUrl:(NSString*)method;
+ (NSString*) postRelationServiceUrl:(NSString*) method;
+ (NSString*) postRelationApplyServiceUrl:(NSString*) method;
+ (NSString*) postOrgServiceUrl:(NSString*) method;
+ (NSString*) postNoticeServiceUrl:(NSString*) method;
+ (NSString*) postDepServiceUrl:(NSString*) method;
+ (NSString*) postStaffServiceUrl:(NSString*) method;
+ (NSString*) postScheduleServiceUrl:(NSString*) method;
+ (NSString*) postRegServiceUrl:(NSString*) method;
+ (NSString*) postOrderServiceUrl:(NSString*) method;
+ (NSString*) postGuideServiceUrl:(NSString*) method;
+ (NSString*) postLucenceServiceUrl:(NSString*) method;

+(NSString *) postHyperTestServiceUrl:(NSString *)method;
+(NSString *) postHealthServiceUrl:(NSString *)method;
+(NSString *) postECGServiceUrl:(NSString *)method;
+(NSString *) postWeightTestServiceUrl:(NSString *)method;
+(NSString *) postGlucoseServiceUrl:(NSString *)method;
+ (NSString *)postSystemServiceUrl:(NSString *)method;

+(NSString *)postActionStatServiceUrl:(NSString *)method;
//+ (NSString*) postIMUserServiceUrl:(NSString*) method;

+ (NSString *)postWorkTaskServiceUrl:(NSString *)method;
+ (NSString*) postPatientRoundsService:(NSString*) method;
+ (NSString*) postSurveryServiceUrl:(NSString*) method;
+ (NSString*) postAppointmetnServiceUrl:(NSString*) method;
+ (NSString*) postUserServicePoServiceUrl:(NSString*) method;

+ (NSString*) postUserTestDataService:(NSString*) method;
+ (NSString*) postUserScheduleServiceUrl:(NSString*) method;
+ (NSString *)postReceiptMsgServiceURL:(NSString *)method;
+ (NSString*) postDoctorMsgService:(NSString*) method;

+ (NSString*) postOrgTeamServiceUrl:(NSString*) method;
+ (NSString*) postUserTestDataServiceUrl:(NSString*) method;
+ (NSString*) postHealthPlan2ServiceServiceUrl:(NSString*) method;
+ (NSString*) postHealthyPlanServiceServiceUrl:(NSString*) method;
+ (NSString*) postHealthyPlanTemplateServiceUrl:(NSString*) method;
+ (NSString*) postHealthyPlanUserListServiceServiceUrl:(NSString*) method;
+ (NSString*) postUserHealtReportServiceUrl:(NSString*) method;
+ (NSString*) postAssessmentServiceUrl:(NSString*) method;
+ (NSString*) postArchiveTemplateServiceUrl:(NSString*) method;
+ (NSString *)postUserIllnessService:(NSString *)method;

+ (NSString*) postUser2ServiceUrl:(NSString*) method;
+ (NSString*) postUserAccountServiceUrl:(NSString*) method;
+ (NSString *)postcommonHealthyPlanService:(NSString *)method;
+ (NSString*) postRecipeServiceUrl:(NSString*) method;
+ (NSString*) postMcClassService:(NSString*) method;
+ (NSString*) postUniqueComservice2Url:(NSString*) method;
+ (NSString*) postUserTestOptionService:(NSString*) method;

+ (NSString*) postProductService:(NSString*) method;

+ (NSMutableDictionary*) buildCommonHttpParam;

+ (NSString*) postDealWarningServiceUrl:(NSString*) method;

+ (NSString *)postuserServiceEvaluateURL:(NSString *)method;
+ (NSString *)postarchivesAssessmentServiceURL:(NSString *)method;
+ (NSString *)postarchiveTemplateServiceURL:(NSString *)method;

+ (NSString *)postassessmentServiceURL:(NSString *)method;
+ (NSString*) postAdmissionService:(NSString*) method;

+ (NSString *)postWorkBenchPatientServiceURL:(NSString *)method;
+ (NSString*) postMcClassServiceUrl:(NSString*) method;
+ (NSString *)postDoctorAttentionServiceURL:(NSString *)method;
+ (NSString *)postFastInGroupService:(NSString *)method;

+ (NSString*) postUserTestRelationService:(NSString*) method;

+ (NSString*) serviceName:(NSString*) aRequestName;

+ (NSString *)postadmissionAssessAppService:(NSString *)method;
+ (NSString *)postUserChartService:(NSString *)method;
+ (void) printDictionary:(NSDictionary*) aDict;

@end
