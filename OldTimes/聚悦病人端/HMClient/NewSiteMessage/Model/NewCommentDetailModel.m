//
//  NewCommentDetailModel.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentDetailModel.h"
#import "MJExtension.h"

@implementation NewCommentDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"evaluateTarget" : [NewCommentEvaluateTagModel class]};
}
@end
