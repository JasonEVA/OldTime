//
//  ServiceCategory.h
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceCategory : NSObject
{
    
}

@property (nonatomic, retain) NSString* code;           //分类ID
@property (nonatomic, assign) NSInteger productTypeId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) NSInteger teamCount;
@property (nonatomic, assign) NSInteger packCount;

@property (nonatomic, retain) NSString* imgUrl;       //图标地址

@end
