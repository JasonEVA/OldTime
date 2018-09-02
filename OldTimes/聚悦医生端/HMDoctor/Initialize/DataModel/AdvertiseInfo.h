//
//  AdvertiseInfo.h
//  HMDoctor
//
//  Created by yinquan on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseInfo : NSObject

@property (nonatomic, retain) NSString* imgUrlBig;
//@property (nonatomic, retain) NSString* webUrl;
@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, retain) NSString* contentName;
@property (nonatomic, retain) NSString* linkUrl;
@property (nonatomic, assign) NSInteger playTime;   //广告播放时长，秒为单位

@end
