//
//  NewChatShowDateTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewChatShowDateTableViewCell.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "LeftTriangle.h"
#import "Images.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AvatarUtil.h"
#import "Category.h"
#import "UIFont+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LeftTriangle.h"
#import <DateTools/DateTools.h>
#import "IMApplicationEnum.h"
#import "JSONKitUtil.h"
#import <MJExtension.h>

#define W_MAX_DATE (230 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 最大宽度
#define H_MARGIN_DATE_TOP 12
#define H_MARGIN_EVENT_TOP 3
#define H_MARGIN_DATE_BOTTOM 3
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
#define COLOR_MESSAGE_BG [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]

@interface NewChatShowDateTableViewCell()
@property (nonatomic, strong) UIImageView *imgViewHead;   //头像
@property (nonatomic, strong) UILabel *lblName;           //人名
@property (nonatomic, strong) UIView *viewContent;        //包含所有数据的view
@property (nonatomic, strong) UIView *viewTitle;          //title背景色
@property (nonatomic, strong) UILabel *lblTitle;          //title
@property (nonatomic, strong) UILabel *lblKind;    //类型
@property (nonatomic, strong) UILabel *lblTime;    //时间
@property (nonatomic, strong) UILabel *lblLine3;   //titile下面的分割线
@property (nonatomic, strong) LeftTriangle *leftTri;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *imgAttachment;
@end

@implementation NewChatShowDateTableViewCell
+ (NSString *)identifier { return NSStringFromClass(self);}

+ (CGFloat)cellHeightWithDateString:(NSString *)date {
	UIFont *font = [UIFont systemFontOfSize:13];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
	CGSize size = [(NSString *)date boundingRectWithSize:CGSizeMake(W_MAX_DATE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
	CGFloat height = size.height + H_MARGIN_DATE_TOP + H_MARGIN_DATE_BOTTOM;
	
	return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initComponent];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)initComponent
{
    [self.contentView addSubview:self.imgViewHead];
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.viewContent];
    [self.viewContent addSubview:self.viewTitle];
    [self.viewTitle addSubview:self.lblTitle];
    [self.viewTitle addSubview:self.lblKind];
    [self.viewContent addSubview:self.lblLine3];
    
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.leftTri];
    [self.viewContent addSubview:self.lblContent];
    [self.viewContent addSubview:self.imgAttachment];
}

- (void)updateConstraints
{
    
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(12);
        make.top.equalTo(self.imgViewHead);
    }];
    
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblName);
        make.height.equalTo(@90);
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.lblName.mas_bottom).offset(2);
    }];
    
    [self.viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.viewContent);
        make.height.equalTo(@40);
    }];
    
    [self.lblKind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewTitle).offset(-12);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
        //        make.width.equalTo(@50);
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTitle).offset(15);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
        make.right.equalTo(self.lblKind.mas_left).offset(-5);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.top.equalTo(self.viewContent.mas_bottom);
    }];
    
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewTitle).offset(-3);
        make.right.equalTo(self.viewTitle.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@40);
    }];
    
    [self.lblLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewTitle);
        make.height.equalTo(@1);
        make.top.equalTo(self.viewTitle.mas_bottom).offset(-1);
    }];
    
//    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lblTitle);
//        make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
//        make.right.equalTo(self.viewContent).offset(-8);
//        make.bottom.equalTo(self.viewContent).offset(-8);
//    }];
    
    [self.imgAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle);
        make.top.equalTo(self.lblLine3.mas_bottom).offset(12);
        make.width.height.equalTo(@16);
    }];
    
    [super updateConstraints];
}


#pragma mark -- Interface Method
/**
 * 更新显示的文字，会自动计算更新高度和位置，时间和时间的间隔不同
 */
- (void)showDateAndEvent:(MessageBaseModel *)baseModel ifEvent:(BOOL)ifEvent
{
	
    MessageAppModel *appModel = baseModel.appModel;
    if ([appModel.msgFrom isEqualToString:@"System"])
    {
        //设置标题
        [self.lblTitle setText:appModel.msgTitle];
        [self.lblName setText:LOCAL(IM_CHATCARD_SYSTEMMESSAGE)];
//        [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"card_system"] options:SDWebImageRefreshCached];
        [self.imgViewHead setImage:[UIImage imageNamed:@"card_system"]];
    }
    else
    {
        [self.lblName setText:appModel.msgFrom];
        //设置标题
        [self.lblTitle setText:appModel.msgContent];
        [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    }
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:baseModel._createDate appendMinute:NO]];
    
    
    NSString *text;
    if ([appModel isAppSystemMessage])
    {
        // 要显示的文字
        text = [IMApplicationUtil getMsgTextWithModel:appModel];
        
//        if ([appModel.msgTransType isEqualToString:@"taskV2ChangeStatus"] || [appModel.msgTransType isEqualToString:@"taskV2ChangeDoneStatus"] || [appModel.msgTransType isEqualToString:@"taskV2Update"] || [appModel.msgTransType isEqualToString:@"meetingEdit"] || [appModel.msgTransType isEqualToString:@"meetingCancel"] || [appModel.msgTransType isEqualToString:@"taskV2ChangeDoingStatus"] || [appModel.msgTransType isEqualToString:@"meetingRefuseAttendDefinite"])
//        {
//            text = appModel.msgTitle;
//        }
    }
    else
    {
        text = baseModel._content;
    }
    
    
    if ([baseModel.appModel.msgTransType isEqualToString:@"comment"])
    {
        self.lblKind.text = LOCAL(PLEASE_INPUT);
        NSString *str =  [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"]?:nil;
		NSArray *atUsers = [[[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"atWho"] mj_JSONObject];
	
		__block NSString *finalText = [str copy];
		[atUsers enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull atWhoDic, NSUInteger idx, BOOL * _Nonnull stop) {
			finalText = [finalText mtc_URLEncodedString];
			finalText = [finalText stringByReplacingOccurrencesOfString:atWhoDic[@"id"] withString:@" "];
			finalText = [finalText mtc_URLDecodedString];
		}];
		
		str = finalText;
        if (str != nil && str.length > 0)
        {
            text = str;
        }
        
    }
    else
    {
        self.lblKind.text = @"";
    }
    // 得到输入文字内容长度
    NSString *strfile = [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"filePath"]?:@"";
    if (strfile.length > 0)
    {
        self.imgAttachment.hidden = NO;
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20 - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        // 设置label长度
        if (size.height > 20)
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblTitle).offset(20);
                make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
                make.right.equalTo(self.viewContent).offset(-8);
                make.bottom.equalTo(self.viewContent).offset(-8);
            }];
        }
        else
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblTitle).offset(20);
                make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
                make.right.equalTo(self.viewContent).offset(-8);
                make.bottom.equalTo(self.viewContent).offset(-8);
            }];
        }
    }
    else
    {
        self.imgAttachment.hidden = YES;
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        // 设置label长度
        if (size.height > 20)
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
        }
        else
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
        }
        [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblTitle);
            make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
            make.right.equalTo(self.viewContent).offset(-8);
            make.bottom.equalTo(self.viewContent).offset(-8);
        }];
    }
    
    
    
    [self.lblContent setLineBreakMode:NSLineBreakByTruncatingTail];
//    CGPoint center = CGPointMake(IOS_SCREEN_WIDTH / 2.0, size.height / 2.0 + (ifEvent ? H_MARGIN_EVENT_TOP : H_MARGIN_DATE_TOP));
	[self.lblContent setText:text];
	[self setAttributeTextWithAppModel:appModel text:text];
}


//提醒
- (void)showDateAndEvent:(MessageBaseModel *)baseModel
{
    
    MessageAppModel *appModel = baseModel.appModel;
    //设置标题
    [self.lblTitle setText:appModel.msgContent];
    
    if ([appModel.msgFrom isEqualToString:@"System"])
    {
        //设置标题
        [self.lblTitle setText:appModel.msgTitle];
        [self.lblName setText:LOCAL(IM_CHATCARD_SYSTEMMESSAGE)];
    }
    else
    {
        [self.lblName setText:appModel.msgFrom];
        //设置标题
        [self.lblTitle setText:appModel.msgContent];
    }
    
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:baseModel._createDate appendMinute:YES]];
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    
    NSString *text;
    if ([appModel isAppSystemMessage])
    {
        // 要显示的文字
        text = [IMApplicationUtil getMsgTextWithModel:appModel];
        
        if ([appModel.msgTransType isEqualToString:@"taskV2ChangeStatus"] || [appModel.msgTransType isEqualToString:@"taskV2ChangeDoneStatus"] || [appModel.msgTransType isEqualToString:@"meetingEdit"] || [appModel.msgTransType isEqualToString:@"meetingCancel"])
        {
            text = appModel.msgTitle;
        }
    }
    else
    {
        text = baseModel._content;
    }
    
    if ([baseModel.appModel.msgTransType isEqualToString:@"comment"])
    {
        self.lblKind.text = LOCAL(PLEASE_INPUT);
        NSString *str =  [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"]?:nil;
        if (str != nil && str.length > 0)
        {
            text = str;
        }
    }
    else
    {
        self.lblKind.text = @"";
    }
    // 得到输入文字内容长度
    NSString *strfile = [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"filePath"]?:@"";
    if (strfile.length > 0)
    {
        self.imgAttachment.hidden = NO;
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20 - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        // 设置label长度
        if (size.height > 20)
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(5);
            }];
            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblTitle).offset(20);
                make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
                make.right.equalTo(self.viewContent).offset(-8);
                make.bottom.equalTo(self.viewContent).offset(-8);
            }];
        }
        else
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(5);
            }];
            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblTitle).offset(20);
                make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
                make.right.equalTo(self.viewContent).offset(-8);
                make.bottom.equalTo(self.viewContent).offset(-8);
            }];
        }
    }
    else
    {
        self.imgAttachment.hidden = YES;
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        // 设置label长度
        if (size.height > 20)
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
        }
        else
        {
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
        }
        [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblTitle);
            make.top.equalTo(self.lblLine3.mas_bottom).offset(8);
            make.right.equalTo(self.viewContent).offset(-8);
            make.bottom.equalTo(self.viewContent).offset(-8);
        }];
    }
    
    
    
    [self.lblContent setLineBreakMode:NSLineBreakByTruncatingTail];
    //    CGPoint center = CGPointMake(IOS_SCREEN_WIDTH / 2.0, size.height / 2.0 + (ifEvent ? H_MARGIN_EVENT_TOP : H_MARGIN_DATE_TOP));
    [self.lblContent setText:text];
}

- (void)setAttributeTextWithAppModel:(MessageAppModel *)appModel text:(NSString *)text {
	NSArray *atUsers = [[[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"atWho"] mj_JSONObject];
	if (!atUsers || atUsers.count == 0) {
		return;
	}
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
	[atUsers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull atWhoDic, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSError *error = nil;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:atWhoDic[@"name"]
																			   options:0
																				 error:&error];
		NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
		if (error) {
			NSLog(@"===%@===", error.localizedDescription);
			
		} else {
			for (NSTextCheckingResult *textResult in matches) {
				if (textResult.range.location != NSNotFound) {
					[attributedString setAttributes:@{NSFontAttributeName: [UIFont mtc_font_26], NSForegroundColorAttributeName: [UIColor themeBlue]} range:NSMakeRange(textResult.range.location,textResult.range.length)];
				}
			}
		}

	}];
	
	self.lblContent.attributedText = attributedString;
	
}
- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor mtc_colorWithHex:0xf4f4f4] colorBorderColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1]];
    }
    return _leftTri;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 2;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
        [_lblName setTextColor:[UIColor blackColor]];
        [_lblName setFont:[UIFont mtc_font_26]];
    }
      return _lblName;
}

- (UIView *)viewContent
{
    if (!_viewContent)
    {
        _viewContent = [[UIView alloc] init];
        [_viewContent setBackgroundColor:[UIColor whiteColor]];
        _viewContent.layer.cornerRadius = 10;
        _viewContent.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
        _viewContent.layer.borderWidth = 1;
        _viewContent.clipsToBounds = YES;
    }
    return _viewContent;
}

- (UIView *)viewTitle
{
    if (!_viewTitle)
    {
        _viewTitle = [[UIView alloc] init];
        [_viewTitle setBackgroundColor:[UIColor mtc_colorWithHex:0xf4f4f4]];
        //        _viewTitle.layer.cornerRadius = 10;
        _viewTitle.clipsToBounds = YES;
    }
    return _viewTitle;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setFont:[UIFont mtc_font_30]];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblTitle;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        [_lblContent setFont:[UIFont mtc_font_26]];
        _lblContent.numberOfLines = 2;
        [_lblContent setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblContent;
}

- (UILabel *)lblKind
{
    if (!_lblKind)
    {
        _lblKind = [[UILabel alloc] init];
        [_lblKind setFont:[UIFont mtc_font_30]];
        [_lblKind setTextColor:[UIColor blackColor]];
        [_lblKind setTextAlignment:NSTextAlignmentRight];
        [_lblKind setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        //        [_lblKind setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblKind;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setTextAlignment:NSTextAlignmentCenter];
        [_lblTime setFont:[UIFont mtc_font_26]];
        [_lblTime setTextColor:GRAY_COLOR];
    }
    return _lblTime;
}

- (UILabel *)lblLine3
{
    if (!_lblLine3)
    {
        _lblLine3 = [[UILabel alloc] init];
        _lblLine3.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    }
    return _lblLine3;
}

- (UIImageView *)imgAttachment
{
    if (!_imgAttachment)
    {
        _imgAttachment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper-clips"]];
        _imgAttachment.hidden = YES;
    }
    return _imgAttachment;
}
@end
