//
//  IMAttachmentUploadRequest.m
//  launcher
//
//  Created by Lars Chen on 16/1/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMAttachmentUploadRequest.h"
#import "NSDictionary+IMSafeManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "AttachmentUploadModel.h"
#import "MessageBaseModel.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

static NSUInteger const dataPerByte         = 102400;// 单个包大小（100KB）
static NSUInteger const maxFailToRetryCount = 2;// 单个包重试上限

static NSString * const  la_fileSize        = @"fileSize";
static NSString * const  la_fileUrl         = @"fileUrl";
static NSString * const  la_thumbnail       = @"thumbnail";
static NSString * const  la_thumbnailWidth  = @"thumbnailWidth";
static NSString * const  la_thumbnailHeight = @"thumbnailHeight";

@interface IMAttachmentUploadRequest ()

@property (nonatomic, strong) NSData *totalData;

@property (nonatomic, assign) NSUInteger srcOffset;
@property (nonatomic, assign) NSUInteger retryCount;

@property (nonatomic, strong) AttachmentUploadModel *uploadModel;

@property (nonatomic, copy) IMUploadTaskCompletedBlock finishBlock;
@property (nonatomic, copy) IMUploadTaskProgressBlock  progressBlock;
@property (nonatomic, copy) IMUploadTaskFailedBlock    failBlock;

@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

// 除了第一次手动开之后自动分包上传
@property (nonatomic) BOOL uploadAutomatic;

@end

@implementation IMAttachmentUploadRequest

- (NSString *)action { return @"/upload"; }

- (void)uploadWithAttach:(AttachmentUploadModel *)model
{
    self.reUploadTimes = 1;
    
    self.uploadModel = model;
    
    [self resetTaskConfig];
}

- (void)resetTaskConfig
{
    self.srcOffset = 0;
    self.retryCount = 0;
    self.totalData = self.uploadModel.dataAll;
    self.uploadAutomatic = NO;
    
    self.params[DICT_fileUrl] = self.uploadModel.fileUrl;
    self.params[DICT_fileName] = self.uploadModel.fileName;
    self.params[DICT_srcOffset] = [NSNumber numberWithInteger:self.uploadModel.srcOffset];
    self.params[DICT_fileStatus] = [NSNumber numberWithInteger:self.uploadModel.fileStatus];
    
    [self uploadPackage];
}

/** 上传分包 */
- (void)uploadPackage
{
    // 判断下一波能否传完
    if ([self.totalData length] <= dataPerByte) {
        self.params[DICT_fileStatus] = @1;
    }
    
    NSRange range = NSMakeRange(self.srcOffset, MIN(dataPerByte, [self.totalData length] - self.srcOffset));
    
    NSData *uploadDataNeeded = [self.totalData subdataWithRange:range];
    
    /*0--3字节：INT类型，表示json用UTF-8编码转成字节数组的长度
     4--n字节：TaskDetail类型，json UTF-8编码
     n+1—结束：byte[] 多个附件 按List<Attachment>顺序存放*/
    
    [self prepareRequest];
    
    NSError *error = nil;
    NSData *dataDict = [NSJSONSerialization dataWithJSONObject:self.params options:NSJSONWritingPrettyPrinted error:&error];
    PRINT_STRING(self.params);
    if (![dataDict length] || error) {
        dataDict = [NSData data];
    }
    
    NSUInteger length = [dataDict length];
    
    NSMutableData *dataFinal = [NSMutableData dataWithBytes:&length length:4];
    // 用于制造失败测试
//    int x = arc4random() % 300;
//    if (x <= 50)
//    {
//        [dataFinal appendData:dataDict];
//    }
    [dataFinal appendData:dataDict];
    [dataFinal appendData:uploadDataNeeded];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *managaer = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlString = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingFormat:@"/api%@", self.action];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    
    __block typeof(self) blockSelf = self;

    self.uploadTask = [managaer uploadTaskWithRequest:request fromData:dataFinal progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        BOOL isSuccess = NO;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            isSuccess = [[responseObject objectForKey:@"code"] integerValue] == 2000;
        }
        
        if (!isSuccess) {
            if (blockSelf.retryCount < maxFailToRetryCount) {
                // 继续尝试
                blockSelf.retryCount ++;
                [blockSelf uploadPackage];
                return;
            }
            
            if (self.failBlock)
            {
                self.failBlock(M_V_NetworkBad);
                [self clearCompletionBlock];
            }
            return;
        }
        
        // 成功 处理
        blockSelf.retryCount = 0;
        
        blockSelf.srcOffset = [[responseObject im_valueNumberForKey:la_fileSize] longValue];
        blockSelf.params[DICT_srcOffset] = @(blockSelf.srcOffset);
        blockSelf.params[DICT_fileUrl] = [responseObject im_valueStringForKey:DICT_fileUrl];
        
        if (blockSelf.srcOffset + dataPerByte >= [blockSelf.totalData length]) {
            blockSelf.params[DICT_fileStatus] = @1;
            
        }
        
        !self.progressBlock ?: self.progressBlock(1.0 * blockSelf.srcOffset / self.totalData.length);
        
        if (blockSelf.srcOffset < [blockSelf.totalData length]) {
            [blockSelf uploadPackage];
            return;
        }
        
        self.uploadModel.fileUrl = [responseObject im_valueStringForKey:DICT_fileUrl];
        self.uploadModel.thumbnailWidth  = [[responseObject im_valueNumberForKey:DICT_thumbnailWidth] doubleValue];
        self.uploadModel.thumbnailHeight = [[responseObject im_valueNumberForKey:DICT_thumbnailHeight] doubleValue];
        self.uploadModel.fileSize = [[responseObject im_valueNumberForKey:DICT_fileSize] longValue];
        self.uploadModel.thumbnail =  [responseObject im_valueStringForKey:DICT_thumbnail];
        
        if (self.finishBlock)
        {
            self.finishBlock();
            [self clearCompletionBlock];
        }
    }];
    
    if (self.uploadAutomatic)
    {
        [self.uploadTask resume];
    }
}

- (void)resumeTaskWithCompletionHandler:(IMUploadTaskCompletedBlock)completedBlock progress:(IMUploadTaskProgressBlock)progressBlock failure:(IMUploadTaskFailedBlock)failedBlock {
    self.finishBlock   = completedBlock;
    self.progressBlock = progressBlock;
    self.failBlock     = failedBlock;

    self.uploadAutomatic = YES;
    [self.uploadTask resume];
}

// 打破循环引用
- (void)clearCompletionBlock {
    self.finishBlock = nil;
    self.failBlock = nil;
    self.progressBlock = nil;
}

- (AttachmentUploadModel *)getAttachModel
{
    return self.uploadModel;
}

@end
