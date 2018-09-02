//
//  HMOnlineArchivesModel.h
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMOnlineArchivesModel : NSObject

@end

@interface HMAdmissionAssessDateListModel : NSObject

@property (nonatomic, copy) NSString *ADMISSION_ID;
@property (nonatomic, copy) NSString *CREATE_DATE;   //时间

@end


//子项 既往史
@interface HMBeforListModel : NSObject

@property (nonatomic, copy) NSString *CONFIRMED_DATE;
@property (nonatomic, copy) NSString *DATA_TYPE;
@property (nonatomic, copy) NSString *END_TYPE;    //结局
@property (nonatomic, copy) NSString *JB_NAME;
@property (nonatomic, copy) NSString *PMH_TYPE;
@property (nonatomic, copy) NSString *TAKE_WAY;
@end

//子项 家族史
@interface HMFamilyListModel : NSObject

@property (nonatomic, copy) NSString *DATA_TYPE;
@property (nonatomic, copy) NSString *END_TYPE;
@property (nonatomic, copy) NSString *JB_NAME;     
@property (nonatomic, copy) NSString *SHIP_TYPE;   //家族
@property (nonatomic, copy) NSString *TAKE_WAY;
@property (nonatomic, copy) NSString *ZAOFA_TYPE;  //早发

@end

//子项 现病史
@interface HMNowListModel : NSObject

@property (nonatomic, copy) NSString *CONFIRMED_DATE;

// 1.现病史  2.既往史  3.家族史
@property (nonatomic, copy) NSString *DATA_TYPE;
@property (nonatomic, copy) NSString *END_TYPE;
@property (nonatomic, copy) NSString *JB_NAME;      //病
@property (nonatomic, copy) NSString *RECENT_DESC;  //近期情况
@property (nonatomic, copy) NSString *TAKE_WAY;     //治疗／手术

@end


@interface HMJbHistoryListModel : NSObject

@property (nonatomic, copy) NSArray *beforList;    //既往史
@property (nonatomic, copy) NSArray *familyList;   //家族史
@property (nonatomic, copy) NSArray *nowList;      //现病史

//@property (nonatomic, copy) NSArray<HMBeforListModel *> *beforList;    //既往史
//@property (nonatomic, copy) NSArray<HMFamilyListModel *> *familyList;   //家族史
//@property (nonatomic, copy) NSArray<HMNowListModel *> *nowList;      //现病史
@end


