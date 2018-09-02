//
//  NewMissionMainListAdapter.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版任务列表adapter

#import "ATTableViewAdapter.h"

@interface NewMissionMainListAdapter : ATTableViewAdapter
@property (nonatomic, strong) NSMutableArray *headViewTitelArr;
@property (nonatomic, strong)  NSMutableArray  *arrayButtons; // <##>
@end
