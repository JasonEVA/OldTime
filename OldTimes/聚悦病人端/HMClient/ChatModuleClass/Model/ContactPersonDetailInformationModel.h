//
//  ContactPersonDetailInformationModel.h
//  launcher
//
//  Created by Conan Ma on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMResultSet;

// ************** 服务器字段 **************//
static NSString * const personDetail_sqlid                = @"sqlID";
static NSString * const personDetail_headPic              = @"headPic";
static NSString * const personDetail_show_id              = @"SHOW_ID";
static NSString * const personDetail_u_name               = @"U_NAME";
static NSString * const personDetail_u_true_name          = @"U_TRUE_NAME";
static NSString * const personDetail_u_true_name_c        = @"U_TRUE_NAME_C";
static NSString * const personDetail_u_status             = @"U_STATUS";
static NSString * const personDetail_u_sort               = @"U_SORT";
static NSString * const personDetail_last_login_time      = @"LAST_LOGIN_TIME";
static NSString * const personDetail_last_login_token     = @"LAST_LOGIN_TOKEN";
static NSString * const personDetail_is_admin             = @"IS_ADMIN";
static NSString * const personDetail_c_show_id            = @"C_SHOW_ID";
static NSString * const personDetail_create_user          = @"CREATE_USER";
static NSString * const personDetail_create_time          = @"CREATE_TIME";
static NSString * const personDetail_create_user_name     = @"CREATE_USER_NAME";
static NSString * const personDetail_d_name               = @"D_NAME";
static NSString * const personDetail_u_dept_id            = @"U_DEPT_ID";
static NSString * const personDetail_d_parentid_show_id   = @"D_PARENTID_SHOW_ID";
static NSString * const personDetail_d_path_name          = @"D_PATH_NAME";
static NSString * const personDetail_u_mobile             = @"U_MOBILE";
static NSString * const personDetail_u_mail               = @"U_MAIL";
static NSString * const personDetail_u_hira               = @"U_HIRA";
static NSString * const personDetail_u_job                = @"U_JOB";
static NSString * const personDetail_u_telephone          = @"U_TELEPHONE";
// ************** 服务器字段 **************//

static NSString * const personDetail_extension            = @"personDetail_extension";
static NSString * const personDetail_modified             = @"personDetail_modified";

@interface ContactPersonDetailInformationModel : NSObject

@property (nonatomic, assign) NSInteger sqlId;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *show_id;                // 用户id
/** 帐号 使用show_id */
@property (nonatomic, strong) NSString *u_name DEPRECATED_ATTRIBUTE;
/** 真实姓名 */
@property (nonatomic, strong) NSString *u_true_name;
@property (nonatomic, strong) NSString *u_true_name_c;          // 首字母
@property (nonatomic, assign) BOOL u_status;                    // 是否有效,0=锁定,1=可用
@property (nonatomic, assign) BOOL u_sort;                      // 布吉岛
@property (nonatomic, assign) long long last_login_time;        // token创建时间
@property (nonatomic, strong) NSString *last_login_token;       // token
@property (nonatomic, assign) BOOL is_admin;                    // 布吉岛 目测是否为管理员
@property (nonatomic, strong) NSString *c_show_id;              // 公司id 根部门id
@property (nonatomic, strong) NSString *create_user;            // 创建人拼音
@property (nonatomic, assign) long long create_time;            // 创建日期
@property (nonatomic, strong) NSString *create_user_name;       // 创建人姓名
@property (nonatomic, strong) NSArray  *u_dept_id;              // 子部门ID                     //
@property (nonatomic, strong) NSArray  *d_parentid_show_id;     // 上级部门ID                   //
@property (nonatomic, strong) NSArray  *d_path_name;            // 布吉岛啥用                   //
@property (nonatomic, strong) NSString *u_mail;                 // 邮箱
@property (nonatomic, strong) NSString *u_mobile;               // 手机
@property (nonatomic, strong) NSArray  *d_name;                 // 部门名称                     //
@property (nonatomic, strong) NSString *u_hira;                 // 日文排序首字母
@property (nonatomic, strong) NSString *u_job;                  // 职位
@property (nonatomic, strong) NSString *u_telephone;            // 办公电话

/** 要显示在UI上的部门 */
@property (nonatomic, readonly) NSString *d_name_forShow;

/** 用户最后更新时间	long	选填	如果用户存在则返回 */
@property (nonatomic, assign) long long _modified;
@property (nonatomic, strong) NSString *extension;

@property (nonatomic, strong) NSNumber *_localId;

@property (nonatomic, readonly) NSString *sqlheadPic;
@property (nonatomic, readonly) NSString *sqlshow_id;
@property (nonatomic, readonly) NSString *sqlu_name;
@property (nonatomic, readonly) NSString *sqlu_true_name;
@property (nonatomic, readonly) NSString *sqlu_true_name_c;
@property (nonatomic, readonly) BOOL sqlu_status;
@property (nonatomic, readonly) BOOL sqlu_sort;
@property (nonatomic, readonly) BOOL sqlis_admin;
@property (nonatomic, readonly) NSString *sqlc_show_id;
@property (nonatomic, readonly) NSString *sqlcreate_user;
@property (nonatomic, readonly) long long sqlcreate_time;
@property (nonatomic, readonly) NSString *sqlcreate_user_name;
@property (nonatomic, readonly) NSString *sqlu_dept_id;
@property (nonatomic, readonly) NSString *sqld_parentid_show_id;
@property (nonatomic, readonly) NSString *sqld_path_name;
@property (nonatomic, readonly) NSString *sqlu_mail;
@property (nonatomic, readonly) NSString *sqlu_mobile;
@property (nonatomic, readonly) NSString *sqld_name;
@property (nonatomic, readonly) NSString *sqlu_hira;
@property (nonatomic, readonly) NSString *sqlu_job;
@property (nonatomic, readonly) NSString *sqlu_telephone;

@property (nonatomic, readonly) NSString *sqlextension;
@property (nonatomic, readonly) long long sql_modified;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithFMResult:(FMResultSet *)resultSet;

@end
