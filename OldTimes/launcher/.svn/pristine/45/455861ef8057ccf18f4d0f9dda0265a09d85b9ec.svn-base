//
//  CompanyModel.m
//  launcher
//
//  Created by williamzhang on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "CompanyModel.h"
#import "NSDictionary+SafeManager.h"


static NSString *const d_showId = @"showId";
static NSString *const d_cCode  = @"cCode";
static NSString *const d_cName  = @"cName";

@implementation CompanyModel

- (instancetype)initWithDict:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _showId = [dictionary valueStringForKey:d_showId];
        _code   = [dictionary valueStringForKey:d_cCode];
        _name   = [dictionary valueStringForKey:d_cName];
    }
    return self;
}

@end
