//
//  AttachmentUploadRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "AttachmentUploadRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+SafeManager.h"
#import "ApplicationAttachmentModel.h"
#import "NetworkManager.h"
#import "MyDefine.h"

static NSUInteger const dataPerByte = 512000; // 单个包大小（500KB）
static NSUInteger const maxFailToRetryCount = 3;

static NSString * const la_response    = @"Body.response";
static NSString * const  la_isSuccess  = @"Body.response.IsSuccess";
static NSString * const  la_reason     = @"Body.response.Reason";
static NSString * const  la_data       = @"Body.response.Data";

static NSString * const d_fileName   = @"fileName";
static NSString * const d_srcOffset  = @"srcOffset";
static NSString * const d_filePath   = @"filePath";
static NSString * const d_fileStatus = @"fileStatus";
static NSString * const d_appShowID  = @"appShowID";

static NSString * const r_showId = @"ShowID";
static NSString * const r_title  = @"title";
static NSString * const r_path   = @"path";
static NSString * const r_size   = @"size";

@interface AttachmentUploadResponse ()

@property (nonatomic, assign) NSInteger inlineIdentifier;

@end

@implementation AttachmentUploadResponse

- (NSInteger)identifier { return self.inlineIdentifier;}

@end

@interface AttachmentUploadRequest ()

@property (nonatomic, strong) NSData *totalData;

@property (nonatomic, weak) id<BaseRequestDelegate> delegate;

@property (nonatomic, assign) NSUInteger srcOffset;
@property (nonatomic, assign) NSUInteger retryCount;

/**
 *  是否是上传头像模式，默认不是
 */
@property (nonatomic, assign) BOOL uploadAvatar;

@end

@implementation AttachmentUploadRequest

- (NSString *)api { return self.uploadAvatar ? @"/Base-Module/Annex/Avatar" : @"/Base-Module/Annex/Mobile";}

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.delegate = delegate;
        self.srcOffset = 0;
        self.retryCount = 0;
    }
    return self;
}

- (void)uploadImageData:(NSData *)data {
    [self uploadImageData:data appShowIdType:kAttachmentAppShowIdAvator];
}

- (void)uploadImageData:(NSData *)data appShowIdType:(AttachmentAppShowIdType)appShowIdType {
    [self uploadImageData:data appShowId:[AttachmentUtil attachmentShowIdFromType:appShowIdType]];
}

- (void)uploadImageData:(NSData *)data appShowId:(NSString *)showId {
    self.totalData = [data mutableCopy];
    
    self.params[d_fileName]  = [self fileName];
    self.params[d_srcOffset] = @0;
    self.params[d_fileStatus] = @0;
    if ([showId length]) {
        self.params[d_appShowID] = showId;
    } else {
        self.uploadAvatar = YES;
    }
    
    [self uploadPackage];
}

#pragma mark - Private Method
- (NSString *)fileName {
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *dateString = [NSString stringWithFormat:@"%lldorigin.jpg",timeStamp];
    return dateString;
}

/** 上传分包 */
- (void)uploadPackage {
    
    if ([self.totalData length] <= dataPerByte) {
        self.params[d_fileStatus] = @1;
    }
    
    NSRange range = NSMakeRange(self.srcOffset, MIN(dataPerByte, [self.totalData length] - self.srcOffset));
    
    NSData *uploadDataNeeded = [self.totalData subdataWithRange:range];
    
    /*0--3字节：INT类型，表示json用UTF-8编码转成字节数组的长度
     4--n字节：TaskDetail类型，json UTF-8编码
     n+1—结束：byte[] 多个附件 按List<Attachment>顺序存放*/
    
    [self prepareRequest];
    
    NSError *error = nil;
    NSData *dataDict = [NSJSONSerialization dataWithJSONObject:self.finalData options:NSJSONWritingPrettyPrinted error:&error];
    if (![dataDict length] || error) {
        dataDict = [NSData data];
    }
    
    NSUInteger length = [dataDict length];

    NSMutableData *dataFinal = [NSMutableData dataWithBytes:&length length:4];
    [dataFinal appendData:dataDict];
    [dataFinal appendData:uploadDataNeeded];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *managaer = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",la_URLAddress, self.api];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"post"];
    
    [NetworkManager addNetworkProgress];
    __block typeof(self) blockSelf = self;
    NSURLSessionUploadTask *uploadTask = [managaer uploadTaskWithRequest:request fromData:dataFinal progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [NetworkManager removeNetworkProgress];
        BOOL isSuccess = NO;
        NSString *errorMsg = LOCAL(ERROROTHER);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            id response = [responseObject valueDictonaryForKey:la_response];
            if ([response isKindOfClass:[NSDictionary class]]) {
                isSuccess = [responseObject valueBoolForKeyPath:la_isSuccess];
                errorMsg = [responseObject valueStringForKeyPath:la_reason];
            }
        }
        
        if (!isSuccess) {
            if (blockSelf.retryCount < maxFailToRetryCount) {
                // 继续尝试
                blockSelf.retryCount ++;
                [blockSelf uploadPackage];
                return;
            }
            
            // 超过尝试次数，失败
            if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(requestFailed:errorMessage:)]) {
                [blockSelf.delegate requestFailed:blockSelf errorMessage:errorMsg];
            }
            return;
        }
        
        // 成功 处理
        blockSelf.retryCount = 0;
        
        NSDictionary *data = [responseObject valueDictonaryForKeyPath:la_data];
        
        blockSelf.params[d_filePath] = [data valueStringForKey:r_path];
        
        blockSelf.srcOffset = [[data valueNumberForKey:r_size] unsignedIntegerValue];
        blockSelf.params[d_srcOffset] = @(blockSelf.srcOffset);
        
        if (blockSelf.srcOffset + dataPerByte >= [blockSelf.totalData length]) {
            blockSelf.params[d_fileStatus] = @1;
        }
        
        if (blockSelf.srcOffset < [blockSelf.totalData length]) {
            [blockSelf uploadPackage];
            return;
        }
        
        
        // 所有分包上传完成
        AttachmentUploadResponse *attachResponse = [AttachmentUploadResponse new];
        NSString *attachmentShowId = [data valueStringForKey:r_showId];
        attachResponse.attachmentShowId = attachmentShowId;
        attachResponse.inlineIdentifier = blockSelf.identifier;
        attachResponse.appAttachmentModel = [[ApplicationAttachmentModel alloc] initWithDict:data];
        
        if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(requestSucceeded:response:totalCount:)]) {
            [blockSelf.delegate requestSucceeded:blockSelf response:attachResponse totalCount:1];
        }
    }];
    
    [uploadTask resume];
}

@end
