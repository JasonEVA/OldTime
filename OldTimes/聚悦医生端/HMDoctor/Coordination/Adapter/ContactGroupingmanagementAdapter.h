//
//  ContactGroupingmanagementAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  

#import "ATTableViewAdapter.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
@interface ContactGroupingmanagementAdapter : ATTableViewAdapter

@property (nonatomic)  BOOL  managementStatus; // <##>
@property (nonatomic, strong) MessageRelationGroupModel *selectModel;

@end
