//
//  ContactBookDeptTableViewCell.m
//  launcher
//
//  Created by kylehe on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookDeptTableViewCell.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ContactBookDeptTableViewCell()
//部门名
@property(nonatomic, strong) UILabel  *nameLbl;
//字类数量
@property(nonatomic, strong) UILabel  *countlbl;

@property (nonatomic, strong) UIButton *selectButton;

@property(nonatomic, strong) ContactDepartmentImformationModel  *deptModel;

@property (nonatomic, copy) void (^selectBlock)(id cell);

@end

@implementation ContactBookDeptTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}
+ (CGFloat)height { return 45;}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)createFrame
{
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
         make.width.height.equalTo(@44);
    }];
    
    [self.contentView addSubview:self.nameLbl];
    [self.contentView addSubview:self.countlbl];
    [self.countlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        
        if (self.selectButton.isHidden) {
            make.left.equalTo(self.contentView).offset(10);
        }
        else {
            make.left.equalTo(self.selectButton.mas_right);
        }
    }];
}

#pragma mark - Interface Method
- (void)setDataWithDeptModel:(ContactDepartmentImformationModel *)model {
    [self setDataWithDeptModel:model selectMode:NO];
}

- (void)setDataWithDeptModel:(ContactDepartmentImformationModel *)model selectMode:(BOOL)selectMode {
    self.nameLbl.text = model.D_NAME;
    
    NSString *stringCount = @"";
    if (model.D_AVAILABLE_COUNT) {
        //不显示部门下人数
        //stringCount = [NSString stringWithFormat:@"%ld",model.D_AVAILABLE_COUNT];
    }
    self.countlbl.text = stringCount;
    
    if (model.searchedRange.location != NSNotFound)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.nameLbl.text];
        [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:model.searchedRange];
        self.nameLbl.attributedText = str;
    }
    
    self.selectButton.hidden = !selectMode;
    self.deptModel = model;
    
    self.selectButton.selected = model.isSelect;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)isSingleMode {
    self.selectButton.enabled = NO;
}

- (void)clickToSelect:(void (^)(id cell))selectBlock {
    _selectBlock = selectBlock;
}

- (void)setSearchText:(NSString *)searchText
{
    NSMutableAttributedString *str = [self text:self.nameLbl.text searchText:searchText];
    self.nameLbl.attributedText = str;
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

#pragma mark - Button Clicked
- (void)clickAction
{
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}

#pragma mark - setterAndGetter

- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont mtc_font_30];
    }
    return _nameLbl;
}

- (UILabel *)countlbl
{
    if (!_countlbl)
    {
        _countlbl = [[UILabel alloc] init];
        _countlbl.textColor = [UIColor minorFontColor];
        _countlbl.font = [UIFont mtc_font_30];
    }
    return _countlbl;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton new];
        [_selectButton setImage:[UIImage imageNamed:@"toRead_icon_unselected"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"Me_check"] forState:UIControlStateSelected];
        
        [_selectButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

@end
