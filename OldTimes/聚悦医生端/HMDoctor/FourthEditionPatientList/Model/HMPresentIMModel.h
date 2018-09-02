//
//  HMPresentIMModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPresentIMModel : NSObject
@property (nonatomic) long long cancelTime;
@property (nonatomic) long long beginTime;

@property (nonatomic, copy) NSString *status;
@property (nonatomic) NSInteger teamId;
@property (nonatomic) NSInteger classify;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *imGroupId;

@property (nonatomic, copy) NSString *teamName;

@property (nonatomic) NSInteger userServiceId;

@end
