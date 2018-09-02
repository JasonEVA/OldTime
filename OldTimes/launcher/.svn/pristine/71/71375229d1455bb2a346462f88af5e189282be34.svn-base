//
//  MissionDetailSubcellTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailSubcellTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MissionDetailModel.h"
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "AvatarUtil.h"
#import "Category.h"

@interface MissionDetailSubcellTableViewCell()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel     *titleLbl;
@property (nonatomic, strong) UIButton    *moreIcon;

@property (nonatomic, copy) MissionSubCellClickBlock clickBlock;

@end

@implementation MissionDetailSubcellTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.moreIcon];
        
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@40);
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIcon.mas_right).offset(5);
            make.centerY.equalTo(self.headIcon);
            make.right.lessThanOrEqualTo(self.moreIcon.mas_left);
        }];
        
        [self.moreIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-13);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setDataWithModel:(MissionDetailModel *)model {
    self.titleLbl.text = model.title;
}

- (void)clickedMore:(MissionSubCellClickBlock)clickBlock {
    self.clickBlock = clickBlock;
}

#pragma mark - private method
- (void)clickToMore {
    //按钮暴力点击防御
    [self.moreIcon mtc_deterClickedRepeatedly];

    if (self.clickBlock) {
        self.clickBlock(self);
    }
}


#pragma mark - setter and getter
- (UIImageView *)headIcon
{
    if (!_headIcon)
    {
        _headIcon = [[UIImageView alloc] init];
        _headIcon.layer.cornerRadius = 2;
        _headIcon.layer.masksToBounds = YES;
        _headIcon.image = [UIImage imageNamed:@"headeriocn"];
    }
    return _headIcon;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl)
    {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont mtc_font_30];
    }
    return _titleLbl;
}

- (UIButton *)moreIcon
{
    if (!_moreIcon)
    {
        _moreIcon = [[UIButton alloc] init];
        _moreIcon.expandSize = CGSizeMake(20, 0);
        
        UIImage *image = [UIImage imageNamed:@"Mission_more"];
        [_moreIcon setImage:image forState:UIControlStateNormal];
        [_moreIcon addTarget:self action:@selector(clickToMore) forControlEvents:UIControlEventTouchUpInside];
        
        _moreIcon.tintColor = [UIColor themeBlue];
        [_moreIcon setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    }
    return _moreIcon;
}

@end
