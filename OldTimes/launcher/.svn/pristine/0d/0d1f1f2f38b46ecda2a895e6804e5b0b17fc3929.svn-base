//
//  MsgFilePathMgr.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "MsgFilePathMgr.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"
#import "NSString+Manager.h"

#define NAME_SQL            @"MsgSql"       // 数据库

#define DIR_MESSAGE         @"Message"      // 消息

#define STR_DOCUMENTS       @"Documents"

#define T_WAV   @".wav"
#define T_AMR   @".amr"

@implementation MsgFilePathMgr

// 单例
+ (MsgFilePathMgr *)share
{
    static MsgFilePathMgr *msgFilePathMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgFilePathMgr = [[MsgFilePathMgr alloc] init];
    });
    return msgFilePathMgr;

}

// 获取消息数据文件夹名
- (NSString *)getMessageDirNamePathWithUid:(NSString *)uid
{
    // 得到模块名称
    NSString *name = DIR_MESSAGE;
    name = [name stringByAppendingPathComponent:uid];
    //     拼接完成路径
    name = [self getDocumentsPathWithDirName:name];
    return name;
}

// 取出对应的文件路径名称，采用每个类目名为一个文件夹，每个文件夹下保存图片和数据库
- (NSString *)getSqlPath
{
    // 得到模块名称
    NSString *name = NAME_SQL;
    // 拼接完成路径
    name = [self getDocumentsPathWithDirName:name];
    
    NSLog(@"%@",name);
    
    return name;
}

// 得到视频路径
- (NSString *)newFileWithType:(NSString *)type sessionPreset:(NSString *)sessionPreset uid:(NSString *)uid
{
    NSString *documentsPath = [self getMessageDirNamePathWithUid:uid];
    NSTimeInterval date = [[NSDate date] timeIntervalSinceDate:[[NSDate alloc] initWithTimeIntervalSince1970:143410000 + 1290690000]];
    NSString *strDate = [NSString stringWithFormat:@"%@_%.0lf.%@",[sessionPreset substringFromIndex:22],date,type];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:strDate];
    NSLog(@"%@",filePath);
    return filePath;
}

- (NSString *)getMessageDirFilePathWithFileName:(NSString *)fileName extension:(Extension_audio)extension uid:(NSString *)uid
{
    // 1. 得到消息附件文件夹路径、文件名（当前时间戳）
    NSString *strPath = [self getMessageDirNamePathWithUid:uid];
    NSString *strExtension = ((extension == extension_wav) ? T_WAV : T_AMR);
    
    // 2. 生成wav文件路径
    NSString *strFileName = [NSString stringWithFormat:@"%@%@",fileName,strExtension];
    NSString *strPathAll = [strPath stringByAppendingPathComponent:strFileName];
    return strPathAll;
}

// 返回包含到文件夹的全路径，如果没有则创建一个
- (NSString *)getDocumentsPathWithDirName:(NSString *)dirName
{
    // 判断本地是否存在存放图片的文件夹
    NSFileManager *fm = [NSFileManager defaultManager];
    // 文件夹不存在则创建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 当前登录用户名为总文件夹，确保切换登录账号不会造成数据错误
    NSString * documentsdir = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[MsgUserInfoMgr share] getUid]];
    // 拼接上文件夹名称
    documentsdir = [documentsdir stringByAppendingPathComponent:dirName];
    BOOL isDir;
    BOOL isExist = [fm fileExistsAtPath:documentsdir isDirectory:&isDir];
    // 文件夹不存在
    if (!(isExist && isDir))
    {
        // 创建一个
        [fm createDirectoryAtPath:documentsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return documentsdir;
}

/** 剥离沙盒全路径 留下Documents以后的相对路径
 */
- (NSString *)getRelativePathWithAllPath:(NSString *)allPath
{
    NSString *strResult = nil;
    NSRange rangeRelative = [allPath rangeOfString:STR_DOCUMENTS];
    if (rangeRelative.location != NSNotFound)
    {
        strResult = [allPath substringFromIndex:(rangeRelative.location + rangeRelative.length)];
    }
    
    return strResult;
}

/** 拼接沙盒全路径 拼接Documents以后的相对路径
 */
- (NSString *)getAllPathWithRelativePath:(NSString *)relativePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strResult =  [paths objectAtIndex:0];
    strResult = [strResult stringByAppendingPathComponent:relativePath];
    
    return strResult;
}

/**批量删除某人或者群组的文件资源目录
 */
- (void)clearAllFileForMessageWithUid:(NSString *)uid {
    NSString *fullPath = [self getMessageDirNamePathWithUid:uid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:fullPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
            [fileManager removeItemAtPath:[fullPath stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
