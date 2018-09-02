//
//  StreamRecordViewController.h
//  DemoAVFoundationCamera
//
//  Created by William Zhang on 15/6/12.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol SteamRecordViewControllerDelegate <NSObject>

// 视频录制完成
- (void)StreamRecordViewControllerDelegateCallBack_FinishRecordingVideo;

@end

@interface StreamRecordViewController : BaseViewController

@property (nonatomic, copy)  NSString  *strUid;
@property (nonatomic, weak) id<SteamRecordViewControllerDelegate> delegate;

@end
