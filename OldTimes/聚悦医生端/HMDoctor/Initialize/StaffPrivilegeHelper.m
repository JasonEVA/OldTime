//
//  StaffPrivilegeHelper.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffPrivilegeHelper.h"

static StaffPrivilegeHelper* defaultStaffPrivilegeHelper = nil;

@interface StaffPrivilegeHelper ()
{
    
}

@property (nonatomic, retain) NSDictionary* dictPrivilege;
@end


@implementation StaffPrivilegeHelper

+ (StaffPrivilegeHelper*) defaultHelper
{
    if (!defaultStaffPrivilegeHelper)
    {
        defaultStaffPrivilegeHelper = [[StaffPrivilegeHelper alloc]init];
    }
    return defaultStaffPrivilegeHelper;
}

+ (NSString*) staffPrivilegePath
{
    NSString* userDir = [UserInfoHelper userDir];
    NSString* privilege = [userDir stringByAppendingPathComponent:@"Privilege.plist"];
    return privilege;
}

+ (void) savePrivilege:(NSDictionary*) dicPrivilege
{
    if (!dicPrivilege || ![dicPrivilege isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    [[StaffPrivilegeHelper defaultHelper] setDictPrivilege:dicPrivilege];
    //保存权限Dictionary
    NSString* privilegePath = [self staffPrivilegePath];
    [dicPrivilege writeToFile:privilegePath atomically:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        NSString* privilegePath = [StaffPrivilegeHelper staffPrivilegePath];
        BOOL dictFileIsExisted = [[NSFileManager defaultManager] fileExistsAtPath: privilegePath];
        if (privilegePath && dictFileIsExisted)
        {
            //权限纪录文件存在
            NSDictionary* dicPrivilege = [NSDictionary dictionaryWithContentsOfFile:privilegePath];
            if (dicPrivilege && [dicPrivilege isKindOfClass:[NSDictionary class]])
            {
                _dictPrivilege = dicPrivilege;
            }
        }
        
    }
    return self;
}

+ (NSString*) privilegeKey:(NSString*) mode
                    Status:(NSInteger) status
               OperateCode:(NSString*) code
{
    if (!mode || 0 == mode.length)
    {
        return nil;
    }
    if (!code || 0 == code.length)
    {
        return nil;
    }
    
    
    NSString* key = [NSString stringWithFormat:@"%@_%ld_%@", mode, status, code];
    if (0xFF == status)
    {
        key = [NSString stringWithFormat:@"%@_FF_%@", mode, code];
    }
    return key;
}

//检查操作是否有权限
+ (BOOL) staffHasPrivilege:(NSString*) mode
                    Status:(NSInteger) status
               OperateCode:(NSString*) code
{
    StaffPrivilegeHelper* defaultHelper = [StaffPrivilegeHelper defaultHelper];
    NSString* privilegeKey = [self privilegeKey:mode Status:status OperateCode:code];
    if (!privilegeKey)
    {
        return NO;
    }
    
    NSDictionary* dicPrivilege = defaultHelper.dictPrivilege;
    if (!dicPrivilege || ![dicPrivilege isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    NSString* privilegeStr = [dicPrivilege valueForKey:privilegeKey];
    if (!privilegeStr || 0 == privilegeStr.length)
    {
        return NO;
    }
    
    return [privilegeStr isEqualToString:@"Y"];
}

+ (BOOL) staffHasPrivilegeWithOperateKey:(NSString *)operateKey
{
    StaffPrivilegeHelper* defaultHelper = [StaffPrivilegeHelper defaultHelper];
    
    if (!operateKey || 0 == operateKey.length)
    {
        return NO;
    }
    
    NSDictionary* dicPrivilege = defaultHelper.dictPrivilege;
    if (!dicPrivilege || ![dicPrivilege isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    NSString* privilegeStr = [dicPrivilege valueForKey:operateKey];
    return [privilegeStr isEqualToString:@"Y"];

}

@end

@implementation StaffPrivilegeJSHelper

- (NSString*) getUserPermission:(NSString*) operate
{
    BOOL hasPrivilege = [StaffPrivilegeHelper staffHasPrivilegeWithOperateKey:operate];
    if (hasPrivilege)
    {
        return @"Y";
    }
    return @"N";
}

@end
