//
//  HMPramiseMeModel.h
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  赞我的人model

#import <Foundation/Foundation.h>

@interface HMPramiseMeModel : NSObject
@property (nonatomic, copy) NSString *favourTime;
@property (nonatomic) NSInteger targetUserId;
@property (nonatomic) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userExerciseId;
@property (nonatomic, copy) NSString *userExerciseFavourId;
@end
