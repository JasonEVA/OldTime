//
//  AttachmentUploadModel.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/18.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  IM中附近上传专用model

#import <Foundation/Foundation.h>

// JSON字段
#define DICT_srcOffset         @"srcOffset"
#define DICT_fileUrl           @"fileUrl"
#define DICT_fileName          @"fileName"
#define DICT_fileSize          @"fileSize"
#define DICT_fileStatus        @"fileStatus"
#define DICT_thumbnail         @"thumbnail"
#define DICT_audioLength       @"audioLength"    // 音频时长
#define DICT_videoLength       @"videoLength"    // 视频时长
#define DICT_thumbnailWidth    @"thumbnailWidth"
#define DICT_thumbnailHeight   @"thumbnailHeight"

typedef enum
{
    attachment_audio,
    attachment_video,
    attachment_image,
}AttachmentType;

@interface AttachmentUploadModel : NSObject

@property (nonatomic,strong) NSData *dataAll;       // 总数据

#pragma mark - Input
@property (nonatomic,strong) NSString *fileName;	//图片名称	string	必填
@property (nonatomic)        NSInteger srcOffset;	//起始位置	int	必填	第一次传0
@property (nonatomic,strong) NSString *fileUrl;     //图片服务器地址	string	选填	第一次传可不填
@property (nonatomic)        NSInteger fileStatus;	//件状态	int	必填	0：表示后面仍有数据，1：代表结束
//@property (nonatomic)        BOOL      isAudio;     // 音频OR图片
@property (nonatomic)  AttachmentType  attachmentType; // 附件类型
#pragma mark - Output
@property (nonatomic       ) long      fileSize;//附件大小	int	必要	服务器已上传成功的数据大小
@property (nonatomic,strong) NSString  *thumbnail;//缩略图地址	string	否	如果是图片，服务器缩略图地址
@property (nonatomic       ) NSInteger audioLength;// 音频时长
@property (nonatomic, assign) double thumbnailWidth;
@property (nonatomic, assign) double thumbnailHeight;

/**
 *  应用层传入的初始化，准备上传附件
 *
 *  @param data     附件的二进制
 *  @param fileName 附近名称（含后缀，例：party.png）
 *
 *  @return AttachmentUploadModel
 */
- (id)initWithFile:(NSData *)data fileName:(NSString *)fileName type:(AttachmentType)type;

/**
 *  应用层传入的音频数据初始化，准备上传附件
 *
 *  @param amrPath amr音频文件的沙盒路径
 *
 *  @return AttachmentUploadModel
 */
- (id)initWithPath:(NSString *)Path type:(AttachmentType)type;

/**
 *  为发送socket输出JSON语句
 *
 *  @return "{\"fileName\":\"emoji.jpg\",\"fileSize\":95709,\"thumbnail\":\"/attachment/20150430/guid.jpg\",\"fileUrl\":\"/attachment/20150430/guid.jpg\"}"
 */
- (NSString *)getJsonStringForSocket;

/**
 *  为发送AudioSocket输出JSON语句
 *
 *  @return "{\"fileUrl\":\"/attachment/20150430/guid.mp4\",\"audioLength\":3}"
 */
- (NSString *)getJsonStringForAudioSocket;

/**
 *  为发送VideoSocket输出JSON语句
 *
 *  @return "{\"fileUrl\":\"/attachment/20150430/guid.mp4\",\"fileSize\":95709,\"videoLength\":12,\"thumbnail\":\"/attachment/20150430/guid.jpg\"}"
 */
- (NSString *)getJsonStringForVideoSocket;

@end
