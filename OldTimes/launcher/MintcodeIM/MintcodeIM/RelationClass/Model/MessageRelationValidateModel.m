//
//  MessageRelationValidateModel.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationValidateModel.h"
#import "NSDictionary+IMSafeManager.h"

@implementation MessageRelationValidateModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    MessageRelationValidateModel *model = [MessageRelationValidateModel new];
    
    model.validateId   = [[dict im_valueNumberForKey:@"id"] integerValue];
    model.appName      = [dict im_valueStringForKey:@"appName"];
    model.from         = [dict im_valueStringForKey:@"from"];
    model.fromNickName = [dict im_valueStringForKey:@"fromNickName"];
    model.fromAvatar   = [dict im_valueStringForKey:@"fromAvatar"];
    model.content      = [dict im_valueStringForKey:@"content"];
    model.createDate   = [[dict im_valueNumberForKey:@"createDate"] longLongValue];

    model.validateState = [[dict im_valueNumberForKey:@"validateState"] unsignedIntegerValue];
    if (model.validateState != mt_relation_validateState_agree &&
        model.validateState != mt_relation_validateState_ignore &&
        model.validateState != mt_relation_validateState_reject) {
        model.validateState = mt_relation_validateState_default;
    }
    
    return model;
}

@end
