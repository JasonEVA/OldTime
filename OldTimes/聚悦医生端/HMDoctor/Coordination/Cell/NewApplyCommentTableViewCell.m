//
//  NewApplyCommentTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyCommentTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "NSDate+DateTools.h"
#import <MJExtension/MJExtension.h>
#import "MissionCommentsModel.h"

@interface NewApplyCommentTableViewCell()
@property (nonatomic) CellKind cellkind;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *imgViewHead;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIImageView *imgViewAttachment;
//@property (nonatomic, strong) ApplicationCommentModel *model;
@end

@implementation NewApplyCommentTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellKind:(CellKind)kind
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.cellkind = kind;
        [self.contentView addSubview:self.imgViewHead];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblContent];
        [self.contentView addSubview:self.lblTime];
        if (self.cellkind == CellKind_Attachement)
        {
            [self.contentView addSubview:self.imgViewAttachment];
        }
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCommentModel:(MissionCommentsModel *)model {
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.imgViewHead sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    [self.lblName setText:model.createUserName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:model.createTime];
    [dateFormatter setDateFormat: @"MM-dd"];
    NSString *time = [dateFormatter stringFromDate:destDate];
    [self.lblTime setText:time];
    if (model.tMessageType) {
        //评论文字
        [self.lblContent setTextColor:[UIColor colorWithHexString:@"333333"]];
    } else {
        //操作提示
        [self.lblContent setTextColor:[UIColor themeBlue]];
    }
    [self.lblContent setText:model.tContent];
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@40);
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(5);
        make.top.equalTo(self.imgViewHead);
        make.height.equalTo(@20);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.top.bottom.equalTo(self.lblName);
    }];
    
    if (self.cellkind == CellKind_Comment || self.cellkind == CellKind_System)
    {
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.lblName);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    else if (self.cellkind == CellKind_Attachement)
    {
        [self.imgViewAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.lblName);
            make.height.width.equalTo(@20);
        }];
    
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom);
            make.left.equalTo(self.imgViewAttachment.mas_right).offset(2);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
}


- (CGFloat)CalculcateWithHeight:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.frame.size.width - 13 - 15 - 5 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont font_30]} context:NULL].size;
    return size.height;
}

- (CGFloat)getHeight
{
    if (![self.lblContent.text isEqualToString:@""])
    {
        CGSize size = [self.lblContent.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 13 - 15 - 5 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont font_30]} context:NULL].size;
        if (size.height + 20 + 15 > 64)
        {
            return size.height + 20 + 15;
        }
        else
        {
            return 64;
        }
    }
    else
    {
        return 64;
    }
}

- (NSString *)stringTransType:(NSString *)transType rmData:(NSString *)rmData {
    return @"";
}

#pragma mark - init
- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextColor:[UIColor themeGray]];
        [_lblName setFont:[UIFont font_30]];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblName;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        [_lblContent setFont:[UIFont font_30]];
        _lblContent.numberOfLines = 0;
        [_lblContent setTextColor:[UIColor themeBlue]];
        [_lblContent setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblContent;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setFont:[UIFont font_24]];
        [_lblTime setTextColor:[UIColor themeGray]];
        [_lblTime setTextAlignment:NSTextAlignmentRight];
    }
    return _lblTime;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 2.0f;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UIImageView *)imgViewAttachment
{
    if (!_imgViewAttachment)
    {
        _imgViewAttachment = [[UIImageView alloc] init];
    }
    return _imgViewAttachment;
}
@end
