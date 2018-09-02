//
//  NewGetProjectListRequest.h
//  launcher
//
//  Created by TabLiu on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
// 获取项目列表

#import "BaseRequest.h"
#import "ProjectContentModel.h"

@interface NewGetProjectListRequest : BaseRequest

@property (nonatomic,strong) NSString * seleShowId;
- (void)getNewList;

@end

@interface NewGetProjectListResponse : BaseResponse

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) BOOL isNeedDefine ;
@end
