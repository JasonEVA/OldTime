//
//  ReturnToMainMissionTableViewCell.m
//  launcher
//
//  Created by jasonwang on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ReturnToMainMissionTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface ReturnToMainMissionTableViewCell ()
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myTextLb;
@end

@implementation ReturnToMainMissionTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.myTextLb setText:LOCAL(NEWMISSION_MAIN_MISSION)];
        
        [self addSubview:self.titelLb];
        [self addSubview:self.myImageView];
        [self addSubview:self.myTextLb];
        
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
        
        [self.myTextLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.myTextLb.mas_right).offset(20);
            make.right.lessThanOrEqualTo(self.myImageView.mas_left).offset(-10);
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

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [[UILabel alloc] init];
        [_titelLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _titelLb;
}
- (UILabel *)myTextLb
{
    if (!_myTextLb) {
        _myTextLb = [[UILabel alloc] init];
        [_myTextLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _myTextLb;
}

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        [_myImageView setImage:[UIImage imageNamed:@"arrow_roundback"]];
    }
    return _myImageView;
}
@end
