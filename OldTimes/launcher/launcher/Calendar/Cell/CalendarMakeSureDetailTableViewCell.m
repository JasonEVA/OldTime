//
//  CalendarMakeSureDetailTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarMakeSureDetailTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "LinkLabel.h"

@interface CalendarMakeSureDetailTableViewCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) LinkLabel *detailLabel;

@end

@implementation CalendarMakeSureDetailTableViewCell

+ (NSString *)identifier {
    return @"CalendarMakeSureDetailTableViewCellID";
}

+ (CGFloat)heightForCell:(NSString *)text {
    if (![text length]) {
        return 0;
    }
    
    
    CGFloat maxWidth = IOS_SCREEN_WIDTH - 26;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont mtc_font_30]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    

    if (size.height + 20 > 45)
    {
        if (IOS_DEVICE_6Plus) {
            return size.height + 35;
        }
        return size.height + 20;    // 20为了美，来打
    }
    else{
        return 45;
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.detailLabel];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-13);
        }];
    }
    return self;
}

#pragma mark - Interface Method 
- (void)setDetailText:(NSString *)detailText
{
    [self setDetailText:detailText textColor:[UIColor blackColor]];
}

- (void)setDetailText:(NSString *)detailText textColor:(UIColor *)textColor
{

	self.detailLabel.textColor = textColor;
	self.detailLabel.highlightColor = [UIColor themeBlue];
	[self.detailLabel setRichText:detailText];

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
	
	if ([self.delegate respondsToSelector:@selector(calendarMakeSureDetailTableViewCellDidClickRichText:textType:)]) {
		[self.delegate calendarMakeSureDetailTableViewCellDidClickRichText:phone textType:RichTextNumber];
	}
}
#pragma mark - Initializer
- (LinkLabel *)detailLabel {
    if (!_detailLabel) {
		_detailLabel = [[LinkLabel alloc] initWithFrame:CGRectZero];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont mtc_font_30];
        _detailLabel.numberOfLines = 0;
		_detailLabel.delegate = self;
		_detailLabel.highlightColor = [UIColor themeBlue];
    }
    return _detailLabel;
}

@end
