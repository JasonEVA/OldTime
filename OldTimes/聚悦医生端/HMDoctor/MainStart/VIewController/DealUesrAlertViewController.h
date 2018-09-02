//
//  DealUesrAlertViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlertInfo.h"

typedef void (^UserAlertDealCompletedBlock)();

typedef enum : NSUInteger {
    DealAlert_AdjustValue = 0,  //调整预警值
    DealAlert_AdjustMedicine,   //调整用药
    DealAlert_ContinueDetect,   //继续监测
    DealAlert_InformVisit,      //通知复诊
    DealAlert_ContactPatient,   //联系患者
    DealAlert_Cancel,           //取消
} DealAlertWay;

typedef void(^DealAlertWayBlock)(UserAlertInfo* alert, DealAlertWay dealway);

@interface DealUesrAlertViewController : UIViewController
{
    
}

+ (void) showInParentViewController:(UIViewController*) parentController
                      UserAlertInfo:(UserAlertInfo*) userAlert
        UserAlertDealCompletedBlock:(UserAlertDealCompletedBlock)block;


@end
