//
//  EventSuperTableViewCell.m
//  launcher
//
//  Created by TabLiu on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "EventSuperTableViewCell.h"
#import "UnifiedUserInfoManager.h"
#import "Category.h"
#import "MyDefine.h"

#define FONT_1 16
#define FONT_2 14
#define FONT_3 12
#define COLOR_gray [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]

@implementation EventSuperTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.bgView];
         [self.bgView addSubview:self.titleView];
        [self.titleView addSubview:self.lbKind];
        [self.bgView addSubview:self.eventContentLabel];
        [self.bgView addSubview:self.eventStatusLabel];
        [self.bgView addSubview:self.line1];
        [self.contentView addSubview:self.redpoint];
        
        [self.contentView addSubview:self.eventTypeLabel];
        [self.contentView addSubview:self.sendManLabel];
        [self.contentView addSubview:self.sendTimeLabel];
        [self.contentView addSubview:self.fromLabel];
        [self.contentView addSubview:self.eventTypeIconImage];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)setReadHidden
{
    self.redpoint.hidden = YES;
}

- (void)setEventSendManLabel:(NSString *)name
{
    NSString * str ;
//    NSLocale *locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
//    
//    NSRange range = [locale.localeIdentifier rangeOfString:@"ja"];
    BOOL isJap = YES;
    NSString * string = LOCAL(FROM);
    if ([string isEqualToString:@"来自"]) {
        isJap = NO;
    }
    
    if (isJap) {
        // 日文
        str = [NSString stringWithFormat:@"%@  %@",name,LOCAL(FROM)];
    }else {
        str = [NSString stringWithFormat:@"%@  %@",LOCAL(FROM),name];
    }
    NSAttributedString * attString = [self getAttStringWithString:str str:name];
    self.sendManLabel.attributedText = attString;
}

- (NSMutableAttributedString *)getAttStringWithString:(NSString *)string str:(NSString *)str
{
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableString * muString = [[NSMutableString alloc] initWithString:string];
    // 设置 来自 的颜色 大小
    NSRange FromRang = [muString rangeOfString:LOCAL(FROM) options:NSLiteralSearch];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_2] range:FromRang];
    [attString addAttribute:NSForegroundColorAttributeName value:COLOR_gray range:FromRang];
    // 设置 发送人名字 的颜色大小
    NSRange nameRang = [muString rangeOfString:str options:NSLiteralSearch];

    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_2] range:nameRang];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:136/255.0 blue:1 alpha:1] range:nameRang];
    
    return attString;
}

- (void)setEventLabelTextWithEventStatusType:(NSString *)type
{
    NSString * str = @"";
    UIColor * color = nil;
    
    if ([type isEqualToString:pass]) {
        color = [UIColor colorWithRed:36/255.0 green:183/255.0 blue:82/255.0 alpha:1];
        str = LOCAL(APPLY_SENDER_ACCEPT_TITLE);
    } else if ([type isEqualToString:pending]) {
        color = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1];
        str = LOCAL(APPLY_SENDER_WAITDEAL_TITLE);
    }else if ([type isEqualToString:ongoing]) {
        str = @"进行中";
        color = [UIColor colorWithRed:15/255.0 green:126/255.0 blue:244/255.0 alpha:1];
    } else if ([type isEqualToString:unPass]) {
        str = @"不通过";
        color = [UIColor colorWithRed:251/255.0 green:19/255.0 blue:84/255.0 alpha:1];
    } else if ([type isEqualToString:Back_to]) {
        str = LOCAL(APPLY_SENDER_BACKWARD_TITLE);
        color = [UIColor colorWithRed:251/255.0 green:19/255.0 blue:84/255.0 alpha:1];
    }
    
    self.eventStatusLabel.text = str;
    self.eventStatusLabel.textColor = color;
}

-(void)setLabelKindNale:(NSString *)name
{
    self.lbKind.text=name;
    
}

#pragma mark - frome

- (void)updateConstraints
{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.equalTo(@40);
    }];
    [self.lbKind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleView).offset(-12);
        make.centerY.equalTo(self.titleView);
        make.height.equalTo(@40);
      
    }];
    [self.line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(40);
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.height.equalTo(@1);
    }];
    [self.eventContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView).offset(10);
    }];
    [self.eventStatusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.eventContentLabel);
        make.left.equalTo(self.eventContentLabel.mas_right).offset(5);
    }];
    
    [self.eventTypeIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(23);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [self.eventTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eventTypeIconImage.mas_right).offset(5);
        make.centerY.equalTo(self.eventTypeIconImage.mas_centerY);
    }];
    [self.fromLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendManLabel.mas_left).offset(-7);
        make.centerY.equalTo(self.eventTypeIconImage.mas_centerY);
    }];
    
    [self.sendManLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendTimeLabel.mas_left).offset(-15);
        make.centerY.equalTo(self.eventTypeIconImage.mas_centerY);
    }];
    [self.sendTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-23);
        make.centerY.equalTo(self.eventTypeIconImage.mas_centerY);
//        make.width.lessThanOrEqualTo(@80);
    }];
    
    [self.redpoint mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(11);
        make.right.equalTo(self.bgView).offset(3);
        make.top.equalTo(self.bgView).offset(-3);
    }];
    [super updateConstraints];
}


#pragma mark - UI

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.userInteractionEnabled = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.borderColor = [UIColor mtc_colorWithHex:0xf6d4ae].CGColor;
        _bgView.clipsToBounds = YES;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}
- (UIImageView *)titleView
{
    if (!_titleView)
    {
        _titleView = [[UIImageView alloc] init];
       
        [_titleView setImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xfbf6ee]]];
        [_titleView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _titleView.clipsToBounds = YES;
    }
    return _titleView;
}

-(UILabel*)lbKind
{
    if (!_lbKind) {
        _lbKind=[[UILabel alloc]init];
        [_lbKind setFont:[UIFont mtc_font_30]];
        [_lbKind setTextColor:[UIColor mtc_colorWithHex:0xffa020]];
        [_lbKind setTextAlignment:NSTextAlignmentRight];
        [_lbKind setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_lbKind setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _lbKind;
    
}
- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor mtc_colorWithHex:0xf6d4ae];
    }
    return _line1;
}

- (UILabel *)eventContentLabel
{
    if (!_eventContentLabel) {
        _eventContentLabel = [[UILabel alloc] init];
        _eventContentLabel.font = [UIFont systemFontOfSize:FONT_1];
        _eventContentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _eventContentLabel;
}
- (UILabel *)eventStatusLabel
{
    if (!_eventStatusLabel) {
        _eventStatusLabel = [[UILabel alloc] init];
        _eventStatusLabel.font = [UIFont systemFontOfSize:FONT_2];
        _eventStatusLabel.textAlignment = NSTextAlignmentRight;
        _eventStatusLabel.hidden = YES;
    }
    return _eventStatusLabel;
}

- (UILabel *)eventTypeLabel
{
    if (!_eventTypeLabel) {
        _eventTypeLabel = [[UILabel alloc] init];
        _eventTypeLabel.font = [UIFont systemFontOfSize:FONT_2];
        _eventTypeLabel.textAlignment = NSTextAlignmentLeft;
        _eventTypeLabel.textColor = COLOR_gray;
    }
    return _eventTypeLabel;
}

- (UILabel *)sendManLabel
{
    if (!_sendManLabel) {
        _sendManLabel = [[UILabel alloc] init];
        _sendManLabel.font = [UIFont systemFontOfSize:FONT_2];
        _sendManLabel.textAlignment = NSTextAlignmentLeft;
        _sendManLabel.textColor = [UIColor colorWithRed:0 green:136/255.0 blue:1 alpha:1];
    }
    return _sendManLabel;
}

- (UILabel *)sendTimeLabel
{
    if (!_sendTimeLabel) {
        _sendTimeLabel = [[UILabel alloc] init];
        _sendTimeLabel.font = [UIFont systemFontOfSize:FONT_2];
        _sendTimeLabel.textAlignment = NSTextAlignmentRight;
        _sendTimeLabel.textColor = COLOR_gray;
    }
    return _sendTimeLabel;
}

- (UILabel *)fromLabel
{
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textAlignment = NSTextAlignmentLeft;
        _fromLabel.font = [UIFont systemFontOfSize:FONT_2];
        _fromLabel.textColor = COLOR_gray;
        _fromLabel.text = LOCAL(FROM);
        _fromLabel.hidden = YES;
    }
    return _fromLabel;
}
- (UIImageView *)eventTypeIconImage
{
    if (!_eventTypeIconImage) {
        _eventTypeIconImage = [[UIImageView alloc] init];
        _eventTypeIconImage.image = [UIImage imageNamed:@"chat_search_app"];
        _eventTypeIconImage.userInteractionEnabled = YES;
    }
    return _eventTypeIconImage;
}


- (RedPoint *)redpoint
{
    if (!_redpoint) {
        _redpoint = [[RedPoint alloc] init];
        [_redpoint setHidden:YES];
    }
    return _redpoint;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
