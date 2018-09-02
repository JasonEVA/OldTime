//
//  DAOFactory.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//  数据库工厂

#import <Foundation/Foundation.h>
#import "PatientInfoListDAOProtocol.h"

#define _DAO [DAOFactory sharedInstance]

@interface DAOFactory : NSObject

@property (nonatomic, readonly)  dispatch_queue_t  DBActionQueue; // <##>
@property (nonatomic, strong, readonly)  id<PatientInfoListDAOProtocol>  patientInfoListDAO; // 患者列表

+ (instancetype)sharedInstance;

- (void)closeDB;


@end
