//
//  UnifieldResultCodeManager.m
//  PalmDoctorDR
//
//  Created by Lars Chen on 15/4/15.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "UnifiedResultCodeManager.h"
#import "MyDefine.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"

static NSString *const kCode = @"code";

@interface UnifiedResultCodeManager (){
    UIAlertView *alertView;
}

@end

@implementation UnifiedResultCodeManager
+(UnifiedResultCodeManager *)share
{
    static UnifiedResultCodeManager *resultCodeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resultCodeManager = [[UnifiedResultCodeManager alloc] init];

    });
    return resultCodeManager;
}

- (BOOL)manageResultCode:(NSDictionary *)dictResult
{
    NSInteger resultCode = [[dictResult safeValueForKey:kCode] integerValue];

    BOOL isSucess = NO;
    NSInteger module = resultCode / 1000;
    switch (module)
    {
        case 1:
            // 操作失败     8100
            
            break;
            
        case 2:
            // 操作成功
            isSucess = YES;
            break;
            
        case 3:
            // 失败
            [self ErrorWithCode:resultCode];
            break;
            
        case 4:
            [self errorNeedLoginWithCode:resultCode];
            break;
            
        default:
            // 失败
            [self ErrorWithCode:resultCode];
            break;
    }

    return isSucess;
}

#pragma mark - 分模块处理
// 操作成功但需要客户端进行操作1
- (void)successWithHandle:(NSInteger)code requestID:(NSString *)strId
{
}

// 操作失败
- (void)errorNeedLoginWithCode:(NSInteger)code
{
    // 重新登录
    if(alertView){
        [alertView dismissWithClickedButtonIndex:2 animated:YES];
        alertView=nil;
    }
    NSString *errorReason;
    switch (code) {
        case 1400:
            errorReason = ERROR1400;
            alertView = [[UIAlertView alloc] initWithTitle:nil message:errorReason delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles: nil];
            [alertView show];
            break;
            
        case 1401:
            errorReason = ERROR1401;
            break;
            
        default:
            errorReason = ERROROTHER;
            break;
    }
}

// 操作失败
- (void)ErrorWithCode:(NSInteger)errorCode
{
    NSString *errorReason;
    switch (errorCode) {
        case 1300:
            errorReason = ERROR1300;
            break;
            
        case 1301:
            errorReason = ERROR1301;
            break;
            
        case 1302:
            errorReason = ERROR1302;
            break;
            
        case 1303:
            errorReason = ERROR1303;
            break;
            
        case 1304:
            errorReason = ERROR1304;
            break;
            
        case 1305:
            errorReason = ERROR1305;
            break;
            
        case 1306:
            errorReason = ERROR1306;
            break;
            
        case 1307:
            errorReason = ERROR1307;
            break;
            
        case 1308:
            errorReason = ERROR1308;
            break;
            
        case 1309:
            errorReason = ERROR1309;
            break;
            
        case 1310:
            errorReason = ERROR1310;
            break;
            
        case 1311:
            errorReason = ERROR1311;
            break;
            
        case 1312:
            errorReason = ERROR1312;
            break;
            
        case 1313:
            errorReason = ERROR1313;
            break;
            
        case 1314:
            errorReason = ERROR1314;
            break;
            
        case 1315:
            errorReason = ERROR1315;
            break;
            
        case 1316:
            errorReason = ERROR1316;
            break;
            
        case 1317:
            errorReason = ERROR1317;
            break;
            
        case 1318:
            errorReason = ERROR1318;
            break;
            
        case 1319:
            errorReason = ERROR1319;
            break;
            
        case 1320:
            errorReason = ERROR1320;
            break;
            
        case 1321:
            errorReason = ERROR1321;
            break;
            
        case 1322:
            errorReason = ERROR1322;
            break;
            
        case 1323:
            errorReason = ERROR1323;
            [self reLogin];
            break;
            
        case 1324:
            errorReason = ERROR1324;
            break;
        case 1325:
            errorReason = ERROR1325;
            break;
            
        case 1326:
            errorReason = ERROR1326;
            break;
            
        case 1327:
            errorReason = ERROR1327;
            break;
            
        case 1328:
            errorReason = ERROR1328;
            break;
            
        case 1329:
            errorReason = ERROR1329;
            break;
            
        case 1330:
            errorReason = ERROR1330;
            break;
            
        case 1331:
            errorReason = ERROR1331;
            break;
            
        case 1332:
            errorReason = ERROR1332;
            break;
            
        case 1333:
            errorReason = ERROR1333;
            break;
            
        case 1334:
            errorReason = ERROR1334;
            break;
            
        case 1335:
            errorReason = ERROR1335;
            break;
            
        case 1336:
            errorReason = ERROR1336;
            break;
            
        case 1337:
            errorReason = ERROR1337;
            break;
            
        case 1338:
            errorReason = ERROR1338;
            break;
            
        case 1339:
            errorReason = ERROR1339;
            break;
            
        case 1400:
            errorReason = ERROR1400;
            break;
            
        case 1401:
            errorReason = ERROR1401;
            break;
            
        case 1500:
            errorReason = ERROR1500;
            break;
            
        case 1501:
            errorReason = ERROR1501;
            break;
            
        default:
            errorReason = ERROROTHER;
            break;
    }
}

- (void)reLogin
{
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        [[UnifiedUserInfoManager share] exitLogin];
        // 重新登录
        [self reLogin];
    }
}
@end
