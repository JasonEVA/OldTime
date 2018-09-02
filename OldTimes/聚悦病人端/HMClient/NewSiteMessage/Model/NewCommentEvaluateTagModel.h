//
//  NewCommentEvaluateTagModel.h
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价 服务评价内容 model

#import <Foundation/Foundation.h>

@interface NewCommentEvaluateTagModel : NSObject
@property (nonatomic, copy) NSString *target;          //名称
@property (nonatomic, copy) NSString *targetId;        //名称Id
@property (nonatomic) NSInteger score;             //星星数量
@end
