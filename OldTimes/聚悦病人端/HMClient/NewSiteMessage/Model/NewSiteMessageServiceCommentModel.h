//
//  NewSiteMessageServiceCommentModel.h
//  HMClient
//
//  Created by jasonwang on 2017/2/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 服务评价model

#import <Foundation/Foundation.h>

@interface NewSiteMessageServiceCommentModel : NSObject
@property (nonatomic, copy) NSString *userServiceId;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *type;
@end
