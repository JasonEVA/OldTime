//
//  NSString+URLEncod.h
//  HMDoctor
//
//  Created by jasonwang on 2016/10/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  URL解析分类



@interface NSString (URLEncod)
//获取URL中的所有参数，以字典返回
- (NSDictionary *)analysisParameter;
@end
