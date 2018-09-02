//
//  DrugsUsagesInfo.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugsUsagesInfo : NSObject

@property (nonatomic, retain) NSString* createUserId;
@property (nonatomic, retain) NSString* drugsUsageCode;
@property (nonatomic, retain) NSString* drugsUsageName;
@property (nonatomic, retain) NSString* status;


@end

@interface DrugsFrequencyInfo : NSObject

@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* createUserId;
@property (nonatomic, retain) NSString* drugsFrequencyCode;
@property (nonatomic, retain) NSString* drugsFrequencyName;
@property (nonatomic, retain) NSString* status;


@end
