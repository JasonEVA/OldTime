//
//  HMNewDoctorCareAlterVoiceTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewDoctorCareAlterVoiceTableViewCell.h"

#define MAX_W    (200 *(ScreenWidth / 375))           // 最大宽度

@interface HMNewDoctorCareAlterVoiceTableViewCell ()
@property (nonatomic, strong) UIButton *voiceBtn;                //语音view
@property (nonatomic, copy) playVoice playVoiceBlock;
@property (nonatomic, strong) UILabel *voiceLenthLb;
@property (nonatomic, strong) MASConstraint *constraintBubbleWidth;

@end

@implementation HMNewDoctorCareAlterVoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.voiceBtn];
        [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@45);
            self.constraintBubbleWidth = make.width.equalTo(@50);
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.voiceBtn addSubview:self.voiceLenthLb];
        [self.voiceLenthLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.voiceBtn);
            make.right.equalTo(self.voiceBtn).offset(-10);
        }];
    }
    return self;
}

- (void)fillDataWithVoiceLenth:(NSString *)lenth {
    if (lenth.floatValue > 0) {
        NSInteger intger = MAX(lenth.integerValue, 1) ;
        [self.voiceLenthLb setText:[NSString stringWithFormat:@"%ld'",(long)intger]];
    }
    else {
        [self.voiceLenthLb setText:@""];
    }
    NSInteger bubbleWidth = lenth.integerValue * 5 + 80;
    CGFloat maxWidth = MAX_W;
    self.constraintBubbleWidth.offset = MIN(bubbleWidth, maxWidth);
    [self.voiceBtn layoutIfNeeded];

}

- (void)playVoiceClick {
    if (self.playVoiceBlock) {
        self.playVoiceBlock();
    }
}

- (void)playVoiceClickBlock:(playVoice)block {
    self.playVoiceBlock = block;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 42)];
        [_voiceBtn.layer setCornerRadius:10];
        [_voiceBtn setClipsToBounds:YES];
        [_voiceBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_voiceBtn addSubview:self.voiceImages];
        [_voiceBtn addTarget:self action:@selector(playVoiceClick) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceImages mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_voiceBtn).with.offset(10);
            make.centerY.equalTo(_voiceBtn);
        }];
    }
    return _voiceBtn;
}

- (UIImageView *)voiceImages {
    if (!_voiceImages) {
        _voiceImages = [UIImageView new];
        [_voiceImages setImage:[UIImage imageNamed:@"icon_voice_1"]];
        
        [_voiceImages setAnimationImages:@[[UIImage imageNamed:@"icon_voice_3"],
                                           [UIImage imageNamed:@"icon_voice_2"],
                                           [UIImage imageNamed:@"icon_voice_1"],
                                           ]];
        
        _voiceImages.animationDuration = 1.5;
        _voiceImages.animationRepeatCount = 0;
    }
    return _voiceImages;
}

- (UILabel *)voiceLenthLb {
    if (!_voiceLenthLb) {
        _voiceLenthLb = [UILabel new];
        [_voiceLenthLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_voiceLenthLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _voiceLenthLb;
}
@end
