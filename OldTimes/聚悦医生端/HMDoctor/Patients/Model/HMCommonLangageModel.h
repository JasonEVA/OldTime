//
//  HMCommonLangageModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/9/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCommonLangageModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userCommonLanguageId;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSInteger staffId;

@end
