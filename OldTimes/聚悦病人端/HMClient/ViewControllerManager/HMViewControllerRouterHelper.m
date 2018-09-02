//
//  HMViewControllerRouterHelper.m
//  HMClient
//
//  Created by yinquan on 16/10/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMViewControllerRouterHelper.h"
#import "NSURL+EX.h"
//#import "ATModuleInteractor+HealthEducation.h"
#import "HealthEducationItem.h"
#import "HMWebViewController.h"
#import "AppointmentInfo.h"

#import "ServiceInfo.h"
#import "TeamInfo.h"
#import "SiteMessageSecondEditionMainListModel.h"
#import "ATModuleInteractor.h"
#import "NewSiteMessageItemListViewController.h"

//监测模块
static NSString* const kHMContrllerHealthyDetectModuleHost = @"healthyDetect";
static NSString* const kHMContrllerHealthEducationModuleHost = @"healthEducation"; // 健康宣教
static NSString* const kHMContrllerAppointmentModuleHost = @"appointment"; //约诊模块
static NSString* const kHMContrllerHealthClassRoomModuleHost = @"healthClassroom";  //健康课堂

static NSString* const kHMControllerHealthServiceModuleHost = @"healthService"; //服务

static NSString* const kHMControllerStaffTeameModuleHost = @"staffTeam"; //服务

static NSString* const kHMControllerPatientMsgModuleHost = @"patientMsg"; //站内信

@implementation HMViewControllerRouterHelper

+ (void) routerControllerWithUrlString:(NSString*) controllerUrlString
{
    if (!controllerUrlString || controllerUrlString.length == 0)
    {
        return;
    }
    //验证界面跳转参数是否合法
    NSURL* controllerUrl = [NSURL URLWithString:controllerUrlString];
    if (!controllerUrl)
    {
        return;
    }
    
    NSString* controllerScheme = controllerUrl.scheme;
    if (!controllerScheme || controllerScheme.length == 0)
    {
        return;
    }
    
    if ([controllerScheme isEqualToString:@"http"] || [controllerScheme isEqualToString:@"https"])
    {
//        HMWebViewController* webController = [[HMWebViewController alloc] initWithUrlString:controllerUrlString titelString:nil];
//        [self.navigationController pushViewController:webController animated:YES];
        
        [HMViewControllerManager createViewControllerWithControllerName:@"HMWebViewController" ControllerObject:controllerUrlString];
        return;

    }
//    if (![controllerScheme isEqualToString:kHMControllerScheme])
//    {
//        return;
//    }
    
    NSString* controllerHost = controllerUrl.host;
    if (!controllerHost || controllerHost.length == 0)
    {
        return;
    }
    
    if ([controllerHost isEqualToString:kHMContrllerHealthyDetectModuleHost])
    {
        // 监测模块的页面跳转
        [self routerToHealthyDetectController:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMContrllerHealthEducationModuleHost]) {
        // 健康宣教
        [self routerToHealthEducationModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMContrllerAppointmentModuleHost]) {
        // 约诊跳转
        [self routerToAppointmentModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMContrllerHealthClassRoomModuleHost])
    {
        // 健康课堂
        [self routerToHealthClassroomModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMControllerHealthServiceModuleHost])
    {
        // 健康服务
        [self routerToServiceModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMControllerStaffTeameModuleHost])
    {
        // 名医团队
        [self routerToStaffTeamModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMControllerPatientMsgModuleHost])
    {
        // 站内信
        [self routerToPatientMsgController:controllerUrl];
    }
}

// 跳转到站内信
+ (void) routerToPatientMsgController:(NSURL*) controllerUrl {
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }
    
    NSArray* pathComponents = [controllerPath componentsSeparatedByString:@"/"];
    if (!pathComponents || pathComponents.count < 2)
    {
        return;
    }
    
    NSString* controllerType = pathComponents[1];
    if (controllerType.length == 0) {
        return;
    }
    
    if ([controllerType isEqualToString:@"patientMsgDetail"]) {
        
        NSDictionary *parameters = [controllerUrl ats_convertURLQueryToDictionary];
        if (!parameters) {
            return;
        }
        
        NSString* typeCode = [parameters valueForKey:@"typeCode"];
        if (!typeCode || ![typeCode isKindOfClass:[NSString class]] || !typeCode.length)
        {
            return;
        }
        SiteMessageSecondEditionMainListModel *model = [SiteMessageSecondEditionMainListModel new];
        // 能收到推送肯定是打开状态
        model.status = 1;
        model.typeCode = typeCode;
        model.typeName = [self acquireSiteMessageDetailTitelWithTypeCode:typeCode];
        if (!model.typeName.length) {
            // 没有对应titel不跳转
            return;
        }
        
        [HMViewControllerManager createViewControllerWithControllerName:@"NewSiteMessageItemListViewController" ControllerObject:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kHMControllerPatientMsgModuleHost object:nil];
    }
}

+ (void) routerToHealthyDetectController:(NSURL*) controllerUrl
{
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }
    
    NSArray* pathComponents = [controllerPath componentsSeparatedByString:@"/"];
    if (!pathComponents || pathComponents.count < 3)
    {
        return;
    }
    
    NSString* controllerType = pathComponents[1];
    if (controllerType.length == 0) {
        return;
    }
    NSString* controllerSubType = pathComponents[2];
    if (controllerSubType.length == 0) {
        return;
    }
    if ([controllerType isEqualToString:@"detect"])
    {
        //跳转监测页面
        NSString* controllerName = nil;
        if ([controllerSubType isEqualToString:@"XY"])
        {
            //血压
            controllerName = @"BodyPressureDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"TZ"])
        {
            //体重
            controllerName = @"BodyWeightDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"XT"])
        {
            //血糖
            controllerName = @"BloodSugarDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"XD"])
        {
            //心电
            controllerName = @"ECGDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"XL"])
        {
            //心率
            controllerName = @"HeartRateDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"XZ"])
        {
            //血脂
            controllerName = @"BloodFatDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"OXY"])
        {
            //血氧
            controllerName = @"BloodOxygenDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"NL"])
        {
            //尿量
            controllerName = @"UrineVolumeDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"HX"])
        {
            //呼吸
            controllerName = @"BreathingDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"TEM"])
        {
            //体温
            controllerName = @"BodyTemperatureDetectStartViewController";
        }
        else if ([controllerSubType isEqualToString:@"FLSZ"])
        {
            //峰流速值
            controllerName = @"PEFDetectStartViewController";
        }
        if (!controllerName || 0 == controllerName.length)
        {
            return;
        }
        NSMutableDictionary* dicParam = nil;
        NSDictionary* dicQuery = [controllerUrl dictionaryWithQuery];
        if (dicQuery)
        {
            NSString* taskId = [dicQuery valueForKey:@"taskId"];
            if (taskId && taskId.length > 0)
            {
                dicParam = [NSMutableDictionary dictionary];
                [dicParam setValue:taskId forKey:@"taskId"];

            }
        }
        [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:dicParam];
    }
    if ([controllerType isEqualToString:@"detectResult"])
    {
        //跳转监测结果页面
        
    }
    
}

// 健康宣教
+ (void)routerToHealthEducationModuleWithURL:(NSURL *)URL {
    if (!URL) {
        return;
    }
    NSString *path = URL.path;
    if (!path) {
        return;
    }
    NSArray *temp = path.pathComponents;
    if (!temp.count) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != '/'"];
    
    NSArray *pathComponents = [temp filteredArrayUsingPredicate:predicate];
    if (!pathComponents.count) {
        return;
    }
    NSString *urlPath = pathComponents.firstObject;
    if ([urlPath isEqualToString:@"educationList"]) {
        // 宣教列表
        
    }
    else if ([urlPath isEqualToString:@"educationDetail"]) {
        // 宣教详情
        NSDictionary *parameters = [URL ats_convertURLQueryToDictionary];
        if (!parameters) {
            return;
        }
        NSNumber* numNotesId = [parameters valueForKey:@"notesId"];
        if (!numNotesId || [numNotesId isKindOfClass:[NSNumber class]])
        {
            return;
        }
        HealthNotesItem* notesItem = [[HealthNotesItem alloc] init];
        notesItem.notesId = numNotesId.integerValue;
        
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthyNotesDetailViewController" ControllerObject:notesItem];
    }
}

//健康课堂
+ (void)routerToHealthClassroomModuleWithURL:(NSURL *)URL
{
    if (!URL) {
        return;
    }
    NSString *path = URL.path;
    if (!path) {
        return;
    }
    NSArray *temp = path.pathComponents;
    if (!temp.count) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != '/'"];
    
    NSArray *pathComponents = [temp filteredArrayUsingPredicate:predicate];
    if (!pathComponents.count) {
        return;
    }
    NSString *urlPath = pathComponents.firstObject;
    if ([urlPath isEqualToString:@"classroomDetail"])
    {
        NSDictionary *parameters = [URL ats_convertURLQueryToDictionary];
        if (!parameters) {
            return;
        }
        NSNumber* numNotesId = [parameters valueForKey:@"classId"];
        if (!numNotesId || [numNotesId isKindOfClass:[NSNumber class]])
        {
            return;
        }
        HealthEducationItem* educationModel = [[HealthEducationItem alloc] init];
        educationModel.classId = numNotesId.integerValue;
        
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];

    }
}

//约诊跳转
+ (void)routerToAppointmentModuleWithURL:(NSURL *)controllerUrl {
    if (!controllerUrl) {
        return;
    }
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }
    
    NSArray *temp = controllerPath.pathComponents;
    if (!temp.count) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != '/'"];
    
    NSArray *pathComponents = [temp filteredArrayUsingPredicate:predicate];
    if (!pathComponents.count) {
        return;
    }
    NSString *urlPath = pathComponents.firstObject;
    
    if ([urlPath isEqualToString:@"appointList"])
    {
        //跳转到我的约诊列表
        [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:3];
        
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentListViewController" ControllerObject:nil];
        return;
    }
    else if ([urlPath isEqualToString:@"appointDetail"])
    {
        //跳转到约诊详情
        AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
        NSDictionary* dicQuery = [controllerUrl dictionaryWithQuery];
       
        if (dicQuery)
        {
            NSString* appointId = dicQuery[@"appointId"];
            [appointment setAppointId:appointId.integerValue];
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
        return;
    }
}

//服务跳转
+ (void) routerToServiceModuleWithURL:(NSURL *)controllerUrl
{
    if (!controllerUrl) {
        return;
    }
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }
    
    NSArray *temp = controllerPath.pathComponents;
    if (!temp.count) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != '/'"];
    
    NSArray *pathComponents = [temp filteredArrayUsingPredicate:predicate];
    if (!pathComponents.count) {
        return;
    }
    NSString *urlPath = pathComponents.firstObject;
    
    if ([urlPath isEqualToString:@"serviceDetail"])
    {
        //跳转服务详情界面
        NSDictionary* queryDict = [controllerUrl dictionaryWithQuery];
        NSString* upIdStr = [queryDict valueForKey:@"upId"];
        ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
        if (upIdStr) {
            [serviceInfo setUpId:upIdStr.integerValue];
        }
        
//        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceGoodsDetailStartViewController" ControllerObject:serviceInfo];
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
        return;
    }
    else if ([urlPath isEqualToString:@"serviceCategory"])
    {
        //跳转到服务分类列表详情
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
    }
}

//服务跳转
+ (void) routerToStaffTeamModuleWithURL:(NSURL *)controllerUrl
{
    if (!controllerUrl) {
        return;
    }
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }
    
    NSArray *temp = controllerPath.pathComponents;
    if (!temp.count) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != '/'"];
    
    NSArray *pathComponents = [temp filteredArrayUsingPredicate:predicate];
    if (!pathComponents.count) {
        return;
    }
    NSString *urlPath = pathComponents.firstObject;
    if ([urlPath isEqualToString:@"teamDetail"])
    {
        //跳转到团队详情页面
        TeamInfo* team = [[TeamInfo alloc] init];
        NSDictionary* queryDict = [controllerUrl dictionaryWithQuery];
        NSString* teamIdStr = [queryDict valueForKey:@"teamId"];
        if (teamIdStr)
        {
            [team setTeamId:teamIdStr.integerValue];
        }
        //跳转到团队界面
        [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
        return;
    }
    else if ([urlPath isEqualToString:@"staffDetail"])
    {
        //跳转到医生详情页面
        StaffInfo* staff = [[StaffInfo alloc] init];
        NSDictionary* queryDict = [controllerUrl dictionaryWithQuery];
        NSString* staffIdStr = [queryDict valueForKey:@"staffId"];
        if (staffIdStr)
        {
            [staff setStaffId:staffIdStr.integerValue];
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staff];
        return;
    }
    
}

+ (NSString *)acquireSiteMessageDetailTitelWithTypeCode:(NSString *)typeCode {
    if ([typeCode isEqualToString:@"JKNZ"]) {
        return @"健康闹钟";
    }
    else if ([typeCode isEqualToString:@"YSGH"]) {
        return @"医生关怀";
    }
    else if ([typeCode isEqualToString:@"WDYZ"]) {
        return @"我的约诊";
    }
    else if ([typeCode isEqualToString:@"JKJH"]) {
        return @"健康计划";
    }
    else if ([typeCode isEqualToString:@"JKPG"]) {
        return @"健康评估";
    }
    else if ([typeCode isEqualToString:@"JKBG"]) {
        return @"健康报告";
    }
    else if ([typeCode isEqualToString:@"XTXX"]) {
        return @"系统消息";
    }
    else if ([typeCode isEqualToString:@"JKKT"]) {
        return @"健康课堂";
    }
    else {
        return @"";
    }
}
@end
