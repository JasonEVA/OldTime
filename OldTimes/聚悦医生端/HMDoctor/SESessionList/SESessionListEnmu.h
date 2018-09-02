//
//  SESessionListEnmu.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SESessionListEnmu : NSObject
// 会话分类 分类type
typedef NS_ENUM(NSUInteger, SESessionListType) {
    
    SESessionListType_GroupVIP,                 //集团VIP
    
    SESessionListType_GroupMiddle,              //集团中层
    
    SESessionListType_GroupCommon,              //集团普通
    
    SESessionListType_PersonalPackage,          //个人套餐
    
    SESessionListType_PersonalFollow,           //个人随访
    
    SESessionListType_PersonalSingle            //个人单项
};

+ (NSArray *)sessionTypeList;
@end
