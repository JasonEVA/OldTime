//
//  GroupInfoAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  群名片adapter

#import "ATTableViewAdapter.h"
typedef void(^titleSelectIndexBlock)(NSInteger index);

@class StaffServiceInfoModel;
@protocol GroupInfoAdapterDelegate <NSObject>

- (void)groupInfoAdapterDelegateCallBack_doctorClickedWithIndex:(NSInteger)index;

@end
@interface GroupInfoAdapter : ATTableViewAdapter
@property(nonatomic, strong) StaffServiceInfoModel  *serviceInfoModel;
@property (nonatomic, weak)  id<GroupInfoAdapterDelegate>  doctorClickedDelegate; // <##>
- (void)getTitleSelectIndexWithBlock:(titleSelectIndexBlock)block;
@end
