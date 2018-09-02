//
//  ATPunchCardRequest.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATHttpBaseRequest.h"

@class ATPunchCardModel;
@interface ATPunchCardResponse : ATHttpBaseResponse

@property (nonatomic, strong) ATPunchCardModel *punchModel;

@end

@interface ATPunchCardRequest : ATHttpBaseRequest

@property (nonatomic, copy) NSString *orgId; //!< 企业标识
@property (nonatomic, copy) NSString *userId; //!< 用户标识
@property (nonatomic, copy) NSString *lon; //!< 经度
@property (nonatomic, copy) NSString *lat; //!< 纬度
@property (nonatomic, copy) NSString *location; //!< 打卡地点
@property (nonatomic, copy) NSString *remark; //!< 备注[可不传]
@property (nonatomic, copy) NSString *networkType; //!< 网络类型[可不传]

@property (nonatomic, copy) NSString *signId; //!< 记录标识【传空:添加;非空:修改】
@property (nonatomic, strong) NSNumber *signType;

@end
