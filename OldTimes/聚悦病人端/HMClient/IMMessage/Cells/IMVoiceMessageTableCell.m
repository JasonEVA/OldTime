//
//  IMVoiceMessageTableCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMVoiceMessageTableCell.h"

@interface IMVoiceMessageTableCell ()
{
    UILabel* lbDuration;
}
@end

@implementation IMVoiceMessageTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDuration = [[UILabel alloc]init];
        [self.contentView addSubview:lbDuration];
        [lbDuration setFont:[UIFont font_20]];
        [lbDuration setTextColor:[UIColor commonGrayTextColor]];
        
        [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgview);
        }];
        
        _ivVoice = [[UIImageView alloc] init];
        [msgview addSubview:_ivVoice];
    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    
    if (message._markFromReceive)
    {
        [_ivVoice setImage:[UIImage imageNamed:@"chat_left_voice3"]];
        [_ivVoice setAnimationImages:@[[UIImage imageNamed:@"chat_left_voice1"],
                                       [UIImage imageNamed:@"chat_left_voice2"],
                                       [UIImage imageNamed:@"chat_left_voice3"],
                                       ]];
        
        [_ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(msgview);
            make.left.equalTo(msgview).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }else
    {

        [_ivVoice setImage:[UIImage imageNamed:@"chat_right_voice3"]];
        [_ivVoice setAnimationImages:@[[UIImage imageNamed:@"chat_right_voice1"],
                                       [UIImage imageNamed:@"chat_right_voice2"],
                                       [UIImage imageNamed:@"chat_right_voice3"],
                                       ]];
        
        [_ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(msgview);
            make.right.equalTo(msgview).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    _ivVoice.animationDuration = 1.0;
    _ivVoice.animationRepeatCount = 0;
    
    
    MessageAttachmentModel* attachModel = message.attachModel;
    if (attachModel)
    {
        NSLog(@"voice length %ld", attachModel.audioLength);
    }
    
    [lbDuration setText:[NSString stringWithFormat:@"%ld\"", attachModel.audioLength]];
    
    [lbDuration mas_updateConstraints:^(MASConstraintMaker *make) {
        if (message._markFromReceive)
        {
            make.left.equalTo(msgview.mas_right).with.offset(4);
        }
        else
        {
            make.right.equalTo(msgview.mas_left).with.offset(-4);
        }
    }];
}
@end
