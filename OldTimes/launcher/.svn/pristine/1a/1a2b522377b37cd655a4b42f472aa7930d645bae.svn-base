//
//  ApplicationCommentModel.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用评论Model

#import <Foundation/Foundation.h>

@interface ApplicationCommentModel : NSObject

@property (nonatomic, copy  ) NSString *showID;         //评论的ShowID
@property (nonatomic, copy  ) NSString *content;        //评论内容
@property (nonatomic, copy  ) NSString *filePath;       //文件路径,只有当评论内容为附件的时候才会显示
@property (nonatomic, assign) BOOL     isComment;
@property (nonatomic, assign) BOOL     isDelete;
@property (nonatomic, copy  ) NSString *appShowID;      //应用ShowID
@property (nonatomic, copy  ) NSString *rmShowID;       //关联主键的ShowID
@property (nonatomic, copy  ) NSString *cShowID;        //记录所属企业ID
@property (nonatomic, strong) NSDate   *createTime;     //创建时间
@property (nonatomic, strong) NSString *createUser;     //创建人
@property (nonatomic, strong) NSString *createUserName; //创建人姓名
@property (nonatomic, copy  ) NSString *transType;
@property (nonatomic, strong) NSString *rmData;
@property (nonatomic, copy) NSArray *atWho;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
