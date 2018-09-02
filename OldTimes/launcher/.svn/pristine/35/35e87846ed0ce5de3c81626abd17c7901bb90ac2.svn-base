//
//  NewApplyRecordTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyRecordTableViewCell.h"
#import "UIFont+Util.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "LinkLabel.h"

@interface NewApplyRecordTableViewCell()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) LinkLabel *lblContent;

@end

@implementation NewApplyRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblContent];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.top.equalTo(self.contentView).offset(15);
            make.right.lessThanOrEqualTo(self.lblContent.mas_left).offset(-5);
        }];
        
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - TTTAttributeDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
	
	NSArray *res = [phoneNumber componentsSeparatedByString:LINK_SPLIT];
	if([res count] != 2){
		return;
	}
	
	NSString *phone = [res[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	if(!phone.length){
		return;
	}
	
	if ([self.delegate respondsToSelector:@selector(newApplyRecordTableViewCellDidClickRichText:textType:)]) {
		[self.delegate newApplyRecordTableViewCellDidClickRichText:phone textType:RichTextNumber];
	}
}

#pragma mark - Privite Methods
+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (void)setDetailText:(NSString *)detailText {
    
    [self setDetailText:detailText textColor:[UIColor blackColor]];
}

- (void)setDetailText:(NSString *)detailText textColor:(UIColor *)textColor {
	// 旧数据兼容
	if ([detailText hasPrefix:@"¥"] || [detailText hasPrefix:@"￥"]) {
		self.lblContent.text = detailText;
	} else {
		[self.lblContent setRichText:detailText];
	}
    
    self.lblContent.textColor = textColor;
}

+ (CGFloat)heightForCell:(NSString *)text {
    if (![text length]) {
        return 0;
    }
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 110,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    
//    CGFloat maxWidth = IOS_SCREEN_WIDTH - 110;
//    
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont mtc_font_30]};
    
//    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (size.height + 30 > 45)
    {
        return size.height + 30;    // 20为了美，不服来打
    }
    else
    {
        return 45;
    }
    
}

#pragma mark - Initializer
@synthesize lblTitle = _lblTitle;
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont mtc_font_30];
        _lblTitle.text = LOCAL(CALENDAR_CONFIRM_DETAIL);
        _lblTitle.textColor = [UIColor minorFontColor];
    }
    return _lblTitle;
}


- (LinkLabel *)lblContent
{
    if (!_lblContent)
    {
		_lblContent = [[LinkLabel alloc] initWithFrame:CGRectZero];
        _lblContent.textColor = [UIColor blackColor];
        _lblContent.font = [UIFont mtc_font_30];
		_lblContent.highlightColor = [UIColor themeBlue];
		_lblContent.delegate = self;
        _lblContent.numberOfLines = 0;
    }
    return _lblContent;
}
@end
