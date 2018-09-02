//
//  HMViewControllerRouterHelper.m
//  HMClient
//
//  Created by yinquan on 16/10/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMViewControllerRouterHelper.h"

#import "AppointmentInfo.h"
#import "HealthEducationItem.h"

//监测模块
static NSString* const kHMContrllerHealthyDetectModuleHost = @"healthyDetect";
//监测预警模块
static NSString* const kHMContrllerHealthyWaringModuleHost = @"healthyWarming";
//约诊模块
static NSString* const kHMContrllerAppointmentModuleHost = @"appointment";
//健康课堂
static NSString* const kHMContrllerHealthClassRoomModuleHost = @"healthClassroom";
//站内信
static NSString* const kHMContrllerMcMsgHost = @"patientMsg";

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
    NSString* controllerHost = controllerUrl.host;
    if (!controllerHost || controllerHost.length == 0)
    {
        return;
    }
    
    if ([controllerHost isEqualToString:kHMContrllerHealthyDetectModuleHost])
    {
        //监测模块的页面跳转
        [self routerToHealthyDetectController:controllerUrl];
        return;
    }
    //jyhmdoctor://healthyWarming/warmingList
    else if ([controllerHost isEqualToString:kHMContrllerHealthyWaringModuleHost])
    {
        //监测预警模块的页面跳转
        [self routerToHealthyWarmingController:controllerUrl];
        return;
    }
    else if ([controllerHost isEqualToString:kHMContrllerAppointmentModuleHost])
    {
        //约诊模块界面跳转
        [self routerToAppointmentModuleWithURL:controllerUrl];
        return;
    }
    else if ([controllerHost isEqualToString:kHMContrllerHealthClassRoomModuleHost])
    {
        //健康课堂
        [self routerToHealthClassroomModuleWithURL:controllerUrl];
    }
    else if ([controllerHost isEqualToString:kHMContrllerMcMsgHost])
    {
        //站内信
        [HMViewControllerManager createViewControllerWithControllerName:@"SEDoctorSiteMessageMainViewController" ControllerObject:nil];
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
    }
    if ([controllerType isEqualToString:@"detectResult"])
    {
        //跳转监测结果页面
        
    }
    
}

+ (void) routerToHealthyWarmingController:(NSURL*) controllerUrl
{
    NSString* controllerPath = controllerUrl.path;
    if (!controllerPath || controllerPath.length == 0) {
        return;
    }

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
    
    if ([controllerType isEqualToString:@"warmingList"])
    {
        //跳转到监测预警任务列表
        NSString* controllerName = @"MainStartAlertStartViewController";
        [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
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
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
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
        
        NSDictionary* parameters = [URL dictionaryWithQuery];
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
@end
