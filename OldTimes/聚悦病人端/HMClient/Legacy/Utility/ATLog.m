//
//  ATLog.m
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import "ATLog.h"
#import "LogUploadRequest.h"

static BOOL ATLogEnableStatus = NO;
static BOOL ATLogInitStatus = NO;

@implementation ATLog

+ (void)configLogEnable:(BOOL)enable
{
    ATLogEnableStatus = enable;
    if(!ATLogInitStatus) {
        ATLogInitStatus= YES;
        [self redirectNSLogToFile];
    }
}

+ (void)redirectNSLogToFile
{
    //如果已经连接Xcode调试则不输出到文件
    if(!ATLogEnableStatus || isatty(STDOUT_FILENO)) {
        return;
    }
    NSString *logDirectory = [self p_logDirectory];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@",[self p_todayLogFileName]];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}

+ (BOOL)logEnableStatus
{
    return ATLogEnableStatus;
}


+ (void)uploadLogFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *logDirectory = [self p_logDirectory];
    
    NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:logDirectory] objectEnumerator];
    NSString *fileName = @"";
    while ((fileName = [childFileEnumerator nextObject]) != nil){
        if (![fileName isEqualToString:[self p_todayLogFileName]]) {
            NSString *fileAbsolutePath = [logDirectory stringByAppendingPathComponent:fileName];
            // 上传服务器
            LogUploadRequest *request = [LogUploadRequest new];
            NSData *fileData = [NSData dataWithContentsOfFile:fileAbsolutePath];
            __weak typeof(self) weakSelf = self;
            [request requestUploadFileData:fileData fileName:fileName completion:^(ATSHTTPBaseResponse *response, BOOL success) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (success) {
                    NSString *uploadedPath = [logDirectory stringByAppendingPathComponent:response.fileName];
                    // 删除已上传文件
                    [strongSelf p_removeFileWithPath:uploadedPath];
                }
            }];
            
        }
    }
    
}

+ (NSString *)p_logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return logDirectory;
}

+ (NSString *)p_todayLogFileName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFileName = [NSString stringWithFormat:@"%@.log",dateStr];
    return logFileName;
}

+ (void)p_removeFileWithPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager removeItemAtPath:filePath error:nil];
    if (isSuccess) {
        NSLog(@"delete success");
    }
    else{
        NSLog(@"delete fail");
    }
}
@end
