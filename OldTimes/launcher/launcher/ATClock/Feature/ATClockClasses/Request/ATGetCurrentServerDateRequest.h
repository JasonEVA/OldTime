//
//  ATGetCurrentServerDateRequest.h
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATHttpBaseRequest.h"

@interface ATGetCurrentServerDateResponse : ATHttpBaseResponse

@property (nonatomic, strong) NSNumber *currentTimestamp;

@end

@interface ATGetCurrentServerDateRequest : ATHttpBaseRequest

@end
