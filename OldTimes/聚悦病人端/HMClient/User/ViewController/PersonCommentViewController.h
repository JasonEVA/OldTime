//
//  PersonCommentViewController.h
//  HMClient
//
//  Created by Dee on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用户评价

#import "HMBasePageViewController.h"

@interface PersonCommentViewController : HMBasePageViewController

/**
 *  对服务中的团队呵成员进行评价
 *
 *  @param serviceID 用户服务ID
 *
 */
- (instancetype)initWithServiceID:(NSString *)serviceID;

@end
