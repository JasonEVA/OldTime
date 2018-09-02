//
//  NewCommentSelectLabelModel.h
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价 标签选择 model

#import <Foundation/Foundation.h>

@interface NewCommentSelectLabelModel : NSObject
@property (nonatomic, copy) NSString *tag;        //名称
@property (nonatomic, copy) NSString *tagId;      //名称Id
@property (nonatomic) BOOL isSelected;
@end
