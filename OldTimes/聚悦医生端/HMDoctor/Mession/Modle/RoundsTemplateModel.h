//
//  RoundsTemplateModel.h
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundsTemplateModel : NSObject

@property (nonatomic, assign) NSInteger templateId;
@property (nonatomic, retain) NSString* templateName;
@end

@interface RoundsTemplateWithUserModel : RoundsTemplateModel
@property (nonatomic, retain) NSString* targetUserId;

- (id) initWithRoundsTemplateModel:(RoundsTemplateModel*) category;
@end

@interface RoundsTemplateCategoryModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, retain) NSString* categoryName;
@property (nonatomic, assign) NSInteger deptId;

@end

@interface RoundsTemplateCategoryWithUserModel : RoundsTemplateCategoryModel

- (id) initWithRoundsTemplateCategoryModel:(RoundsTemplateCategoryModel*) category;
@property (nonatomic, retain) NSString* targetUserId;
@end

@interface RoundsTemplateCategoryListModel : NSObject

@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) NSInteger deptId;
@property (nonatomic, retain) NSString* deptName;
@property (nonatomic, retain) NSArray* details;

@end
