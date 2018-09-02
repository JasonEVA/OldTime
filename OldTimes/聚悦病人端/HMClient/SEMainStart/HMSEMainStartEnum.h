//
//  HMSEMainStartEnum.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#ifndef HMSEMainStartEnum_h
#define HMSEMainStartEnum_h

typedef NS_ENUM(NSUInteger, SEMainStartType) {
    
    SEMainStartType_StaffTeam = 00,     // 团队信息
    
    
    SEMainStartType_HealthRecord = 10,     // 记录健康
    
    SEMainStartType_TodayMission = 20,     // 今日任务
    
    
    SEMainStartType_HealthClass = 30,     // 健康课堂
    
    SEMainStartType_ToolBox = 40,     // 工具箱
    
};

typedef NS_ENUM(NSUInteger, SEMainStartToolBoxType) {
    
    SEMainStartToolBoxType_Experts = 0,     // 约专家
    
    SEMainStartToolBoxType_Nutrition = 1,     // 营养库
    
    SEMainStartToolBoxType_Pharmacy = 2     // 药品库
    
    
};


typedef NS_ENUM(NSUInteger, HMMainStartAlterBtnType) {
    
    HMMainStartAlterBtnType_Close = 0,     // 关闭
    
    HMMainStartAlterBtnType_Goon = 1,     // 去完成
    
    HMMainStartAlterBtnType_Wait = 2     // 再等等
    
    
};

typedef NS_ENUM(NSUInteger, HMNewDoctorCareAlterCellType) {
    
    HMNewDoctorCareAlterCellType_Text = 0,     // 文本
    
    HMNewDoctorCareAlterCellType_Voice = 1,     // 语音
    
    HMNewDoctorCareAlterCellType_Image = 2,     // 图片
    
    HMNewDoctorCareAlterCellType_Education = 3     // 宣教
    
    
};
#endif /* HMSEMainStartEnum_h */
