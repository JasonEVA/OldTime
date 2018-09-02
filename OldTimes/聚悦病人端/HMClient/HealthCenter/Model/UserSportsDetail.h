//
//  UserSportsDetail.h
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsEachTime : NSObject
{
    
}
@property (nonatomic, retain) NSString* sportsName;
@property (nonatomic, assign) NSInteger sportTimes;

@end

@interface RecommandSportsType : NSObject

@property (nonatomic, retain) NSString* sportsName;
@property (nonatomic, assign) NSInteger sportsTypeId;
@end

@interface UserSportsDetail : NSObject
{
    
}

@property (nonatomic, assign) NSInteger target;
@property (nonatomic, assign) NSInteger userSportsTotalTimes;
@property (nonatomic, retain) NSArray* userSportsEachTimes;
@property (nonatomic, retain) NSArray* sportType;
@property (nonatomic, retain) NSArray* notes;
@end
