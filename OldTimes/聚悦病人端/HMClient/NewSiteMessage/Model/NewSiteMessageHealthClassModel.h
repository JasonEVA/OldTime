//
//  NewSiteMessageHealthClassModel.h
//  HMClient
//
//  Created by jasonwang on 2017/2/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 健康课堂model

#import <Foundation/Foundation.h>

@interface NewSiteMessageHealthClassModel : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *healthClassDescription;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *staffId;
@property (nonatomic, copy) NSString *classId;

@end


//{"title":"视频测试","picUrl":"/content/3ECFEFB0_C446_4593_9D9E_6940A2238339_20161220111253233.jpg","description":"俄罗斯驻土耳其大使遭枪击身亡 枪手被击毙","url":"http://182.92.8.118:10009/jy/newc/jkkt/jkktDetail.htm?classId\u003d145"}
