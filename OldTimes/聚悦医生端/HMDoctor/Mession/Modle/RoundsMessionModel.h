//
//  RoundsMessionModel.h
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RoundsMessionStatus) {
    RoundsMession_UnFilled = 0,//未填写
    RoundsMession_Filled = 1,//已填写
    RoundsMession_Viewed = 2,//已查看
    RoundsMession_Replyed = 3,//已回复
    RoundsMession_Summaryed = 4,//已总结
    
};

@interface RoundsMessionModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, retain) NSString* illName;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, retain) NSString* surveyId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, retain) NSString* statusName;
@property (nonatomic, retain) NSString* moudleName;
@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* fillTime;

@property (nonatomic, copy) NSString *mainIll;
@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, assign) NSInteger healthyId;
@end
