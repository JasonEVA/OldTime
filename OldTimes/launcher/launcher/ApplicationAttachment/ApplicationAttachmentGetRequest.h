//
//  ApplicationAttachmentGetRequest.h
//  launcher
//
//  Created by williamzhang on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  获取应用附件

#import "BaseRequest.h"
#import "AttachmentUtil.h"

@interface ApplicationAttachmentGetResponse : BaseResponse

/** 存放ApplicationAttachmentModel */
@property (nonatomic, strong) NSArray *arrayAttachments;

@end

@interface ApplicationAttachmentGetRequest : BaseRequest

- (void)getAppShowId:(AttachmentAppShowIdType)appShowIdType mainShowId:(NSString *)showId;

@end
