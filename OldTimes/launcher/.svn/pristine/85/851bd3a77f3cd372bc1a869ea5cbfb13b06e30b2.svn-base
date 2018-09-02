//
//  ApplicationCommentListRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用评论列表Request

#import "BaseRequest.h"

@interface ApplicationCommentListResponse : BaseResponse

/** 存放ApplicationCommentModel */
@property (nonatomic, strong) NSArray *arrayComments;

@property (nonatomic, assign) BOOL remain;

@end

@interface ApplicationCommentListRequest : BaseRequest

/** 使用前先填充app showId */
- (void)setAppShowId:(NSString *)appShowId;
/** 确保已经使用前已使用`setAppShowId:` */
- (void)newCommentWithShowId:(NSString *)showId;
/** 确保已经使用前已使用`setAppShowId:` */
- (void)getMoreWithTime:(NSDate *)date;

@end
