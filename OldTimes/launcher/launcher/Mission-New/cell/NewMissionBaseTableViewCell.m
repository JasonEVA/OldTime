//
//  NewMissionBaseTableViewCell.m
//  launcher
//
//  Created by jasonwang on 16/3/2.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionBaseTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation NewMissionBaseTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.myDetailTextLb];
        [self addSubview:self.myTextLb];
        
        [self.myTextLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [self.myDetailTextLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-40);
            make.left.equalTo(self.myTextLb.mas_right).offset(5);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)myTextLb
{
    if (!_myTextLb)
    {
        _myTextLb = [[UILabel alloc] init];
        _myTextLb.textColor = [UIColor blackColor];
        _myTextLb.font = [UIFont systemFontOfSize:14];
        [_myTextLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_myTextLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _myTextLb;
}

- (UILabel *)myDetailTextLb
{
    if (!_myDetailTextLb)
    {
        _myDetailTextLb = [[UILabel alloc] init];
        _myDetailTextLb.textColor = [UIColor blackColor];
        _myDetailTextLb.font = [UIFont systemFontOfSize:14];
        [_myDetailTextLb setTextAlignment:NSTextAlignmentRight];
    }
    return _myDetailTextLb;
}

@end
