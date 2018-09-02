//
//  CompanyModel.h
//  launcher
//
//  Created by williamzhang on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  公司Model

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic, copy) NSString *showId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dictionary;

@end
