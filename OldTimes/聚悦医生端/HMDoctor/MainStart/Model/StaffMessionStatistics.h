//
//  StaffMessionStatistics.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffMessionStatistics : NSObject
{

}

@property (nonatomic, retain) NSString* anCountStr;
@property (nonatomic, retain) NSString* unCountStr;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, retain) NSString* taskCode;
@property (nonatomic, retain) NSString* taskName;
@property (nonatomic, retain) NSString* numInfo;

- (NSString*) messionStatisticString;
@end
