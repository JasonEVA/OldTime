//
//  MessageAttachmentModel.m
//  Titans
//
//  Created by Remon Lv on 14-10-7.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageAttachmentModel.h"
#import "MsgDefine.h"
#import "NSString+Manager.h"
#import "MsgUserInfoMgr.h"
#import <MJExtension/MJExtension.h>

#define DICT_fileName    @"fileName"
#define DICT_fileSize    @"fileSize"
#define DICT_fileUrl     @"fileUrl"    // 原始图路径
#define DICT_thumbnail   @"thumbnail"  // 缩略图路径
#define DICT_audioLength @"audioLength"// 音频时长
@implementation MessageAttachmentModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (dict != nil)
        {
            if ([dict objectForKey:DICT_fileName] != [NSNull null] && [dict objectForKey:DICT_fileName] != NULL)
            {
                self.fileName = [dict objectForKey:DICT_fileName];
            }
            
            if ([dict objectForKey:DICT_fileSize] != [NSNull null] && [dict objectForKey:DICT_fileSize] != NULL)
            {
                self.fileSize = [[dict objectForKey:DICT_fileSize] integerValue];
            }
            
            if ([dict objectForKey:DICT_fileUrl] != [NSNull null] && [dict objectForKey:DICT_fileUrl] != NULL)
            {
                NSString *strUrl = [dict objectForKey:DICT_fileUrl];
                self.fileUrl = strUrl;
            }
            
            if ([dict objectForKey:DICT_thumbnail] != [NSNull null] && [dict objectForKey:DICT_thumbnail] != NULL)
            {
                NSString *strUrl = [dict objectForKey:DICT_thumbnail];
                self.thumbnail = strUrl;
            }
            
            self.audioLength = 0;
            if ([dict objectForKey:DICT_audioLength] != [NSNull null] && [dict objectForKey:DICT_audioLength] != NULL)
            {
                self.audioLength = [[dict objectForKey:DICT_audioLength] integerValue];
            }
        }
    }
    return self;
}

- (NSString *)fileSizeString {
    _fileSizeString = [NSString changeFileUnitFrom:self.fileSize];
    return _fileSizeString;
}


- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
        return @"";
        }
    }
    return oldValue;
}
@end
