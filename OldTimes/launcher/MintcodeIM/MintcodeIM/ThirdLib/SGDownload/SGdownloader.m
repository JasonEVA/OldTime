//
//  SGdownloader.m
//  downloadManager
//
//  Created by saturngod on 11/7/12.
//

#import "SGdownloader.h"
#import <MJExtension/MJExtension.h>
#import "MsgUserInfoMgr.h"

@interface SGdownloader()
@property (nonatomic,assign) float receiveBytes;
@property (nonatomic,assign) float exceptedBytes;
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) NSURLConnection *connection;

//for block
@property (nonatomic,strong) SGDownloadProgressBlock progressDownloadBlock;
@property (nonatomic,strong) SGDowloadFinished progressFinishBlock;
@property (nonatomic,strong) SGDownloadFailBlock progressFailBlock;

@end

@implementation SGdownloader
@synthesize receiveData = _receiveData;
@synthesize request = _request;
@synthesize connection = _connection;
@synthesize downloadedPercentage = _downloadedPercentage;
@synthesize receiveBytes;
@synthesize exceptedBytes;
@synthesize progress = _progress;
@synthesize progressFailBlock = _progressFailBlock;
@synthesize progressDownloadBlock = _progressDownloadBlock;
@synthesize progressFinishBlock = _progressFinishBlock;
@synthesize delegate = _delegate;

-(id)initWithURL:(NSURL *)fileURL timeout:(NSInteger)timeout dict:(NSDictionary *)dict
{
    self = [super init];
    
    if(self)
    {
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
        
        self.request = [[NSMutableURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
        
        [self.request setHTTPMethod:@"post"];
        [self.request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
        [self.request setHTTPBody:[dict mj_JSONData]];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.URLID = -10;    // 用于区分是那个对象委托过来的 <0 代表对方不需要ID
    }
    
    return self;
}

// 上传头像等附件使用
- (id)initWithURL:(NSURL *)fileURL timeout:(NSInteger)timeout Data:(NSData *)data
{
    self = [super init];
    
    if(self)
    {
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
        
        self.request = [[NSMutableURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
        
        [self.request setHTTPMethod:@"post"];
        [self.request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
        [self.request setHTTPBody:data];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.URLID = -10;    // 用于区分是那个对象委托过来的 <0 代表对方不需要ID
    }
    
    return self;
}

// 为GET方式服务
- (id)initWithURLForGet:(NSURL *)fileURL timeout:(NSInteger)timeout URL_ID:(NSInteger)URL_ID
{
    self = [super init];
    
    if(self)
    {
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
        
        self.request = [[NSMutableURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];
        
        NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@;Version=iOS",[[MsgUserInfoMgr share] getAppName], [[MsgUserInfoMgr share] getUid]];
        [self.request setHTTPShouldHandleCookies:YES];
        [self.request setAllHTTPHeaderFields:@{@"Cookie":string}];

        [self.request setHTTPMethod:@"get"];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.URLID = URL_ID;    // 用于区分是那个对象委托过来的 <0 代表对方不需要ID
    }
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    
    NSInteger len = [data length];
    receiveBytes = receiveBytes + len;
    
    if(exceptedBytes != NSURLResponseUnknownLength)
    {
        // 得到进度条百分比
        _progress = ((receiveBytes/(float)exceptedBytes) * 100)/100;
        // 转换成百分比
//        _downloadedPercentage = _progress * 100;
        _downloadedPercentage = receiveBytes;
        
        if([_delegate respondsToSelector:@selector(SGDownloadProgress:Percentage:)])
        {
            [_delegate SGDownloadProgress:_progress Percentage:_downloadedPercentage];
        }
        else {
            if(_progressDownloadBlock) {
                _progressDownloadBlock(_progress,_downloadedPercentage);
            }
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //return back error
    if (self.URLID)
    {
        if([_delegate respondsToSelector:@selector(SGDownloadFail:)])
        {
            [_delegate SGDownloadFail:error];
        }
        else {
            if(_progressFailBlock) {
                _progressFailBlock(error);
            }
        }
    }
    else
    {
        if([_delegate respondsToSelector:@selector(SGDownloadFail:withID:)])
        {
            [_delegate SGDownloadFail:error withID:self.URLID];
        }
        else {
            if(_progressFailBlock) {
                _progressFailBlock(error);
            }
        }
    }
    
    // 释放delegate
    _delegate = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    exceptedBytes = [response expectedContentLength];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    if (self.URLID < 0)     // 如果对方不需要ID
    {
        if([_delegate respondsToSelector:@selector(SGDownloadFinished:)])
        {
            [_delegate SGDownloadFinished:_receiveData];
        }
        else {
            if(_progressFinishBlock) {
                _progressFinishBlock(_receiveData);
            }
        }
    }
    else        // 对方需要ID
    {
        if ([_delegate respondsToSelector:@selector(SGDownloadFinished:withID:)])
        {
            [_delegate SGDownloadFinished:_receiveData withID:self.URLID];
        }
        else {
            if(_progressFinishBlock) {
                _progressFinishBlock(_receiveData);
            }
        }
    }
    
    // 释放delegate
    _delegate = nil;
}

#pragma mark - properties
// 开始下载
-(void)startWithDelegate:(id<SGdownloaderDelegate>)delegate {
    _delegate = delegate;
    if(self.connection) {
        [self.connection start];
        _progressDownloadBlock= nil;
        _progressFinishBlock = nil;
        _progressFailBlock = nil;
    }
}
-(void)startWithDownloading:(SGDownloadProgressBlock)progressBlock onFinished:(SGDowloadFinished)finishedBlock onFail:(SGDownloadFailBlock)failBlock {
    if(self.connection) {
        [self.connection start];
        _delegate = nil; //clear delegate
        _progressDownloadBlock = [progressBlock copy];
        _progressFinishBlock = [finishedBlock copy];
        _progressFailBlock = [failBlock copy];
    }
    
}
-(void)cancel {
    if(self.connection) {
        [self.connection cancel];
    }
}
@end
