//
//  NewSiteMessageTemindReviewModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  复查提醒model

#import <Foundation/Foundation.h>

@interface NewSiteMessageTemindReviewModel : NSObject
@property (nonatomic, copy) NSArray *indecesNames;      //复查项目
@property (nonatomic, copy) NSString *msgTitle;         //标题
@property (nonatomic, copy) NSString *reviewTime;       //复查时间
@property (nonatomic, copy) NSString *msg;              //内容
@property (nonatomic, copy) NSString *type;  //类型

@end

// {"indecesNames":["血脂四项","血脂四项"],"msgTitle":"复查提醒","reviewTime":"2017-01-20","type":"reviewPush","msg":"亲，请及时复查哦"}

