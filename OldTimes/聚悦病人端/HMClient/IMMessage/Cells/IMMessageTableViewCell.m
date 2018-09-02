//
//  IMMessageTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMMessageTableViewCell.h"


@implementation IMMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMessage:(MessageBaseModel*) message
{
    
}
- (void)configSenderInfo:(UserProfileModel *)senderProfile {

}

@end

@implementation IMBubbleMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        lbSendTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbSendTime];
        [lbSendTime setBackgroundColor:[UIColor commonLightGrayTextColor]];
        [lbSendTime setTextColor:[UIColor whiteColor]];
        [lbSendTime setFont:[UIFont font_24]];
        
        [lbSendTime.layer setCornerRadius:2.5];
        [lbSendTime.layer setMasksToBounds:YES];
        
        [lbSendTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(6);
        }];
        
        ivPortrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_photo"]];
        ivPortrait.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivPortrait.layer.borderWidth = 0.5;
        ivPortrait.layer.cornerRadius = 37.0/2;
        ivPortrait.layer.masksToBounds = YES;
        
        [self.contentView addSubview:ivPortrait];
        [ivPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(37, 37));
            make.top.equalTo(lbSendTime.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbSenderName = [[UILabel alloc]init];
        [self.contentView addSubview:lbSenderName];
        [lbSenderName setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbSenderName setFont:[UIFont font_26]];
        
        [lbSenderName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ivPortrait);
            make.width.lessThanOrEqualTo(@60);
            make.top.equalTo(ivPortrait.mas_bottom).with.offset(7);
        }];
        
        msgview = [[UIControl alloc]init];
        [self.contentView addSubview:msgview];
        [msgview addTarget:self action:@selector(msgviewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [msgview mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.width.mas_equalTo(@65);
            make.top.equalTo(ivPortrait);
            //make.bottom.equalTo(self.contentView);
        }];
        
        ivBubble = [[UIImageView alloc]init];
        [msgview addSubview:ivBubble];
        [ivBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(msgview);
            make.top.and.bottom.equalTo(msgview);
        }];
        
    }
    return self;
}

- (CGRect) bubbleFrame
{
    return msgview.frame;
}

- (void) msgviewClicked:(id) sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imMessageCellClicked:)])
    {
        [self.delegate imMessageCellClicked:self];
    }
}

// 发送者信息
- (void)configSenderInfo:(UserProfileModel *)senderProfile {
    [super configSenderInfo:senderProfile];
    if (senderProfile)
    {
        [lbSenderName setText:senderProfile.nickName];
        NSString* avatar = [[CommonFuncs picUrlPerfix] stringByAppendingPathComponent:senderProfile.avatar];
        [ivPortrait sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"img_default_photo"]];
    }
    else
    {
        [lbSenderName setText:@""];
        [ivPortrait setImage:[UIImage imageNamed:@"img_default_photo"]];
    }

}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    [lbSendTime setText:[NSDate im_dateFormaterWithTimeInterval:message._createDate]];
    NSString* defaultPortraitName = @"img_default_photo";
    
    if (message._markFromReceive)
    {
        defaultPortraitName = @"icon_default_staff";
        [ivBubble setImage:[UIImage imageNamed:@"bg_dialogbox"]];
    }
    else
    {
        [ivBubble setImage:[UIImage imageNamed:@"bg_dialogbox_r"]];
    }
    
    
    CGFloat bubbleWidth = [message bubbleWidth];
    CGFloat bubbleHeight = [message bubbleHeight];
    
    
    [ivPortrait mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37, 37));
        make.top.equalTo(lbSendTime.mas_bottom).with.offset(10);
        if (message._markFromReceive)
        {
            make.left.equalTo(self.contentView).with.offset(12.5);
        }
        else
        {
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }
    }];
    
    
    
    [msgview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleHeight));
        if (message._markFromReceive)
        {
            make.left.equalTo(ivPortrait.mas_right).with.offset(5.5);
           
        }
        else
        {
            
            make.right.equalTo(ivPortrait.mas_left).with.offset(-5.5);
           
           
        }
        //make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleHeight));
    }];
    
    
    
}

@end

@implementation IMCardMessageTableViewCell

@end
