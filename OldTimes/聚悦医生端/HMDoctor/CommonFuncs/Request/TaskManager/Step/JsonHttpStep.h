//
//  JsonHttpStep.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "Step.h"


@interface JsonHttpStep : Step
{
    id postParams;
}
@property (nonatomic, assign) NSInteger errorCode;
- (id) initWithUrl:(NSString*) aPostUrl Params:(id) aPostParams;

@end
