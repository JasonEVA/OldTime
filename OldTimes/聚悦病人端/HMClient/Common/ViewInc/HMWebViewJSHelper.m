//
//  WebViewJSHelper.m
//  HMClient
//
//  Created by yinquan on 16/9/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMWebViewJSHelper.h"
#import "MWPhotoBrowser.h"
#import "ServiceInfo.h"
#import "ServiceOrder.h"
#import "HMSecondEditionServiceOrderConfrimViewController.h"
#import "ServiceNeedMsg.h"

@interface FreeOrderParam : NSObject

@property (nonatomic, retain) NSString* upId;
@property (nonatomic, retain) NSString* orderBusinessDets;
@property (nonatomic, retain) NSString* needMsgData;
@property (nonatomic, retain) NSString* recommendUserId;
@end

@implementation FreeOrderParam


@end

@interface HMWebViewJSHelper ()
<TaskObserver>
{
    ServiceOrder* serviceOrder;
    
}
@end

@implementation HMWebViewJSHelper

- (NSString*) getUserPermission:(NSString*) operate
{
    return @"N";
}

- (void) imageClicked:(NSString*) imageUrl
{
    if (!self.controller) {
        return;
    }
    if (!imageUrl)
    {
        return;
    }
    MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
    MWPhotoBrowser* browser = [[MWPhotoBrowser alloc]initWithPhotos:@[photo]];
    browser.displayActionButton = NO;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [browser reloadData];
    //    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    
    [self.controller presentViewController:nc animated:YES completion:nil];
}

- (void)readyServiceOrder:(NSString*) upId
        orderBusinessDets:(NSString*) orderBusinessDets
              needMsgData:(NSString*) needMsgData
                    price:(NSString *)price
          recommendUserId:(NSString*) recommendUserId
{
    
    
    if (price.floatValue == 0) {
        //免费服务，不需要支付，直接创建订单
        FreeOrderParam* param = [[FreeOrderParam alloc] init];
        param.upId = upId;
        param.orderBusinessDets = orderBusinessDets;
        param.needMsgData = needMsgData;
        if (recommendUserId && recommendUserId.length > 0 && [recommendUserId isPureInt])
        {
            param.recommendUserId = recommendUserId;
        }
        
        
        [self performSelectorOnMainThread:@selector(createFreeOrderWithParam:) withObject:param waitUntilDone:NO];
        
    }
    else
    {
        //需要支付，跳转支付界面
        HMSecondEditionServiceOrderConfrimViewController *VC = [[HMSecondEditionServiceOrderConfrimViewController alloc] initWithServiceDetail:_serviceDetail];
        NSMutableArray* needMsgItems;
        if (needMsgData && needMsgData.length > 0)
        {
            id msgData = [NSObject JSONValue:needMsgData];
            if (msgData && [msgData isKindOfClass:[NSArray class]])
            {
                needMsgItems = [NSMutableArray array];
                [msgData enumerateObjectsUsingBlock:^(NSDictionary* msgDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    ServiceNeedMsg* needmsg = [ServiceNeedMsg mj_objectWithKeyValues:msgDictionary];
                    [needMsgItems addObject:needmsg];
                }];
                
            }
        }
        if (needMsgData) {
            [VC setNeedMsgItems:needMsgItems];
        }
        if (recommendUserId && recommendUserId.length > 0 && [recommendUserId isPureInt]) {
            [VC setRecommendUserId:recommendUserId];
        }
        
        [self.controller.navigationController pushViewController:VC animated:YES];
    }
}

- (void) createFreeOrderWithParam:(FreeOrderParam*) param
{
    [self createFreeOrder:param.upId orderBusinessDets:param.orderBusinessDets needMsgData:param.needMsgData recommendUserId:param.recommendUserId];
}

- (void) createFreeOrder:(NSString*) upId
       orderBusinessDets:(NSString*) orderBusinessDets
             needMsgData:(NSString*) needMsgData
         recommendUserId:(NSString*) recommendUserId
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger iUpId = upId.integerValue;
    [dicPost setValue:[NSNumber numberWithInteger:iUpId]  forKey:@"upId"];
    [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
    [dicPost setValue:@"IOS" forKey:@"sourceCode"];
    
    if (orderBusinessDets && orderBusinessDets.length > 0)
    {
        id options = [NSObject JSONValue:orderBusinessDets];
        if (options)
        {
            [dicPost setValue:options forKey:@"orderBusinessDets"];
        }
    }
    
    if (needMsgData && needMsgData.length > 0)
    {
        id msgData = [NSObject JSONValue:needMsgData];
        if (msgData)
        {
            [dicPost setValue:msgData forKey:@"needMsgData"];
        }
    }
    
    if (recommendUserId && recommendUserId.length > 0 && [recommendUserId isPureInt])
    {
        [dicPost setValue:recommendUserId forKey:@"recommendUserId"];
    }
    
    [self.controller.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.controller.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self.controller showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (serviceOrder)
        {
            //跳转到订单详情页面
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController"
                                                           FromControllerId:nil
                                                           ControllerObject:[NSString stringWithFormat:@"%ld", serviceOrder.orderId]];
        }
        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
    }
}

#pragma mark - 平安支付
- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            serviceOrder = (ServiceOrder*) taskResult;
        }
    }
}

- (NSDictionary *)getOrigParams {
    NSDictionary *dict = self.parmsModel.mj_keyValues;
    return dict;
}
- (void)closeWeb {
    if ([self.delegate respondsToSelector:@selector(HMPingAnPayJSModelDlegateCallBack_pop)]) {
        [self.delegate HMPingAnPayJSModelDlegateCallBack_pop];
    }
}
@end
