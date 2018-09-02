//
//  SiteMessageModel.h
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteMessageModel : NSObject

@property(nonatomic, copy) NSString  *createTime;

@property(nonatomic, strong) NSNumber  *doStatus;

@property(nonatomic, copy) NSString  *doThing;

@property(nonatomic, strong) NSNumber  *msgId;

@property(nonatomic, copy) NSString  *msgTitle;

@property(nonatomic, copy) NSNumber  *msgTypeId;

@property(nonatomic, copy) NSString  *publishTime;

@property(nonatomic, strong) NSNumber  *publishUser;

@property(nonatomic, copy) NSString  *receiveUserName;

@property(nonatomic, strong) NSNumber  *status;

@property(nonatomic, copy) NSNumber  *userId;

@property(nonatomic, copy) NSString  *userName;


@property(nonatomic, copy) NSString  *msgContent;
@property(nonatomic, copy) NSString  *deviceToken;
@property(nonatomic, copy) NSString  *reviewTime;
@property(nonatomic, copy) NSString  *reviewUser;


@end
