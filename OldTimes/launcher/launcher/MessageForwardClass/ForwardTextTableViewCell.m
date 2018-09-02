//
//  ForwardTextTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ForwardTextTableViewCell.h"
#import "Category.h"
#import "MyDefine.h"
#import "IMUtility.h"
#import <MintcodeIM/IMEnum.h>

#define CONTENT_FONT [UIFont mtc_font_26]

@interface ForwardTextTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ForwardTextTableViewCell

+ (CGFloat)heightForMessage:(NSString *)message {
    CGFloat max_width = IOS_SCREEN_WIDTH - 60 - 12;
    CGSize maxSize = CGSizeMake(max_width, CGFLOAT_MAX);
    
    NSDictionary *attriDict = @{NSFontAttributeName:CONTENT_FONT};
    CGSize size = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:NULL].size;
    
    return MAX(ceil(size.height) + wz_forwardExtraHeight, [self height]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).offset(-12);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)setMessageModel:(MessageBaseModel *)model {
    [super setMessageModel:model];
	
	if (!(model._type == msg_personal_text)) {
		self.contentLabel.text = [NSString stringWithFormat:@"%@", LOCAL(CHAT_FORWARD_MERGE_UNSUPPORT_CONTENT)];
	} else {
		self.contentLabel.text = model._content;
	}
}

#pragma mark - Initializer
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = CONTENT_FONT;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
