//
//  AdvertiseInfo.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* imgUrlBig;
//@property (nonatomic, retain) NSString* webUrl;
@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, retain) NSString* linkUrl;
@property (nonatomic, assign) NSInteger playTime;   //广告播放时长，秒为单位

@end
