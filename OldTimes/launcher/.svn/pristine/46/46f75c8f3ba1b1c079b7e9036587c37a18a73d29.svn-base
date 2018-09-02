//
//  NewProjectAddRequest.h
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  新增项目

#import "BaseRequest.h"

@interface NewProjectAddRequest : BaseRequest

- (void)createProject:(NSString *)projectName people:(NSArray *)people;
@property (nonatomic,strong) NSString * projectName;

@end

@interface NewProjectAddResponse : BaseResponse

@property (nonatomic, copy) NSString *showId;
@property (nonatomic,strong) NSString * projectName;
@property (nonatomic,strong) NSString * createUser;


@end