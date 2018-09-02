//
//  MissionDetailTitleTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailTitleTableViewCell.h"
#import "MissionDetailModel.h"
#import "MissionShowSubBtn.h"
#import "Category.h"
#import "MyDefine.h"
#import "Masonry.h"

@interface MissionDetailTitleTableViewCell ()
/**
 *  标题
 */
@property(nonatomic, strong) UILabel  *titleLbl;
/**
 *  左侧带箭头的图标和数字
 */
@property(nonatomic, strong) MissionShowSubBtn *indicateBtn;
/**
 *  加号按钮
 */
@property(nonatomic, strong) UIButton  *addBtn;

@end

@implementation MissionDetailTitleTableViewCell

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

- (void)createFrame
{
    [self.contentView addSubview:self.indicateBtn];
    [self.indicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(13);
    }];
    [self.contentView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(8);
        make.centerY.equalTo(self.titleLbl);
    }];
}

#pragma mark - Button Click
- (void)showSubcell
{
    if ([self.delegate respondsToSelector:@selector(MissionDetailTitleTableViewCellDelegateCallBack_showSubTasks)])
    {
        [self.delegate MissionDetailTitleTableViewCellDelegateCallBack_showSubTasks];
    }
}

- (void)addNewTaskVC
{
    //按钮暴力点击防御
    [self.addBtn mtc_deterClickedRepeatedly];

    if ([self.delegate respondsToSelector:@selector(MissionDetailTitleTableViewCellDelegateCallBack_pushAddNewTaskVC)])
    {
        [self.delegate MissionDetailTitleTableViewCellDelegateCallBack_pushAddNewTaskVC];
    }
}

#pragma mark - interface Mathod

- (void)setSubTaskCount:(NSInteger )count isFolder:(BOOL)isFolder {
    [self.indicateBtn setCountWithStr:[NSString stringWithFormat:@"%ld",(long)count]];
    self.indicateBtn.isShow = isFolder;
    self.indicateBtn.hidden = !count;
}

- (void)canCreateTaskForDetailModel:(MissionDetailModel *)detailModel {
    BOOL showAddButton = NO;
    
    NSString *myShowId = [[UnifiedUserInfoManager share] userShowID];
    if ([detailModel.createrUser isEqualToString:myShowId]) {
        showAddButton = YES;
    }
    
    else if ([[detailModel.arrayUser firstObject] isEqualToString:myShowId]) {
        showAddButton = YES;
    }
    
    self.addBtn.hidden = !showAddButton;
}

#pragma mark - setter and getter

- (UILabel *)titleLbl
{
    if (!_titleLbl)
    {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor  = [UIColor blackColor];
        _titleLbl.text = LOCAL(MISSION_SUBTASK);
        _titleLbl.font = [UIFont mtc_font_30];
    }
    return _titleLbl;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton new];
        UIImage *image = [UIImage imageNamed:@"plus_black"];
        [_addBtn setImage:image forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addNewTaskVC) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
        _addBtn.tintColor = [UIColor themeBlue];
    }
    return _addBtn;
}

- (MissionShowSubBtn *)indicateBtn {
    if (!_indicateBtn) {
        _indicateBtn = [[MissionShowSubBtn alloc] init];
        [_indicateBtn addTarget:self action:@selector(showSubcell) forControlEvents:UIControlEventTouchUpInside];
    }
    return _indicateBtn;
}

@end
