//
//  unifiedFilePathManager.h
//  Shape
//
//  Created by Andrew Shen on 15/10/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  路径管理类

#import <Foundation/Foundation.h>

@interface unifiedFilePathManager : NSObject
// 单例
+ (unifiedFilePathManager *)share;

// 返回Document文件夹下某一个文件夹路径，如果没有则创建一个
- (NSString *)getDocumentSubfolderWithFolderName:(NSString *)folderName;

// 返回用户文件夹路径，如果没有则创建一个
- (NSString *)getCurrentUserFolder;

// 拼接用户文件夹下文件路径
- (NSString *)getCurrentUserDirectoryWithFolderName:(NSString *)folderName fileName:(NSString *)fileName;

/** 剥离沙盒全路径 留下Documents以后的相对路径
 */
- (NSString *)getRelativePathWithAllPath:(NSString *)allPath;
/** 拼接沙盒全路径 拼接Documents以后的相对路径
 */
- (NSString *)getAllPathWithRelativePath:(NSString *)relativePath;

/**批量删除某个目录下所有文件
 */
- (void)clearAllFileInDirectory:(NSString *)folderName;
@end
