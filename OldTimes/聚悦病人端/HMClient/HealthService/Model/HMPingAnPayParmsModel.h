//
//  HMPingAnPayParmsModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPingAnPayParmsModel : NSObject
@property (nonatomic, copy) NSString *orig;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *returnUrl;
@property (nonatomic, copy) NSString *notifyUrl;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *openCardUrl;

@end
