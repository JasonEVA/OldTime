//
//  CareVoiceRecordVolumeView.h
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareVoiceRecordView : UIView

@property (nonatomic, retain) UIButton* voiceIconButton;;
@end

@interface CareVoiceRecordVolumeView : UIView

@property (nonatomic, retain) UILabel* lbDuration;

@end

@interface CareVoiceMessageView : UIView

@property (nonatomic, retain) UIControl* voiceControl;
@property (nonatomic, retain) UIButton* deleteButton;
@property (nonatomic, retain) UILabel* lbDuration;
@property (nonatomic, retain) UIImageView* ivVoice;

@end
