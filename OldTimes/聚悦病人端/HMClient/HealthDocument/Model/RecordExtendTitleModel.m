//
//  RecordExtendTitleModel.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "RecordExtendTitleModel.h"

@implementation RecordExtendTitleModel

@end

@implementation AsthmaDiaryValueModel

@end

@implementation AsthmaDiaryModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"value" : [AsthmaDiaryValueModel class],
             };
}

@end
