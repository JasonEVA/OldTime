//
//  ChatRightVoipTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/5/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatRightVoipTableViewCell.h"
#import "NSString+Unified.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface ChatRightVoipTableViewCell ()

@property (nonatomic, strong) UILabel *voipLabel;

@end

@implementation ChatRightVoipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.wz_contentView addSubview:self.voipLabel];
        
        [self.voipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgViewBubble).insets(UIEdgeInsetsMake(10, 10, 10, 15));
        }];
    }
    return self;
}

- (void)setData:(MessageBaseModel *)model {
    [super setData:model];
    
    NSString *title = @"";
    
    MessageVoipModel *voipModel = model.voipModel;
    
    switch (voipModel.state) {
        case MTVoipStateAudioCancel:
            title = @"对方已取消 语音聊天";
            break;
        case MTVoipStateAudioFinish:
            title = [NSString stringWithFormat:@"语音时长 %@", [NSString wz_formateFromSeconds:voipModel.audioLength]];
            break;
        case MTVoipStateAudioRefuse:
            title = @"对方已拒绝 语音聊天";
            break;
        case MTVoipStateVideoCancel:
            title = @"已取消 视频聊天";
            break;
        case MTVoipStateVideoFinish:
            title = [NSString stringWithFormat:@"视频时长 %@", [NSString wz_formateFromSeconds:voipModel.videoLength]];
            break;
        case MTVoipStateVideoRefuse:
            title = @"对方已拒绝 视频聊天";
            break;
    }
    
    self.voipLabel.text = title;
}

#pragma mark - Initializer
- (UILabel *)voipLabel {
    if (!_voipLabel) {
        _voipLabel = [UILabel new];
        
        [_voipLabel setTextColor:ChatBubbleRightConfigShare.textColor];
        [_voipLabel setFont:[UIFont mtc_font_30]];
    }
    
    return _voipLabel;
}

@end
