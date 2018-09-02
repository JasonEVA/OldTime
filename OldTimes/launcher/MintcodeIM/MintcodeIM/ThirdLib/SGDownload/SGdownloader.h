//
//  SGdownloader.h
//  downloadManager
//
//  Created by Htain Lin Shwe on 11/7/12.
//  Copyright (c) 2012 Edenpod. All rights reserved.
//

#import <Foundation/Foundation.h>

//for block

typedef void (^SGDownloadProgressBlock)(float progressValue,NSInteger percentage);
typedef void (^SGDowloadFinished)(NSData* fileData);
typedef void (^SGDownloadFailBlock)(NSError*error);


@protocol SGdownloaderDelegate <NSObject>

@required

-(void)SGDownloadFail:(NSError*)error;
- (void)SGDownloadFail:(NSError *)error withID:(NSInteger)ID;

@optional

-(void)SGDownloadFinished:(NSData*)fileData;
-(void)SGDownloadFinished:(NSData *)fileData withID:(NSInteger)ID;              // 用于多线程时ID区分
-(void)SGDownloadProgress:(float)progress Percentage:(float)percentage;

@end

@interface SGdownloader : NSObject <NSURLConnectionDataDelegate>

//properties
@property (nonatomic,readonly) NSMutableData* receiveData;
@property (nonatomic,readonly) float downloadedPercentage;
@property (nonatomic,readonly) float progress;
@property (nonatomic) NSInteger URLID;

@property (nonatomic,strong) id <SGdownloaderDelegate> delegate;

//initwith file URL and timeout
-(id)initWithURLForGet:(NSURL *)fileURL timeout:(NSInteger)timeout URL_ID:(NSInteger)URL_ID;    // 为GET方式服务

-(id)initWithURL:(NSURL *)fileURL timeout:(NSInteger)timeout dict:(NSDictionary *)dict;      // 为POST方式服务

// 上传普通头像等附件使用
- (id)initWithURL:(NSURL *)fileURL timeout:(NSInteger)timeout Data:(NSData *)data;

-(void)startWithDownloading:(SGDownloadProgressBlock)progressBlock onFinished:(SGDowloadFinished)finishedBlock onFail:(SGDownloadFailBlock)failBlock;

-(void)startWithDelegate:(id<SGdownloaderDelegate>)delegate;
-(void)cancel;

@end
