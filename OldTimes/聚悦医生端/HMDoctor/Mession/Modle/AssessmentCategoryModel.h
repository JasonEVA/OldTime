//
//  AssessmentCategoryModel.h
//  HMDoctor
//
//  Created by lkl on 16/8/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AssessmentCategoryModel : NSObject

@property (nonatomic, copy) NSString *deptCode;
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, copy) NSString *deptName;
@property (nonatomic, strong) NSArray *details;

@end
