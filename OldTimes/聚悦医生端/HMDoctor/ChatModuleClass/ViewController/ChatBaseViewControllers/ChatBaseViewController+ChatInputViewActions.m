//
//  ChatBaseViewController+ChatInputViewActions.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatBaseViewController+ChatInputViewActions.h"
#import "UITextView+AtUser.h"
#import "ChatGroupSelectAtUserViewController.h"
#import "UIViewController+SelectPhotos.h"
#import "Slacker.h"

#define W_MAX_IMAGE (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度

@implementation ChatBaseViewController (ChatInputViewActions)

- (InputViewCustomAttachmentActionHandler)attachmentActionHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttachmentActionHandler:(InputViewCustomAttachmentActionHandler)attachmentActionHandler {
    objc_setAssociatedObject(self, @selector(attachmentActionHandler), attachmentActionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ats_inputViewCustomAttachmentActionResponse:(InputViewCustomAttachmentActionHandler)handler {
    self.attachmentActionHandler = handler;
}

#pragma mark - ChatInputViewDelegate
- (void)ChatInputViewDelegateCallBack_sendAttributeText:(NSAttributedString *)attributeText {
    NSString *text = attributeText.string;
    if (![text length]) {
        return;
    }
    
    if (![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    if (!self.isReceiptOn) {
        // 普通消息
        NSMutableArray *atUserList = [NSMutableArray array];
        
        for (NSInteger i = 0; i < text.length; i ++) {
            NSAttributedString *attriText = [attributeText attributedSubstringFromRange:NSMakeRange(i, 1)];
            if (![attriText.string isEqualToString:@"@"]) {
                continue;
            }
            
            // 是@,取出成员内容
            if (!attriText.identifier) {
                [atUserList addObject:@""];
                continue;
            }
            
            [atUserList addObject:attriText.identifier];
        }
        
        [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:text Type:msg_personal_text atUser:atUserList];
    }
    else {
        // 回执消息
        [self at_sendReceiptMsgWith:text];
    }
    
}

- (void)ChatInputViewDelegateCallBack_sendText:(NSString *)text
{
    if (text.length > 0)
    {
        if ([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) {
            [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:text Type:msg_personal_text];
        }
    }
}

// 录音按钮的委托回调
- (void)ChatInputViewDelegateCallBack_recordVoiceWithEvents:(UIControlEvents)controlEvents
{
    switch (controlEvents)
    {
        case UIControlEventTouchDown:
        {
            AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
#if TARGET_IPHONE_SIMULATOR//模拟器
                [self recordVoiceStart];
#elif TARGET_OS_IPHONE//真机
                
                //第一次询问用户是否进行授权
                
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
                    if (granted) {
                        // Microphone enabled code
                    }
                    else {
                        // Microphone disabled code
                    }
                }];
#endif
            }
            else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {// 未授权
                [self showSetAlertView];
            }
            else{// 已授权
                [self recordVoiceStart];
            }
            break;
        }
        case UIControlEventTouchUpInside:
            [self recordVoiceEnd];
            break;
            
        case UIControlEventTouchUpOutside:
            [self recordVoiceCancel];
            break;
            
        default:
            break;
    }
}

// 文本语音输入栏高度发生变化委托回调
- (void)ChatInputViewDelegateCallBack_frameChangedWithIncreasedHeight:(CGFloat)increased
{
    self.viewInputHeight = increased;
    
    [self refreshView];
    
    if (increased > 50)
    {
        if (self.arrayDisplay.count > 1)
        {
            [self.tableView scrollToRowAtIndexPath:[ NSIndexPath indexPathForRow:self.arrayDisplay.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)ChatInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark
{
    if (mark)
    {
        self.viewInputHeight += (CGRectGetHeight(self.chatInputView.frame) - H_COMMON_VIEW);
    }
    else
    {
        if (self.viewInputHeight > (CGRectGetHeight(self.chatInputView.frame) - H_COMMON_VIEW))
        {
            self.viewInputHeight -= (CGRectGetHeight(self.chatInputView.frame) - H_COMMON_VIEW);
        }
        
    }
    
    [self refreshView];
}

// 附件栏选择的委托回调
- (void)ChatInputViewDelegateCallBack_attchmentSelectedWithTag:(ChatAttachPick_tag)tag
{
    __weak typeof(self) weakSelf = self;
    switch (tag)
    {
        case tag_pick_takePhoto:
        {
            [self ats_selectPhotosFromCamera:^(NSArray<UIImage *> *photos) {
                [weakSelf p_handlerSelectedPhotos:photos];
            }];
            break;
        }
        case tag_pick_img:
        {
            [self ats_selectPhotosFromCustomAlbum:^(NSArray<UIImage *> *photos) {
                [weakSelf p_handlerSelectedPhotos:photos];
            }];
            break;
        }
        default:
            if (self.attachmentActionHandler) {
                self.attachmentActionHandler(tag);
            }
            break;
    }
}

- (void)ChatInputViewDelegateCallBack_atUser {
    // 单聊不能@人
    if (!self.groupChat) {
        return;
    }
    // 选择@人员
    // do something
    ChatGroupSelectAtUserNavigationViewController *selectAtUserVC = [[ChatGroupSelectAtUserNavigationViewController alloc] initWithGroupID:self.strUid];
    
    __weak typeof(self) weakSelf = self;
    [selectAtUserVC selectedPeople:^(ContactInfoModel *selectedPerson) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.chatInputView popupKeyboard];
        if (!selectedPerson) {
            // 点击取消返回
            return;
        }
        
        [strongSelf.chatInputView addAtUser:selectedPerson];
    }];
    
    [self presentViewController:selectAtUserVC animated:YES completion:nil];
}

#pragma mark - RMAudioManager Delegate
// 完成播放音频
- (void)RMAudioManagerDelegateCallBack_AudioDidFinishPlaying
{
    // 标记
    self.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
    self.adapter.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
}

- (void)RMAudioManagerDelegateCallBack_AudioFailedRecordWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法录音" message:@"麦克风可能损坏或者其他原因" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)RMAudioManagerDelegateCallBack_AudioFinishedRecordWithDuration:(CGFloat)duration Path:(NSString *)path
{
    if (self.audioManager.recordDuration <= 1.0f) {
        // 时间过短
        NSLog(@"时间太短，无法录音，请重试");
        return;
    }
    
    // 得到已经录制的音频路径（wav）
    NSString *strPathWav = self.audioManager.recordPath;
    
    // 转为相对路径
    NSString *relativePathWav = [[MsgFilePathMgr share] getRelativePathWithAllPath:strPathWav];
    // 下锚点
    [[MessageManager share] anchorAttachMessageType:msg_personal_voice
                                           toTarget:self.strUid
                                           nickName:self.strName
                                        primaryPath:relativePathWav
                                          minorPath:nil];
}

#pragma mark - LCVoice Method
// 开始录制
- (void)recordVoiceStart
{
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    
    // 得到路径
    NSString *strPathWav = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:strDate extension:extension_wav uid:self.strUid];
    
    // 开始录制声音到文件夹
    [self.audioManager startRecordWithPath:strPathWav ShowInView:self.view];
}

// 停止录制
- (void)recordVoiceEnd
{
    [self.audioManager stopRecord];
}

// 取消录制
- (void)recordVoiceCancel
{
    [self.audioManager cancelRecord];
    
    // 防御，判断是否已超时
    if (self.audioManager.isFromCancel && !self.audioManager.isFinishRecord)
    {
        NSLog(@"时间太短，不能录音");
    }
}

#pragma mark - Private Method
// 处理选中图片
- (void)p_handlerSelectedPhotos:(NSArray<UIImage *> *)arrayImages {
    __weak typeof(self) weakSelf = self;
    [arrayImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 压缩
        CGFloat W_img = MIN(W_MAX_IMAGE, obj.size.width);
        CGFloat H_img = (W_img / obj.size.width) * obj.size.height;
        UIImage *imgThumb =  [Slacker imageWithImage:obj scaledToSize:CGSizeMake(W_img, H_img)];
        
        [strongSelf writeImageToFilePathWithOringnalImage:obj thumbImage:imgThumb];
    }];
}

- (void)writeImageToFilePathWithOringnalImage:(UIImage *)originImage thumbImage:(UIImage *)thumbImage;
{
    // 1.文件写入沙盒
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // 得到路径
        long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
        NSString *strFileNameOriginal = [NSString stringWithFormat:@"%@origin.jpg",strDate];
        NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
        NSString *strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:self.strUid];
        NSString *strOriginPath = [strPath stringByAppendingPathComponent:strFileNameOriginal];
        NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
        
        // 写入文件夹
        [UIImageJPEGRepresentation(originImage, 0.5) writeToFile:strOriginPath atomically:YES];
        [UIImageJPEGRepresentation(thumbImage, 1.0) writeToFile:strThumbPath atomically:YES];
        
        
        // 转换成相对路径
        NSString *strRelativeOrigin = [[MsgFilePathMgr share] getRelativePathWithAllPath:strOriginPath];
        NSString *strRelativeThumb = [[MsgFilePathMgr share] getRelativePathWithAllPath:strThumbPath];
        
        // 回归主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 2. 下锚点
            [[MessageManager share] anchorAttachMessageType:msg_personal_image
                                                   toTarget:self.strUid
                                                   nickName:self.strName
                                                primaryPath:strRelativeOrigin
                                                  minorPath:strRelativeThumb];
        });
    });
}

//提示用户进行麦克风使用授权
- (void)showSetAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"麦克风权限未开启，请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - interface

@end
