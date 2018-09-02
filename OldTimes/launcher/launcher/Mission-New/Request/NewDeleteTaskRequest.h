//
//  NewDeleteTaskRequest.h
//  launcher
//
//  Created by TabLiu on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  删除任务

#import "BaseRequest.h"

@interface NewDeleteTaskRequest : BaseRequest

@property (nonatomic,strong) NSString * showId ;
@property (nonatomic,strong) NSIndexPath * path ;

@end

@interface NewDeleteTaskResponse : BaseResponse


@end