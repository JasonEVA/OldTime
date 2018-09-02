//
//  ChatLeftTextTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-22.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatLeftTextTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

#define MARGE 18            // 头像距边界的距离
#define MARGE_TOP 8           // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与气泡间隔
#define W_HEADICON 42       // 头像宽度，与气泡高度一样
#define H_BUBBLE 42         // 气泡默认高度
#define MAX_W (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 文本最大宽度
#define H_NAME 15           // 姓名高度
#define CHAT_BUBBLE @"chat_left_bubble" // 气泡

@interface ChatLeftTextTableViewCell ()

@property (nonatomic) CGSize textSize;

@end

@implementation ChatLeftTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Target:(id)target ActionHead:(SEL)actionHead ActionLong:(SEL)actionLong
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGE, MARGE_TOP, W_HEADICON, W_HEADICON)];
//        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_imgViewHeadIcon];
        
        // 气泡
        _imgViewBubble = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgViewBubble];
        // 给气泡添加长按手势
        [_imgViewBubble setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:actionLong];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 文字
        _lbText = [[UILabel alloc] init];
        [_lbText setFont:[UIFont systemFontOfSize:17]];
        [_lbText setNumberOfLines:0];
        [_lbText setTextColor:[UIColor whiteColor]];
        [_lbText setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_lbText];
        
        // 姓名
        _lbName = [[UILabel alloc] initWithFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + 10, MARGE_TOP, MAX_W, H_NAME)];
        [_lbName setFont:[UIFont systemFontOfSize:11]];
        [_lbName setTextColor:[UIColor grayColor]];
        [_lbName setBackgroundColor:[UIColor clearColor]];
        
        // 时间图案
        _lbTime = [UILabel new];
        [_lbTime setFont:[UIFont systemFontOfSize:13]];
        [_lbTime setTextColor:[UIColor grayColor]];
        [self addSubview:_lbTime];
        
        //重点标记
        _imgEmphasis = [[UIImageView alloc] init];
        _imgEmphasis.userInteractionEnabled = YES;
        _imgEmphasis.image = [UIImage imageNamed:@"emphasis"];
        _imgEmphasis.hidden = YES;
        [self.contentView addSubview:_imgEmphasis];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- Interface Method
- (void)showTextMessage:(NSString *)message
{
    // 得到输入文字内容长度
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [message boundingRectWithSize:CGSizeMake(MAX_W, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    self.textSize = size;
    
    // 设置label长度
//    [_lbText setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + 20, MARGE_TOP + 5, size.width + 10, size.height + 10)];
    [_lbText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgViewHeadIcon.mas_right).offset(20);
        make.centerY.equalTo(_imgViewBubble);
        //        make.width.lessThanOrEqualTo(@(MAX_W));
        make.width.equalTo(@(size.width + 10));
        make.height.equalTo(@(size.height + 10));
    }];
    [_lbText setLineBreakMode:NSLineBreakByWordWrapping];
    [_lbText setText:message];
    
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
//    [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, MAX(_lbText.frame.size.width + 15, H_BUBBLE), MAX(_lbText.frame.size.height + 5, H_BUBBLE))];
    [_imgViewBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_lbText).offset(15);
        make.centerY.equalTo(self);
        make.left.equalTo(_lbText).offset(-10);
        make.height.equalTo(_lbText).offset(5);
    }];
    [_imgViewBubble setImage:img];
    
    [_imgEmphasis mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgViewBubble.mas_top);
        make.left.equalTo(_imgViewBubble.mas_right).offset(20);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
}

// 显示时间
- (void)showDate:(NSString *)time
{
    [_lbTime setText:time];
    [_lbTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgViewBubble.mas_right).offset(13);
        make.bottom.equalTo(_imgViewBubble);
    }];
}

// 设置头像
- (void)setHeadIconWithUrl:(NSString *)imgUrl Tag:(NSInteger)tag
{
    [_imgViewHeadIcon sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMG_PLACEHOLDER_HEAD];
    [_imgViewHeadIcon setTag:tag];
    
    [_imgViewBubble setTag:tag];
}


// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden
{
    if (!hidden)
    {
        [_lbName setText:name];
        [self.contentView addSubview:_lbName];
//        [_lbText setCenter:CGPointMake(_lbText.center.x, _lbText.center.y + 25)];
//        [_imgViewBubble setCenter:CGPointMake(_imgViewBubble.center.x, _imgViewBubble.center.y + 25)];
        
        [_imgViewBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_lbText).offset(10);
            make.top.equalTo(_lbName.mas_bottom);
            make.left.equalTo(_lbText).offset(-15);
            make.height.equalTo(_lbText).offset(5);
        }];
    }
    else
    {
        [_lbName removeFromSuperview];
        [_lbText setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + 20, MARGE_TOP + 5, _lbText.frame.size.width, _lbText.frame.size.height)];
        [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, _imgViewBubble.frame.size.width, _imgViewBubble.frame.size.height)];

    }
}
//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow
{
    if (IsShow) {
        _imgEmphasis.hidden = NO;
    }else {
        _imgEmphasis.hidden = YES;
    }
}

@end
