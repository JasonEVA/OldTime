//
//  HMPstientListGroupRankModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//  集团分级model

#import <Foundation/Foundation.h>

@interface HMPstientListGroupRankModel : NSObject
@property (nonatomic, copy) NSString *rankName;
@property (nonatomic, copy) NSArray *patientsArr;
@property (nonatomic) BOOL isExpanded;
@end
