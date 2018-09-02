//
//  StartFuncInfo.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StartFuncInfo.h"

#define kStartFuncKey        @"StartFunList"

@implementation StartFuncInfo

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setFuncIndex:[aDecoder decodeIntegerForKey:@"funcIndex"]];
        [self setIsMust:[aDecoder decodeBoolForKey:@"isMust"]];
        [self setIsValid:[aDecoder decodeBoolForKey:@"isValid"]];
        
        [self setFuncName:[aDecoder decodeObjectForKey:@"funcName"]];
        [self setFuncIconName:[aDecoder decodeObjectForKey:@"funcIconName"]];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.funcIndex forKey:@"funcIndex"];
    [aCoder encodeBool:self.isMust forKey:@"isMust"];
    [aCoder encodeBool:self.isValid forKey:@"isValid"];
    
    [aCoder encodeObject:self.funcName forKey:@"funcName"];
    [aCoder encodeObject:self.funcIconName forKey:@"funcIconName"];
}
@end

static StartFuncInfoHelper* startFuncInfoDefaultHelper = nil;

@interface StartFuncInfoHelper ()

@end

@implementation StartFuncInfoHelper

+ (StartFuncInfoHelper*) defaultHelper
{
    if (!startFuncInfoDefaultHelper)
    {
        startFuncInfoDefaultHelper = [[StartFuncInfoHelper alloc]init];
    }
    return startFuncInfoDefaultHelper;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        NSDictionary *dicFuncInfo = nil;
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kStartFuncKey];
        NSArray* startFuncDicts = nil;
        
        if (data && [data isKindOfClass:[NSData class]])
        {
            dicFuncInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
//        NSDictionary *dicFuncInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kStartFuncKey]];
        if (dicFuncInfo && [dicFuncInfo isKindOfClass:[NSDictionary class]])
        {
            startFuncDicts = [dicFuncInfo valueForKey:[NSString stringWithFormat:@"%ld",curStaff.staffId]];
        }
//        NSArray* startFuncDicts = [dicFuncInfo valueForKey:[NSString stringWithFormat:@"%ld",curStaff.staffId]];
        
        //NSArray* startFuncDicts = nil;
        if (!startFuncDicts)
        {
            //用户还没有配置功能项目
            NSArray* startFuncs = [self createDefaultStartFuncs];
            NSMutableArray* dictItems = [NSMutableArray array];
            for (StartFuncInfo* func in startFuncs)
            {
                NSDictionary* dicFunc = [func mj_keyValues];
                [dictItems addObject:dicFunc];
            }
//            [[NSUserDefaults standardUserDefaults] setValue:dictItems forKey:kStartFuncKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setStartFuncItems:startFuncs];
        }
        else
        {
            /*NSMutableArray* startFuncs = [NSMutableArray array];
            for (NSDictionary* dicFunc in startFuncDicts)
            {
                StartFuncInfo* func = [StartFuncInfo mj_objectWithKeyValues:dicFunc];
                [startFuncs addObject:func];
            }*/
            
            [self setStartFuncItems:startFuncDicts];
        }
    }
    return self;
}

- (NSArray*) createDefaultStartFuncs
{
    NSMutableArray* startFuncs = [NSMutableArray array];
    
    NSArray* funcnames = [NSArray arrayWithObjects:@"随访用户", @"收费用户", @"用药建议", @"问诊表", @"随访表",@"医生关怀",nil];
    NSArray* funcimagenames = [NSArray arrayWithObjects:@"icon_paitent_free", @"icon_paitent_charge", @"img_main_prescription", @"img_main_interrogation", @"img_main_survey",@"img_main_guanhuai", nil];
    
    for (NSInteger index = 0; index < funcnames.count; ++index)
    {
        StartFuncInfo* func = [[StartFuncInfo alloc]init];
        [func setIsValid:YES];
        [func setIsMust:YES];
        [func setFuncIndex:index];
        
        [func setFuncName:funcnames[index]];
        [func setFuncIconName:funcimagenames[index]];
        [startFuncs addObject:func];
    }
    //暂时拿掉医疗公式
//    NSArray* optfuncnames = [NSArray arrayWithObjects:@"疾病指南", @"医疗公式", @"用药助手",nil];
//    NSArray* optfuncimagenames = [NSArray arrayWithObjects:@"img_main_disease", @"img_main_format", @"img_main_medication", nil];
    NSArray* optfuncnames = [NSArray arrayWithObjects:@"疾病指南", @"用药助手",nil];
    NSArray* optfuncimagenames = [NSArray arrayWithObjects:@"img_main_disease", @"img_main_medication", nil];
    
    for (NSInteger index = 0; index < optfuncnames.count; ++index)
    {
        StartFuncInfo* func = [[StartFuncInfo alloc]init];
        [func setIsValid:NO];
        [func setIsMust:NO];
        [func setFuncIndex:index];
        
        [func setFuncName:optfuncnames[index]];
        [func setFuncIconName:optfuncimagenames[index]];
        [startFuncs addObject:func];
    }
    
    return startFuncs;
}

@end
