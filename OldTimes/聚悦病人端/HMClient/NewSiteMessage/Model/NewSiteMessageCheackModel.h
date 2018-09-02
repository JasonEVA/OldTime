//
//  NewSiteMessageCheackModel.h
//  HMClient
//
//  Created by jasonwang on 2017/6/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewSiteMessageCheackModel : NSObject
@property (nonatomic, copy) NSString *type;  //类型
@property (nonatomic, copy) NSString *msg;   //消息体
@property (nonatomic, copy) NSString *msgTitle;   //标题
@property (nonatomic, copy) NSString *surveyId;
@end
