//
//  NewApplyApplyNameListTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyApplyNameListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIFont+Util.h"

@interface NewApplyApplyNameListTableViewCell()

@property (nonatomic, strong) UILabel *lblNameList;
@property (nonatomic, strong) NSMutableArray *arrPass;
@property (nonatomic, strong) NSMutableArray *arrPassSecond;
@property (nonatomic, strong) UIImageView *imgviewArrow;
@end

@implementation NewApplyApplyNameListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblNameList];
        [self.contentView addSubview:self.imgviewArrow];
        self.imgviewArrow.hidden = YES;
        self.needmore = NO;
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setframes
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.lblNameList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.left.equalTo(self.contentView).offset(100);
        make.right.equalTo(self.contentView).offset(-30);
		
    }];
    
    [self.imgviewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lblNameList.mas_right);
        make.width.equalTo(@20);
        make.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@10);
    }];
}

- (void)setimgviewarrowHide
{
    self.imgviewArrow.hidden = YES;
}

- (void)setDataWithAllNameArr:(NSArray *)array needmorelines:(BOOL)needmorelines
{
    if (needmorelines)
    {
        [self setimgviewarrowHide];
        NSString *labelText = [[NSString alloc] init];;
        NSString *linestring = [[NSString alloc] init];
        //    self.lblNameList.lineBreakMode =
        self.lblNameList.numberOfLines = 0;
        BOOL needadddot = YES;
        
        for (int i = 0; i < array.count; i++)
        {
            if (array.count == 1)
            {
               labelText = [labelText stringByAppendingString:array[i]];
            }
            else
            {
                if (array.count == i + 1)
                {
//                    linestring = [linestring stringByAppendingString:@"、"];
                    linestring = [linestring stringByAppendingString:array[i]];
                    if ([self needChangeLines:linestring])
                    {
                        labelText = [labelText stringByAppendingString:@"\n"];
                        labelText = [labelText stringByAppendingString:array[i]];
                    }
                    else
                    {
//                        labelText = [labelText stringByAppendingString:@"、"];
                        labelText = [labelText stringByAppendingString:array[i]];
                    }
                }
                else
                {
                    if (i == 0)
                    {
                        labelText = [labelText stringByAppendingString:array[i]];
                        linestring = [linestring stringByAppendingString:array[i]];
                        linestring = [linestring stringByAppendingString:@"、"];
                        labelText = [labelText stringByAppendingString:@"、"];
                    }
                    else
                    {
                        linestring = [linestring stringByAppendingString:array[i]];
                        linestring = [linestring stringByAppendingString:@"、"];
                        if ([self needChangeLines:linestring])
                        {
                            //换行
                            labelText = [labelText stringByAppendingString:@"\n"];
                            labelText = [labelText stringByAppendingString:array[i]];
                            labelText = [labelText stringByAppendingString:@"、"];
                            linestring = @"";
                            linestring = [linestring stringByAppendingString:array[i]];
                            linestring = [linestring stringByAppendingString:@"、"];
                        }
                        else
                        {
                            //不用换行
                            labelText = [labelText stringByAppendingString:array[i]];
                            labelText = [labelText stringByAppendingString:@"、"];
                            
                        }
                    }
                }
            }
        }
         [self.lblNameList setText:labelText];
        CGSize size = [self.lblNameList.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblNameList.font} context:NULL].size;
        
        [self.lblNameList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(100);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@(size.height + 2));
        }];

    }
    else
    {
        NSString *labelText = [[NSString alloc] init];;
        NSString *labelTextTest = [[NSString alloc] init];
        self.lblNameList.numberOfLines = 1;
        self.lblNameList.lineBreakMode = NSLineBreakByTruncatingTail;
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
        }
        self.imgviewArrow.hidden = ![self needChangeLines:labelTextTest];
        [self.lblNameList setText:labelTextTest];
    }
}

- (BOOL)needChangeLines:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    if (size.width > self.frame.size.width - 110)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (CGFloat)getHeight
{
    CGSize size = [self.lblNameList.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblNameList.font} context:NULL].size;
    
    return size.height + 26;
}

- (UILabel *)lblNameList
{
    if (!_lblNameList)
    {
        _lblNameList = [[UILabel alloc] init];
        _lblNameList.textColor = [UIColor blackColor];
        _lblNameList.font = [UIFont mtc_font_30];
    }
    return _lblNameList;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont mtc_font_30];
        _lblTitle.textColor = [UIColor minorFontColor];
    }
    return _lblTitle;
}

- (UIImageView *)imgviewArrow
{
    if (!_imgviewArrow)
    {
        _imgviewArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_downArrows"]];
    }
    return _imgviewArrow;
}

- (BOOL)needmore {
	return !self.imgviewArrow.hidden;
}
@end
