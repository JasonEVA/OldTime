//
//  ContactBookNameTableViewCell.m
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookNameTableViewCell.h"
#import "ContactPersonDetailInformationModel+UseForSelect.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UnifiedUserInfoManager.h"
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"
#import "MyDefine.h"
#import "Category.h"

@interface ContactBookNameTableViewCell()
//头像
@property(nonatomic, strong) UIImageView  *headView;
//名字
@property(nonatomic, strong) UILabel  *nameLbl;
//部门
@property(nonatomic, strong) UILabel  *departLbl;

@property (nonatomic, strong) UIButton *selectButton;

@property(nonatomic, readonly) ContactPersonDetailInformationModel  *listmodel;

@end

@implementation ContactBookNameTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}
+ (CGFloat)height { return 60;}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setSearchText:(NSString *)searchText
{
    NSMutableAttributedString *str = [self text:self.nameLbl.text searchText:searchText];
    self.nameLbl.attributedText = str;
}

- (void)setDataWithModel:(ContactPersonDetailInformationModel *)model  {
    [self setDataWithModel:model selectMode:NO];
}

- (void)setDataWithModel:(ContactPersonDetailInformationModel *)model selectMode:(BOOL)selectMode {
    //头像
    NSURL *urlHead = avatarURL(avatarType_80, model.show_id);
    [self.headView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
    //姓名
    self.nameLbl.text = model.u_true_name;
    if (model.searchedRange.location != NSNotFound)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.nameLbl.text];
        [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:model.searchedRange];
        self.nameLbl.attributedText = str;
    }
    //部门
    self.departLbl.text = model.d_name_forShow;
    self.selectButton.hidden = !selectMode;
    
    _listmodel = model;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setSelect:(BOOL)isSelected unableSelect:(BOOL)unableSelect selfSelectable:(BOOL)selfSelectable {
    self.selectButton.selected = isSelected;
    
    if (!selfSelectable && [self.listmodel.show_id isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
        // 不能选择自己
        self.selectButton.enabled = NO;
        self.userInteractionEnabled = NO;
    }
    else {
        //如果是任务选人，初始化时可选变不可选，不可选变可选
        self.selectButton.enabled = self.isMission ? unableSelect : !unableSelect;
        self.userInteractionEnabled = self.isMission ? unableSelect : !unableSelect;
    }
    
    if (!self.selectButton.enabled) {
        self.selectButton.selected = NO;
    }
}
#pragma mark - Private Method
- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self.contentView);
        
        if (self.selectButton.isHidden) {
            make.left.equalTo(self.contentView).offset(12);
        }
        else {
            make.left.equalTo(self.selectButton.mas_right).offset(10);
        }
    }];
    
    [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(8);
        
        if (![self.listmodel.d_name_forShow length]) {
            make.centerY.equalTo(self.headView);
        }
        else {
            make.top.equalTo(self.headView);
        }
    }];
}

- (void)createFrame
{
    [self.contentView addSubview:self.selectButton];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(14);
        make.width.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.nameLbl];
    [self.contentView addSubview:self.departLbl];
    [self.departLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(5);
        make.left.equalTo(self.nameLbl);
    }];
}

// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:1 green:242/255.0 blue:70/255.0 alpha:1] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

#pragma mark - setterAndGetter
- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        _headView.layer.cornerRadius = 3;
        _headView.layer.masksToBounds = YES;
    }
    return _headView;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont mtc_font_30];
    }
    return _nameLbl;
}

- (UILabel *)departLbl
{
    if (!_departLbl)
    {
        _departLbl = [[UILabel alloc] init];
        _departLbl.textColor = [UIColor mediumFontColor];
        _departLbl.font = [UIFont mtc_font_26];
    }
    return _departLbl;
}

- (UIButton *)selectButton {
    if (!_selectButton)
    {
        _selectButton = [UIButton new];
        [_selectButton setImage:[UIImage imageNamed:@"toRead_icon_unselected"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"Me_check"] forState:UIControlStateSelected];
        [_selectButton setImage:[UIImage imageNamed:@"check_gray"] forState:UIControlStateDisabled];
        _selectButton.userInteractionEnabled =  NO;
    }
    return _selectButton;
}

@end
