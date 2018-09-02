//
//  RemoteNoticationHelper.m
//  HMClient
//
//  Created by yinqaun on 16/8/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RemoteNoticationHelper.h"
#import "HealthNoteItem.h"
#import "NSURL+QueryToDictionary.h"

static RemoteNoticationHelper* defaultNoticationHelper = nil;

@implementation RemoteNoticationHelper

+ (RemoteNoticationHelper*) defaultHelper
{
    if (!defaultNoticationHelper)
    {
        defaultNoticationHelper = [[RemoteNoticationHelper alloc]init];
    }
    return defaultNoticationHelper;
}

- (void) setAlertInfo:(NSDictionary*) alertInfo
{
    if (!alertInfo || ![alertInfo isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSString* routerUrlString = alertInfo[@"routerUrl"];
    if (routerUrlString && [routerUrlString isKindOfClass:[NSString class]] && routerUrlString.length > 0)
    {
        NSURL* routerUrl = [NSURL URLWithString:routerUrlString];
        if (routerUrl)
        {
            //按照URL进行跳转
            _routerURLString = routerUrlString;
            return;
        }
    }
    
    
    NSString* type = alertInfo[@"type"];
    if (!type || ![type isKindOfClass:[NSString class]] || 0 == type.length)
    {
        return;
    }
    
    
    if ([type isEqualToString:@"contentPush"])
    {
        
        //宣教
        NSString* contentId = alertInfo[@"contentId"];
        if (!contentId || ![contentId isKindOfClass:[NSString class]] || 0 == contentId.length)
        {
            return;
        }
        
        
        NSString* controllerName = @"HealthNoteDetailViewController";
        _notificationControllerName = controllerName;
        
        HealthNoteItem* item = [[HealthNoteItem alloc]init];
        [item setNotesId:contentId.integerValue];
        _controllerParam = item;
        
//        UIAlertView* alertview = [[UIAlertView alloc]initWithTitle:@"" message:@"setAlertInfo HealthNoteDetailViewController" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertview show];
    }
    else if ([type isEqualToString:@"review"] || [type isEqualToString:@"medicine"]) {
        // 用药复查，跳转到站内信
        NSString* controllerName = @"SEDoctorSiteMessageMainViewController";
        _notificationControllerName = controllerName;
    }
}

- (void) gotoNotificationController
{
    if (_routerURLString)
    {
        //根据URL进行跳转
        [HMViewControllerRouterHelper routerControllerWithUrlString:_routerURLString];
        _routerURLString = nil;
        _notificationControllerName = nil;
        _controllerParam = nil;
        return;
    }
    
    if (!_notificationControllerName)
    {
        return;
    }
//    NSString* alertMsg = [NSString stringWithFormat:@"gotoNotificationController %@", _notificationControllerName];
//    UIAlertView* alertview = [[UIAlertView alloc]initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertview show];
    [HMViewControllerManager createViewControllerWithControllerName:_notificationControllerName ControllerObject:_controllerParam];
    _notificationControllerName = nil;
    _controllerParam = nil;
}

@end
