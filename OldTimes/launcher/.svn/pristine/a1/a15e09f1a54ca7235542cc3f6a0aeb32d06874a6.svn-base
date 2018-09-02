//
//  ApplyDeadlineTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  承认期限cell

#import "ApplyDeadlineTableViewCell.h"
#include "UIColor+Hex.h"
#include "Masonry.h"

@implementation ApplyDeadlineTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self createFrame];
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)setDataWithArr:(NSArray *)array
{
    NSString *labelText = [[NSString alloc] init];;
    NSString *labelTextTest = [[NSString alloc] init];
    
    if ([array[0] isEqualToString:@""])
    {
        
    }
    else
    {
        for (int i = 0; i < array.count; i++)
        {
            if ((self.frame.size.width - 110)/15 + 2> labelTextTest.length)
            {
                if (i == 0)
                {
                    labelText = [labelText stringByAppendingString:array[i]];
                    labelTextTest = labelText;
                    if (array.count >1)
                    {
                        labelTextTest = [labelText stringByAppendingString:[NSString stringWithFormat:@" +%lu",array.count - i -1]];
                    }
                }
                else
                {
                    labelText = [labelText stringByAppendingString:@"、"];
                    labelText = [labelText stringByAppendingString:array[i]];
                    if (array.count - 1 > i)
                    {
                        labelTextTest = [labelText stringByAppendingString:[NSString stringWithFormat:@" +%lu",array.count - i -1]];
                    }
                    else
                    {
                        labelTextTest = labelText;
                    }
                }
                
            }
        }
    }
    
    [self.detailTextLabel setText:labelTextTest];
 
}

#pragma mark - createFrame

- (void)createFrame
{
    [self addSubview:self.deadlineLbl];
    [self.deadlineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - initilizer

- (UILabel *)deadlineLbl
{
    if (!_deadlineLbl)
    {
        _deadlineLbl = [[UILabel alloc] init];
        _deadlineLbl.textColor = [UIColor minorFontColor];
    }
    return _deadlineLbl;
}


@end
