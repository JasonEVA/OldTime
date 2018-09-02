//
//  SESessionSelectTypeTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESessionSelectTypeTableViewCell.h"
#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]

static const CGFloat unReadCountLbSize = 17; //带数字红点尺寸

@interface SESessionSelectTypeTableViewCell ()
@property (nonatomic, strong) UIButton *selectedIcon;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, copy) selectedBlock block;
// 未读红点
@property (nonatomic, strong) UILabel *unReadCountLb;
@end

@implementation SESessionSelectTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.selectedIcon];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.unReadCountLb];

        [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.width.equalTo(@20);
        }];
        
        [self.unReadCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@(unReadCountLbSize));
            make.centerY.equalTo(self.contentView);
            make.left.lessThanOrEqualTo(self.unReadCountLb.mas_right).offset(-unReadCountLbSize);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.selectedIcon.mas_right).offset(18);
            make.right.lessThanOrEqualTo(self.unReadCountLb.mas_left).offset(-5);
        }];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response
- (void)selectedClick {
    self.selectedIcon.selected ^= 1;
    if (self.block) {
        self.block(self.selectedIcon.selected);
    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)selectedClickBlock:(selectedBlock)block {
    self.block = block;
}

- (void)fillDataWithTitelName:(NSString *)titelName unReadCount:(NSInteger)unReadCount isSelected:(BOOL)isSelected {
    [self.titelLb setText:titelName];
    [self.unReadCountLb setHidden:!unReadCount];
    [self.selectedIcon setSelected:isSelected];
    if (isSelected) {
      [self.unReadCountLb.layer setBackgroundColor:[COLOR_BG CGColor]];
    }
    else {
        [self.unReadCountLb.layer setBackgroundColor:[[UIColor colorWithHexString:@"cccccc"] CGColor]];
    }

    if (unReadCount > 0) {
        [self.unReadCountLb setText:unReadCount > 99 ? [NSString stringWithFormat:@"⋅⋅⋅  "] : [NSString stringWithFormat:@"%ld  ",unReadCount]];
        
        [self.unReadCountLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@(unReadCountLbSize));
            make.centerY.equalTo(self.contentView);
            make.left.lessThanOrEqualTo(self.unReadCountLb.mas_right).offset(-unReadCountLbSize);
        }];
    }
    
}
#pragma mark - init UI

- (UIButton *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIButton alloc] init];
        [_selectedIcon setImage:[UIImage imageNamed:@"ic_nochoose"] forState:UIControlStateNormal];
        [_selectedIcon setImage:[UIImage imageNamed:@"ic_choose"] forState:UIControlStateSelected];

        [_selectedIcon addTarget:self action:@selector(selectedClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectedIcon;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@"占位文案"];
    }
    return _titelLb;
}

- (UILabel *)unReadCountLb {
    if (!_unReadCountLb) {
        _unReadCountLb = [UILabel new];
        [_unReadCountLb.layer setBackgroundColor:[COLOR_BG CGColor]];
        [_unReadCountLb.layer setCornerRadius:unReadCountLbSize / 2];
        [_unReadCountLb setClipsToBounds:YES];
        [_unReadCountLb setTextColor:[UIColor whiteColor]];
        [_unReadCountLb setFont:[UIFont systemFontOfSize:12]];
        [_unReadCountLb setTextAlignment:NSTextAlignmentCenter];
        [_unReadCountLb setText:@"9"];
    }
    return _unReadCountLb;
}
@end
