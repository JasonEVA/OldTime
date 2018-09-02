//
//  PersonServiceComplainListModel.h
//  HMClient
//
//  Created by Dee on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//  投诉历史模型

#import <Foundation/Foundation.h>

@interface PersonServiceComplainListModel : NSObject
//投诉内容
@property(nonatomic, copy) NSString   *complaintContent;
//投诉对象ID
@property(nonatomic, assign) NSInteger  complaintObjectID;
//投诉对象
@property(nonatomic, copy) NSString  *complaintObjectName;
//投诉类型
@property(nonatomic, assign) NSInteger  complaintType;
//创建时间
@property(nonatomic, copy) NSString  *createTime;
//回复内容
@property(nonatomic, copy) NSString  *replyContent;
//回复时间
@property(nonatomic, copy) NSString  *replyTime;

@property(nonatomic, assign) NSInteger  replyUserID;
//状态
@property(nonatomic, copy) NSString *status;

@property(nonatomic, copy) NSString  *userComlaintId;

@property(nonatomic, assign) NSInteger  userID;

@end
