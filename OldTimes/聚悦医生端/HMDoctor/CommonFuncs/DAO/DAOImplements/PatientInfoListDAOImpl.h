//
//  PatientInfoListDAOImpl.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//  病人信息列表数据库实现

#import "DAOBaseImpl.h"
#import "PatientInfoListDAOProtocol.h"

@class FMDatabase;

@interface PatientInfoListDAOImpl : DAOBaseImpl<PatientInfoListDAOProtocol>

@property (nonatomic, assign)  BOOL  updated; // 是否更新过

+ (void)createMessageTableWithDB:(FMDatabase *)db;


@end
