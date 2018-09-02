//
//  ApplyAddNewApplyRequest.h
//  launcher
//
//  Created by Dee on 15/9/5.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  

#import "BaseRequest.h"
#import "ApplyDetailInformationModel.h"
@interface ApplyAddNewApplyResponse : BaseResponse

@property(nonatomic, copy) NSString  *showId;

@property(nonatomic, copy) NSString  *createUserName;

@property(nonatomic, strong) NSDate  *createTime;
@end

@interface ApplyAddNewApplyRequest : BaseRequest

- (void)applyAddNewApplyWithModel:(ApplyDetailInformationModel *)model;

@end
