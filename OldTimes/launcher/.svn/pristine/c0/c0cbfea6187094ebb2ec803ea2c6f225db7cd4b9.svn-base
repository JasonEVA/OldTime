//
//  MeMyRequestTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeMyRequestTableViewCell.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface MeMyRequestTableViewCell ()

@property(nonatomic, strong) UILabel  *nameLbl;

@property(nonatomic, strong) UILabel  *myRequestTitle;

@property(nonatomic, strong) UILabel  *myRequestContent;

@property(nonatomic, strong) UILabel  *timeLbl;

@end

@implementation MeMyRequestTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

- (void)setDate
{
    self.nameLbl.text = @"我:";
    self.myRequestTitle.text = @"上传头像无法保存";
    self.myRequestContent.text = @"修改头像上传图片后变成原来的头像";
    self.timeLbl.text = @"8/21";
}

- (void)setDate1
{
    self.nameLbl.text = @"客服:";
    self.myRequestTitle.text  = @"试着刷新一下网络或者推出重新登录一下就有自己的图标了；要不就是你没有上传成功（其中包括：你没有提交、或者图像不符合要求）";
    self.timeLbl.text = @"9/27";
    //必须设置
    self.myRequestContent.text = @"";
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    if ([self.myRequestContent.text isEqualToString:@""])
    {
        [self.myRequestTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self).offset(60);
            make.right.equalTo(self.timeLbl.mas_left).offset(-10);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
        [self.myRequestContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myRequestTitle);
            make.right.equalTo(self.myRequestTitle);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(- 10);
        }];
    }
}

- (CGFloat)getHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 90;
    CGSize boundNameSize  = CGSizeMake(40, CGFLOAT_MAX);
    CGSize boundTimeSize = CGSizeMake(50, CGFLOAT_MAX);
    CGSize boundTitleSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize boundContentSize = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *nameAttribute = @{NSFontAttributeName: self.nameLbl.font};
    NSDictionary *timeAttribute = @{NSFontAttributeName: self.timeLbl.font};
    NSDictionary *titleAttribute = @{NSFontAttributeName: self.myRequestTitle.font};
    NSDictionary *contentAttribute = @{NSFontAttributeName: self.myRequestContent.font};
    
    CGSize nameSize = [self.nameLbl.text boundingRectWithSize:boundNameSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:nameAttribute context:nil ].size;
    CGSize timeSize = [self.timeLbl.text boundingRectWithSize:boundTimeSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:timeAttribute context:nil].size;
    CGSize titleSize = [self.myRequestTitle.text boundingRectWithSize:boundTitleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleAttribute context:nil].size;
    CGSize contentSize = [self.myRequestContent.text boundingRectWithSize:boundContentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentAttribute context:nil].size;
    NSArray *arr1 = [NSArray arrayWithObjects:@(nameSize.height),@(timeSize.height),@(titleSize.height + contentSize.height),nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@(nameSize.height),@(timeSize.height),@(titleSize.height),nil];
    NSNumber *maxHeight;
    if ([self.myRequestContent.text isEqualToString:@""])
    {
         maxHeight  = [arr2 valueForKeyPath:@"@max.floatValue"];
    
        return [maxHeight floatValue] + 30;
    }else
    {
        maxHeight = [arr1 valueForKeyPath:@"@max.floatValue"];
    }
    NSLog(@"＝＝%@",maxHeight);
    return [maxHeight floatValue] + 40;
}

#pragma mark - SetterAndGette
- (void)createFrame
{
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.width.lessThanOrEqualTo(@50);
        make.height.lessThanOrEqualTo(self.contentView.mas_height).offset(- 20);
    }];
    [self addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl);
        make.width.greaterThanOrEqualTo(@40);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self addSubview:self.myRequestContent];
    [self addSubview:self.myRequestTitle];
    [self.myRequestTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60);
        make.right.equalTo(self.timeLbl.mas_left).offset(-10);
        make.top.equalTo(self.nameLbl);
    }];

    [self.myRequestTitle setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                         forAxis:UILayoutConstraintAxisVertical];
    [self.myRequestContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myRequestTitle.mas_bottom).offset(10);
        make.left.equalTo(self.myRequestTitle);
        make.right.equalTo(self.myRequestTitle);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(- 10);
    }];
}


- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor mtc_colorWithHex:0X707070];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.numberOfLines = 0;
        _nameLbl.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLbl;
}

- (UILabel *)myRequestContent
{
    if (!_myRequestContent)
    {
        _myRequestContent = [[UILabel alloc] init];
        _myRequestContent.textColor = [UIColor mtc_colorWithHex:0xc5c5c5];
        _myRequestContent.numberOfLines = 0;
        _myRequestContent.font = [UIFont systemFontOfSize:15.0];
    }
    return _myRequestContent;
}

- (UILabel *)myRequestTitle
{
    if (!_myRequestTitle)
    {
        _myRequestTitle = [[UILabel alloc] init];
        _myRequestTitle.numberOfLines = 0;
        _myRequestContent.font = [UIFont systemFontOfSize:15.0f];
    }
    return _myRequestTitle;
}

- (UILabel *)timeLbl
{
    if (!_timeLbl)
    {
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.textColor = [UIColor mtc_colorWithHex:0X959595];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.numberOfLines = 0;
        _timeLbl.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLbl;
}

@end
