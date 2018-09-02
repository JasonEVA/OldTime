//
//  DoctorGreetingInfo.h
//  HMClient
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorGreetingInfo : NSObject

@property (nonatomic, retain) NSString* careCon;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* careId;
@property (nonatomic, retain) NSString* voice;
@property (nonatomic, retain) NSString* carerName;
@property (nonatomic, retain) NSString* carerTypeName;
@property (nonatomic, copy) NSString *voiceLength;                 // 语音长度
@property (nonatomic, copy) NSString *classPaper;          // 宣教副标题
@property (nonatomic, copy) NSString *classTitle;          // 宣教标题
@property (nonatomic, copy) NSString *classId;             // 宣教Id
@property (nonatomic, copy) NSArray *careImg;              // 关怀图片
@property (nonatomic, copy) NSArray *careImgDesc;              // 关怀图片缩略图

@end
