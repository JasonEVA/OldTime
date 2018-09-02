//
//  HealthReport.h
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthReport : NSObject
{
    
}

@property (nonatomic, assign) NSInteger healthyId;
@property (nonatomic, retain) NSString* analysis;
@property (nonatomic, retain) NSString* healthyReportId;
@property (nonatomic, retain) NSString* summarizeTime;
@property (nonatomic, retain) NSString* reportSummary;
@property (nonatomic, assign) NSInteger status;

@end
