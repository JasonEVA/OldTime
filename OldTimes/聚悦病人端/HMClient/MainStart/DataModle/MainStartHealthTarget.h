//
//  MainStartHealthTarget.h
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

DEPRECATED_MSG_ATTRIBUTE("使用MainStartHealthTargetModel代替")
@interface MainStartHealthTarget : NSObject
{
    
}

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* subKpiName;
@property (nonatomic, retain) NSString* subKpiCode;
@property (nonatomic, assign) NSInteger targetId;
@property (nonatomic, assign) float targetValue;
@property (nonatomic, assign) float testValue;
@property (nonatomic, assign) NSInteger color;

- (UIColor*) targetColor;
@end
