//
//  NewApplyNameRightTableViewCell.m
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyNameRightTableViewCell.h"
#import <Masonry.h>
#import "MyDefine.h"
@implementation NewApplyNameRightTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.myTextLabel.textColor = [UIColor blackColor];
        self.myTextLabel.font = [UIFont mtc_font_30];
        self.isMore = NO;
        self.myDetailLabel.font = [UIFont mtc_font_30];
        self.myDetailLabel.textColor = [UIColor minorFontColor];
        [self.myDetailLabel setNumberOfLines:0];
        [self.contentView addSubview:self.myDetailLabel];
        [self.contentView addSubview:self.myTextLabel];
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(80);
        }];
        self.isEdit = YES;
        [self.myDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myTextLabel.mas_right).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.right.equalTo(self.contentView).offset(-10);
        }];

        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.detailTextLabel.text = @"";
}

#pragma mark - interface Method
- (void)setNameField:(NSString *)str
{
    NSArray * array = [str componentsSeparatedByString:@"●"];
    [self setDataWithNameArr:array];
}

- (void)setDataWithNameArr:(NSArray *)array
{
    NSString *labelText = [[NSString alloc] init];;
    NSString *labelTextTest = [[NSString alloc] init];
    if (self.isMore) {
        for (int i = 0; i < array.count; i++) {
            if (i == 0)
            {
                labelText = [labelText stringByAppendingString:array[i]];
                labelTextTest = labelText;
            } else {
                labelText = [labelText stringByAppendingString:@"、"];
                labelText = [labelText stringByAppendingString:array[i]];
                labelTextTest = labelText;
            }
            [self.myDetailLabel setText:labelTextTest];
        }
        
    } else {
        for (int i = 0; i < array.count; i++) {
            if ((self.frame.size.width - 110) / 5 + 5 > labelTextTest.length)
            {
                if (i == 0)
                {
                    labelText = [labelText stringByAppendingString:array[i]];
                    labelTextTest = labelText;
                } else {
                    labelText = [labelText stringByAppendingString:@"、"];
                    labelText = [labelText stringByAppendingString:array[i]];
                    labelTextTest = labelText;
                }
                [self.myDetailLabel setText:labelTextTest];
                
            } else {
                labelTextTest = [labelText stringByAppendingString:[NSString stringWithFormat:@" %@",LOCAL(APPLY_MORE)]];
                NSRange range = [labelTextTest rangeOfString:LOCAL(APPLY_MORE)];
                NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:labelTextTest];
                [allAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor mtc_colorWithHex:0x2e9efb] range:range];
                //[allAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
                [self.myDetailLabel setAttributedText:allAttStr];
                if (!self.isEdit) {
                    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreClick)];
                    self.tap = moreTap;
                    [self.myDetailLabel addGestureRecognizer:self.tap];
                }
                
            }
            
        }
        
    }
}

- (void)moreClick
{
    if (!self.isMore) {
        if ([self.delegate respondsToSelector:@selector(ApplyNameRightTableViewCellDelegateCallBack_moreClick:)]) {
            [self.delegate ApplyNameRightTableViewCellDelegateCallBack_moreClick:self.indexPath];
        }
    }
}

- (void)setMyIsEdit:(BOOL)isEdit
{
    self.isEdit = isEdit;
}

- (void)setMyIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
}



#pragma mark - setterAndGetter

- (UILabel *)myTextLabel
{
    if (!_myTextLabel)
    {
        _myTextLabel = [[UILabel alloc] init];
    }
    return _myTextLabel;
}

- (UILabel *)myDetailLabel
{
    if (!_myDetailLabel) {
        _myDetailLabel = [[MyLableWithAlignmentTop alloc] initWithFrame:CGRectZero];
        _myDetailLabel.userInteractionEnabled = YES;
        [_myDetailLabel setVerticalAlignment:VerticalAlignmentTop];
    }
   return  _myDetailLabel;
}



@end
