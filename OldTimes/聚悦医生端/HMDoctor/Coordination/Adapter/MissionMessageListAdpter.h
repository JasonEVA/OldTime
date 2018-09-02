//
//  MissionMessageListAdpter.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"
typedef void (^MissionMessageListAdpterBlock)(BOOL isAccept,NSInteger index);
@interface MissionMessageListAdpter : ATTableViewAdapter

@property (nonatomic, assign)  BOOL  scrollToBottom; // 是否滚到底部

- (void)clickBlock:(MissionMessageListAdpterBlock)block;
@end
