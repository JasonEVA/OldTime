//
//  ContactPersonDetailInformationModel.m
//  launcher
//
//  Created by Conan Ma on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ContactPersonDetailInformationModel.h"
#import "NSDictionary+SafeManager.h"
#import "NSString+Manager.h"
#import "FMResultSet.h"

@implementation ContactPersonDetailInformationModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.show_id            = [dict valueStringForKey:personDetail_show_id];
        self.launchrId          = [[dict valueNumberForKey:personDetail_u_launchrId] integerValue];
        self.u_name             = [dict valueStringForKey:personDetail_u_name];
        self.u_true_name        = [dict valueStringForKey:personDetail_u_true_name];
        self.u_true_name_c      = [dict valueStringForKey:personDetail_u_true_name_c];
        self.u_mail             = [dict valueStringForKey:personDetail_u_mail];
        self.u_status           = [dict valueBoolForKey:personDetail_u_status];
        self.u_mobile           = [dict valueStringForKey:personDetail_u_mobile];
        self.u_sort             = [dict valueBoolForKey:personDetail_u_sort];
        self.last_login_time    = [[dict valueNumberForKey:personDetail_last_login_time] integerValue];
        self.last_login_token   = [dict valueStringForKey:personDetail_last_login_token];
        self.is_admin           = [dict valueBoolForKey:personDetail_is_admin];
        self.c_show_id          = [dict valueStringForKey:personDetail_c_show_id];
        self.create_user        = [dict valueStringForKey:personDetail_create_user];
        self.create_time        = [[dict valueNumberForKey:personDetail_create_time] integerValue];
        self.create_user_name   = [dict valueStringForKey:personDetail_create_user_name];
        self.u_hira             = [dict valueStringForKey:personDetail_u_hira];
        self.u_job              = [dict valueStringForKey:personDetail_u_job];
        self.u_telephone        = [dict valueStringForKey:personDetail_u_telephone];
        self.d_name = [dict valueArrayForKey:personDetail_d_name];
        if ([self.d_name isKindOfClass:[NSString class]]) {
            self.d_name = @[self.d_name];
        }
        
        self.u_dept_id = [dict valueArrayForKey:personDetail_u_dept_id];
        if ([self.u_dept_id isKindOfClass:[NSString class]]) {
            self.u_dept_id = @[self.u_dept_id];
        }
        
        self.d_parentid_show_id = [dict valueArrayForKey:personDetail_d_parentid_show_id];
        if ([self.d_parentid_show_id isKindOfClass:[NSString class]]) {
            self.d_parentid_show_id = @[self.d_parentid_show_id];
        }
        
        self.d_path_name = [dict valueArrayForKey:personDetail_d_path_name];
        if ([self.d_path_name isKindOfClass:[NSString class]]) {
            self.d_path_name = [(NSString *)self.d_path_name componentsSeparatedByString:@"●"];
            if (![[self.d_path_name firstObject] length]) {
                self.d_path_name = @[];
            }
        }
    }
    return self;
}

- (instancetype)initWithFMResult:(FMResultSet *)resultSet {
    self = [super init];
    if (self) {
        self.sqlId              = [resultSet longForColumn:personDetail_sqlid];
        self.headPic            = [resultSet stringForColumn:personDetail_headPic];
        self.show_id            = [resultSet stringForColumn:personDetail_show_id];
        self.launchrId          = [resultSet intForColumn:personDetail_u_launchrId];
        self.u_name             = [resultSet stringForColumn:personDetail_u_name];
        self.u_true_name        = [resultSet stringForColumn:personDetail_u_true_name];
        self.u_true_name_c      = [resultSet stringForColumn:personDetail_u_true_name_c];
        self.u_status           = [resultSet boolForColumn:personDetail_u_status];
        self.u_sort             = [resultSet boolForColumn:personDetail_u_sort];
        self.is_admin           = [resultSet boolForColumn:personDetail_is_admin];
        self.c_show_id          = [resultSet stringForColumn:personDetail_c_show_id];
        self.create_user        = [resultSet stringForColumn:personDetail_create_user];
        self.create_time        = [resultSet longLongIntForColumn:personDetail_create_time];
        self.u_mail             = [resultSet stringForColumn:personDetail_u_mail];
        self.u_mobile           = [resultSet stringForColumn:personDetail_u_mobile];
        self.u_hira             = [resultSet stringForColumn:personDetail_u_hira];
        self.u_job              = [resultSet stringForColumn:personDetail_u_job];
        self.u_telephone        = [resultSet stringForColumn:personDetail_u_telephone];

        // 数组特殊处理
        NSString *u_dept_id          = [resultSet stringForColumn:personDetail_u_dept_id];
        NSString *d_parentid_show_id = [resultSet stringForColumn:personDetail_d_parentid_show_id];
        NSString *d_path_name        = [resultSet stringForColumn:personDetail_d_path_name];
        NSString *d_name             = [resultSet stringForColumn:personDetail_d_name];
        
        self.u_dept_id = [u_dept_id componentsSeparatedByString:@"●"];
        if (![[self.u_dept_id firstObject] length]) {
            self.u_dept_id = @[];
        }
        
        self.d_parentid_show_id = [d_parentid_show_id componentsSeparatedByString:@"●"];
        if (![[self.d_parentid_show_id firstObject] length]) {
            self.d_parentid_show_id = @[];
        }
        
        self.d_path_name = [d_path_name componentsSeparatedByString:@"●"];
        if (![[self.d_path_name firstObject] length]) {
            self.d_path_name = @[];
        }
        
        self.d_name = [d_name componentsSeparatedByString:@"●"];
        if (![[self.d_name firstObject] length]) {
            self.d_name = @[];
        }
        
        self._modified = [resultSet longLongIntForColumn:personDetail_modified];
        self.extension = [resultSet stringForColumn:personDetail_extension];
        
    }
    return self;
}

- (NSString *)d_name_forShow {
    if ([self.d_name isKindOfClass:[NSString class]]) {
        return (NSString *)self.d_name;
    }
    
    return [self.d_name componentsJoinedByString:@","];
}

#pragma mark - SQL Get
- (NSString *)getSqlEditString:(SEL)selector {
    
    NSString *selectorName = NSStringFromSelector(selector);
    // 预处理
    NSString *editName = [selectorName stringByReplacingOccurrencesOfString:@"sql" withString:@""];
    
    id value = [self valueForKey:editName];
    if ([value isKindOfClass:[NSArray class]]) {
        value = [value componentsJoinedByString:@"●"];
    }
    
    return [NSString convertSpecialCharInString:value];
}

- (NSString *)sqlheadPic            {return [self getSqlEditString:_cmd];}
- (NSString *)sqlshow_id            {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_name             {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_true_name        {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_true_name_c      {return [self getSqlEditString:_cmd];}
- (BOOL)sqlu_status                 {return self.u_status;}
- (BOOL)sqlu_sort                   {return self.u_sort;}
- (BOOL)sqlis_admin                 {return self.is_admin;}
- (NSString *)sqlc_show_id          {return [self getSqlEditString:_cmd];}
- (NSString *)sqlcreate_user        {return [self getSqlEditString:_cmd];}
- (NSString *)sqlcreate_user_name   {return [self getSqlEditString:_cmd];}
- (long long)sqlcreate_time         {return self.create_time;}
- (NSString *)sqlu_mail             {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_mobile           {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_hira             {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_job              {return [self getSqlEditString:_cmd];}
- (NSString *)sqlu_telephone        {return [self getSqlEditString:_cmd];}

- (NSString *)sqlu_dept_id          {return [self getSqlEditString:_cmd];}
- (NSString *)sqld_parentid_show_id {return [self getSqlEditString:_cmd];}
- (NSString *)sqld_path_name        {return [self getSqlEditString:_cmd];}
- (NSString *)sqld_name             {return [self getSqlEditString:_cmd];}

- (long long)sql_modified           {return self._modified;}
- (NSString *)sqlextension          {return [self getSqlEditString:_cmd];}


@end
