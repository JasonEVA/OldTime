//
//  UpdateWhiteboardNameRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  更新白板名字

#import "BaseRequest.h"

@interface UpdateWhiteboardNameRequest : BaseRequest

/** 修改后的名字（成功后使用） */
@property (nonatomic, readonly) NSString *updatedName;

- (void)updateName:(NSString *)name showId:(NSString *)showId;

@end
