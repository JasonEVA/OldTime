//
//  unifiedFilePathManager.m
//  Shape
//
//  Created by Andrew Shen on 15/10/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "unifiedFilePathManager.h"

static NSString *const kDocuments = @"Documents";

@implementation unifiedFilePathManager

- (instancetype)init
{
    if (self = [super init])
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:M_N_ReleaseSingleton object:nil];
    }
    return self;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:M_N_ReleaseSingleton object:nil];
}

// 单例
+ (unifiedFilePathManager *)share
{
    static unifiedFilePathManager *filePathManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filePathManager = [[unifiedFilePathManager alloc] init];
    });
    return filePathManager;
}

- (void)destroyMyself
{
    
}

// 返回Document文件夹下某一个文件夹路径，如果没有则创建一个
- (NSString *)getDocumentSubfolderWithFolderName:(NSString *)folderName
{
    // 判断本地是否存在存放图片的文件夹
    NSFileManager *fm = [NSFileManager defaultManager];
    // 文件夹不存在则创建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 当前登录用户名为总文件夹，确保切换登录账号不会造成数据错误
    NSString * folderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:folderName];
    BOOL isDir;
    BOOL isExist = [fm fileExistsAtPath:folderPath isDirectory:&isDir];
    // 文件夹不存在
    if (!(isExist && isDir))
    {
        // 创建一个
        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return folderPath;
}

// 返回用户文件夹路径，如果没有则创建一个
- (NSString *)getCurrentUserFolder {
    return [self getDocumentSubfolderWithFolderName:@"test"];
}

// 拼接用户文件夹下文件路径
- (NSString *)getCurrentUserDirectoryWithFolderName:(NSString *)folderName fileName:(NSString *)fileName
{
    NSString *pathTemp = [folderName ? : @"" stringByAppendingPathComponent:fileName];
    NSString *fullPath = [[self getCurrentUserFolder] stringByAppendingPathComponent:pathTemp];
    NSLog(@"-------------->%@", fullPath);
    return fullPath;
}

/** 剥离沙盒全路径 留下Documents以后的相对路径
 */
- (NSString *)getRelativePathWithAllPath:(NSString *)allPath
{
    NSString *strResult = nil;
    NSRange rangeRelative = [allPath rangeOfString:kDocuments];
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

/**批量删除某个目录下所有文件
 */
- (void)clearAllFileInDirectory:(NSString *)folderName {
    NSString *fullPath = [self getDocumentSubfolderWithFolderName:folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:fullPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[fullPath stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
