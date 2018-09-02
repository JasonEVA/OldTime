//
//  UserPsychologyDetail.h
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPsychologyInfo : NSObject
{
    
}
@property (nonatomic, assign) NSInteger moodType;
@property (nonatomic, retain) NSString* createTime;
@end

@interface UserPsychologyDetail : NSObject

@property (nonatomic, retain) UserPsychologyInfo* userMood;
@property (nonatomic, retain) NSArray* notes;
@end
