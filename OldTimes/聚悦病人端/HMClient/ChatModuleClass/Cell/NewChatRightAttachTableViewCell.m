//
//  NewChatRightAttachTableViewCell.m
//  launcher
//
//  Created by TabLiu on 15/10/14.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatRightAttachTableViewCell.h"
#import <Masonry.h>
#import "Slacker.h"
//#import "Category.h"

#define INTERVAL_ICON 10     // 附件图标与边界距离间隔
#define W_ATTACHMENT 40     // 附件图标宽度
#define W_SIZE 60           // 附件大小宽度
#define W_MAX (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)        // 最大宽度

@interface NewChatRightAttachTableViewCell ()

@property (nonatomic, strong) UIImageView *imgViewAttachment;       // 附件图标
@property (nonatomic, strong) UILabel *lbTitle;                     // 附件名称
@property (nonatomic, strong) UILabel *lbSize;                      // 附件大小

@property (nonatomic, strong) MASConstraint *constraintTextWidth;

@end

@implementation NewChatRightAttachTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imgViewAttachment];
        [self.contentView addSubview:self.lbTitle];
        [self.contentView addSubview:self.lbSize];
        
        [self.imgViewAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewBubble).offset(INTERVAL_ICON );
            make.centerY.equalTo(self.imgViewBubble);
            make.width.height.equalTo(@(W_ATTACHMENT));
        }];
        
        [self.imgViewBubble mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@W_MAX);
            make.height.equalTo(self.imgViewAttachment).offset(2 * INTERVAL_ICON);
        }];
        
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewAttachment.mas_right).offset(10);
            make.right.equalTo(self.imgViewBubble.mas_right).offset(-13);
            self.constraintTextWidth = make.width.lessThanOrEqualTo(@(W_MAX));
            make.top.equalTo(self.imgViewAttachment).offset(-1);
        }];
        
        [self.lbSize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imgViewAttachment);
            make.left.equalTo(self.lbTitle);
        }];
    }
    
    return self;
}


#pragma mark -- Interface Method
- (void)setAttachmentData:(MessageAttachmentModel *)model
{
    UIImage *image = [UIImage new]; //[IMUtility fileIconFromFileName:model.fileName];
    // 附件显示
    [self.imgViewAttachment setImage:image];
    
    // 附件大小
    [self.lbSize setText:model.fileSizeString];
    
    // 附件title显示
    [self.lbTitle setText:model.fileName];
    
    // 得到文件名长度
    UIFont *font = [UIFont font_32];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [model.fileName boundingRectWithSize:CGSizeMake(W_MAX, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.constraintTextWidth.offset = size.width + 10;
}
- (UIImageView *)imgViewAttachment
{
    if (!_imgViewAttachment)
    {
        _imgViewAttachment = [UIImageView new];
    }
    
    return _imgViewAttachment;
}

- (UILabel *)lbSize
{
    if (!_lbSize)
    {
        _lbSize = [UILabel new];
        [_lbSize setFont:[UIFont font_26]];
        [_lbSize setTextColor:ChatBubbleRightConfigShare.attachSizeColor];
        [_lbSize setBackgroundColor:[UIColor clearColor]];
        _lbSize.alpha = 0.6;
    }
    
    return _lbSize;
}

- (UILabel *)lbTitle
{
    if (!_lbTitle)
    {
        _lbTitle = [UILabel new];
        [_lbTitle setFont:[UIFont font_26]];
        [_lbTitle setBackgroundColor:[UIColor clearColor]];
        [_lbTitle setTextColor:ChatBubbleRightConfigShare.textColor];
        [_lbTitle setTextAlignment:NSTextAlignmentLeft];
        [_lbTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    }
    
    return _lbTitle;
}

@end
