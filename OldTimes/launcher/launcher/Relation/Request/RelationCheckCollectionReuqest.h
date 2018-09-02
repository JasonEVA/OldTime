//
//  RelationCheckCollectionReuqest.h
//  launcher
//
//  Created by kylehe on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface RelationCheckCollectionReuqest : BaseRequest

- (void)checkCollectionWithRelationName:(NSString *)relationName;

@end

@interface RelationCheckCollectionResponse : BaseResponse

@property(nonatomic, assign) BOOL  isColleague;

@end