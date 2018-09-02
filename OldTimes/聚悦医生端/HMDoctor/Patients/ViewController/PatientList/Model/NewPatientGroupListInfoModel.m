//
//  NewPatientGroupListInfoModel.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "NewPatientGroupListInfoModel.h"
#import "NewPatientListInfoModel.h"

@implementation NewPatientGroupListInfoModel

- (NSMutableArray<NewPatientListInfoModel *> *)users {
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
