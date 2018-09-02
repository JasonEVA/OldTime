//
//  ClientHelper.m
//  AFRequsetDemon
//
//  Created by YinQ on 15/4/16.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "ClientHelper.h"
//#import "ZJKUserHelper.h"
#import "PlantformConfig.h"

@implementation ClientHelper

#define kZJKDeviceTokenKehy     @"deviceToken"
#define kZJKCallTypeKey         @"calltype"
#define kZJKOrgGroupCode        @"orgGroupCode"
#define kZJKVersionKey          @"appVersion"
#define kZJKUserIdKey           @"userId"
#define kZJKOperateUserIdKey    @"operatorUserId"


+ (NSString*) postBaseUrl:(NSString*)method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"baseService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postUserServiceUrl:(NSString*)method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postRelationServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userDoctorRelationService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postRelationApplyServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userDoctorRelationApplyService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postOrgServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"orgService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postNoticeServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"notesService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postMcClassServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"mcClassService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postDepServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"depService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postScheduleServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"scheduleService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postReceiptMsgService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"receiptMsgService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postStaffServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"staffService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postRegServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"regService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postUserScheduleServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userScheduleService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postPatientRoundsService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"patientRoundsService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postOrderServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"orderService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postOrgTeamServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"orgTeamService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postGuideServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"guideService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postLucenceServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"lucenceQuery"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *)postHyperTestServiceUrl:(NSString *)method{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"hyperTestService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *) postHealthServiceUrl:(NSString *)method{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"healthService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postUserTestDataService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userTestDataService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postWeatherService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"weatherService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postUserTestRelationService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userTestRelationService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *) postGlucoseServiceUrl:(NSString *)method{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userBloodSugarTestService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *)postSystemServiceUrl:(NSString *)method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"systemService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *)postActionStatServiceUrl:(NSString *)method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"actionStatService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postUser2ServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"user2Service"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;

}

//签到
+ (NSString*) postAttendanceServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"attendanceService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

//积分
+ (NSString*) postIntegralServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"integralService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *) postECGServiceUrl:(NSString *)method{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userElectrocardioTestService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+(NSString *) postWeightTestServiceUrl:(NSString *)method{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userWeightTestService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postSurveryServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"surveryService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) postMonitorService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"monitorService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}
+ (NSString*) postUserTestPlanTaskService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userTestPlanTaskService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) postAppointmetnServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"appointService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) postProductTypeServiceServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"productTypeService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) posuserServicePoServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userServicePoService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) postePayService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"ePayService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
    
}

+ (NSString*) postProductService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"productService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postHealthPlan2Service:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"healthPlan2Service"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postExerciseService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"exerciseService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postUserTestOptionService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userTestOptionService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postPatientMsgService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"patientMsgService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postAppPatients:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"appPatients"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}
+ (NSString*) postUserFavorService:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userFavorService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postRecipeServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"recipeService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}


+ (NSString*) postUserHealthyReportServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userHealthyReportService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString*) postCommonHealthyPlanServiceUrl:(NSString*) method
{
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"commonHealthyPlanService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString *)postuserServiceEvaluateURL:(NSString *)method {
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userServiceEvaluateService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString *)postarchivesAssessmentServiceURL:(NSString *)method {
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"archivesAssessmentService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString *)postUserChartService:(NSString *)method {
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"userChartService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSString *)postarchiveTemplateServiceURL:(NSString *)method {
    NSString* sBaseUrl = [NSString stringWithFormat:kZJKBasePostPath, @"archiveTemplateService"];
    NSString* sUrl = [sBaseUrl stringByAppendingString:method];
    return sUrl;
}

+ (NSMutableDictionary*) buildCommonHttpParam
{
    NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];
    NSString* token = [self deviceToken];
    if (token)
    {
        [dictParam setValue:token forKey:kZJKDeviceTokenKehy];
    }
    
    NSString* version = [self appVersion];
    if (version)
    {
        [dictParam setValue:version forKey:kZJKVersionKey];
    }
    
    NSInteger calltype = [PlantformConfig calltype];
    
    [dictParam setValue:[NSString stringWithFormat:@"%ld", calltype] forKey:kZJKCallTypeKey];
    [dictParam setObject:[PlantformConfig plantformCode] forKey:kZJKOrgGroupCode];
    
    NSString* deviceName = [[UIDevice currentDevice] model];
    [dictParam setObject:deviceName forKey:@"phoneModel"];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    phoneVersion = [NSString stringWithFormat:@"iOS%@", phoneVersion];
    [dictParam setObject:phoneVersion forKey:@"phoneSystem"];
    
    //用户ID
    UserInfoHelper* helper = [UserInfoHelper defaultHelper];
    UserInfo* user = [helper currentUserInfo];
    if (user)
    {
        [dictParam setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:kZJKUserIdKey];
        [dictParam setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:kZJKOperateUserIdKey];
    }
    
    return dictParam;
}

+ (NSString*) deviceToken
{
    NSString* savedToken = [[NSUserDefaults standardUserDefaults] objectForKey:kIOSDeviceTokenKey];
    return savedToken;
}

+ (NSString*) appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    //NSString* sVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    return app_Version;
}

+ (NSString*) serviceName:(NSString*) aRequestName
{
    if (!aRequestName || 0 == aRequestName.length) {
        return nil;
    }
    NSString* sPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ServiceName.plist"];
    NSDictionary* dictServiceName = [NSDictionary dictionaryWithContentsOfFile:sPath];
    if (!dictServiceName)
    {
        return nil;
    }
    
    NSDictionary* dicService = [dictServiceName valueForKey:aRequestName];
    if (!dicService)
    {
        return nil;
    }
    
    NSString* sServiceName = [dicService valueForKey:@"servicename"];
    return sServiceName;
}

+ (void) printDictionary:(NSDictionary*) aDict
{
    if (!aDict || ![aDict isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSArray* keys = [aDict allKeys];
    NSLog(@"printDictionary");
    for (NSString* key in keys)
    {
        NSLog(@"key=%@ value=%@", key, [aDict valueForKey:key]);
    }
}

@end
