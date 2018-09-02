//
//  HMPersonSpaceSecondEditionViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版我的界面主页

typedef NS_ENUM(NSUInteger, SEPersonSpaceType) {
    
    SEPersonSpaceType_TopCollectView = 00,     // 顶部我的订单、我的服务、我的约诊
    
    
    SEPersonSpaceType_ConsultingRecords = 10,  // 咨询记录
    
    SEPersonSpaceType_MyFriends,               // 我的亲友
    
    
    SEPersonSpaceType_MyArchives = 20,         // 我的档案
    
    SEPersonSpaceType_MyReport,                // 我的报告

    SEPersonSpaceType_MyEquipment,             // 我的设备
    

    SEPersonSpaceType_Collection = 30,         // 内容收藏

    SEPersonSpaceType_MyFocus,                 // 我的关注
    

    SEPersonSpaceType_ShareToFriend = 40,       //邀请好友
    SEPersonSpaceType_OnlineService,           // 在线客服

    SEPersonSpaceType_Feedback,                // 意见反馈
    
    SEPersonSpaceType_AboutUs,                 // 关于我们

//    SEPersonSpaceType_ServiceComplaints,       // 服务投诉
    
};

#import "HMBaseViewController.h"

@interface HMPersonSpaceSecondEditionViewController : HMBaseViewController

// push时隐藏移动lb
- (void)hideMoveNameLbWhenPush;

// pop时显示移动lb
- (void)showMoveNameLbWhenPush;
@end
