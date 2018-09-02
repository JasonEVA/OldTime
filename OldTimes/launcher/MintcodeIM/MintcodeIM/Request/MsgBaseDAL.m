//
//  MsgBaseDAL.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "MsgBaseDAL.h"

@implementation MsgBaseDAL

- (BOOL)isSuccessCode
{
    if (self._dictOutput)
    {
        id obj = self._dictOutput[M_I_message];
        if (CHECK_TEMP_OBJECT_IF_NOT_NULL(obj))
        {
            self._message = obj;
        }
        
        obj = self._dictOutput[M_I_code];
        if (CHECK_TEMP_OBJECT_IF_NOT_NULL(obj))
        {
            if ([obj integerValue] == 2000)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (NSMutableDictionary *)_dictInput
{
    if (!__dictInput)
    {
        __dictInput = [[NSMutableDictionary alloc] init];
    }
    return __dictInput;
}

- (NSMutableArray *)_arrMsg
{
    if (!__arrMsg)
    {
        __arrMsg = [NSMutableArray array];
    }
    return __arrMsg;
}
@end
