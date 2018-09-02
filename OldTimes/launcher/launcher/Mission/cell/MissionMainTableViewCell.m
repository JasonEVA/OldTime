//
//  MissionMainTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionMainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MissionMainViewModel+Util.h"
#import "MissionShowSubBtn.h"
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "AvatarUtil.h"
#import "Category.h"

@interface MissionMainTableViewCell ()

@property (nonatomic, strong) UIImageView  *headerIcon;

@property (nonatomic, strong) UILabel  *deadLineLbl;
/** title */
@property (nonatomic, strong) UILabel  *titleLbl;
/** 状态最左侧彩色的条 */
@property (nonatomic, strong) UIView  *stateView;
/** 内容指示按钮就是这个 > */
@property (nonatomic, strong) MissionShowSubBtn  *indicateBtn;
/** 时钟图标 */
@property (nonatomic, strong) UIImageView  *clockView;
/** 评论图标 */
@property (nonatomic, strong) UIImageView  *commentView;
/** 事件状态图标 */
@property (nonatomic, strong) UIImageView  *eventStateIcon;
@property (nonatomic, strong) UILabel *eventStateLabel;

@property (nonatomic, strong) MASConstraint *leftConstraints;

@property (nonatomic, readonly) MissionMainViewModel *modelShow;

@end

@implementation MissionMainTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)height { return 60;}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
        self.rightUtilityButtons = [self rightButtons];
    }
    return self;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor mtc_colorWithHex:0xffff00]
                                                 icon:[UIImage imageNamed:@"clock_gray"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor mtc_colorWithHex:0xcccccc]
                                                 icon:[UIImage imageNamed:@"pencil"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor themeBlue]
                                                 icon:[UIImage imageNamed:@"item_white"]];
    return rightUtilityButtons;
}

- (void)initComponents {
    [self.contentView addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@5);
        self.leftConstraints = make.left.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview: self.headerIcon];
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateView).offset(13);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@40);
    }];
    
    [self.contentView addSubview:self.indicateBtn];
    [self.indicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerIcon);
        make.left.equalTo(self.headerIcon.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.indicateBtn.mas_left).offset(-10);
    }];
    
    [self.contentView addSubview:self.clockView];
    [self.contentView addSubview:self.deadLineLbl];
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.centerY.equalTo(self.deadLineLbl);
    }];
    
    [self.deadLineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerIcon);
        make.left.equalTo(self.clockView.mas_right).offset(5);
    }];
    
    [self.contentView addSubview:self.commentView];
    [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadLineLbl.mas_right).offset(8);
        make.centerY.equalTo(self.clockView);
    }];
    
    [self.contentView addSubview:self.eventStateLabel];
    [self.eventStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.eventStateIcon];
    [self.eventStateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.eventStateLabel);
        make.right.equalTo(self.eventStateLabel.mas_left).offset(-8);
    }];
    
    // 上下分割线
    UIView *topSeperator = [[UIView alloc] init];
    topSeperator.backgroundColor = [UIColor mtc_colorWithHex:0xededed];
    [self.contentView addSubview:topSeperator];
    [topSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.height.equalTo(@0.3);
        make.left.equalTo(self.stateView.mas_right);
    }];
    
    UIView *bottomSeperator = [[UIView alloc] init];
    bottomSeperator.backgroundColor = [UIColor mtc_colorWithHex:0xededed];
    [self.contentView addSubview:bottomSeperator];
    [bottomSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@0.3);
        make.left.equalTo(topSeperator);
    }];
}

- (void)showSubcell {

    if (self.showSubDelegate && [self.showSubDelegate respondsToSelector:@selector(missionMainTableViewCellDelegateCallBack_showSubcell:)]) {
        [self.showSubDelegate missionMainTableViewCellDelegateCallBack_showSubcell:self];
    }
}

#pragma mark - Private Method
/** 截止时间显示 */
- (void)showTimes {
    BOOL show = self.modelShow.deadlineDate;
    self.clockView.hidden = !show;
    self.deadLineLbl.hidden = !show;
}

/** 更新评论 */
- (void)updateCommentStatus {
    switch (self.modelShow.commentStatus) {
        case MissionTaskCommentNone:
            self.commentView.hidden = YES;
            return;
        case MissionTaskCommentNew:
            self.commentView.image = [UIImage imageNamed:@"newComment"];
            break;
        case MissionTaskCommentNormal:
            self.commentView.image = [UIImage imageNamed:@"comment"];
            break;
    }
    self.commentView.hidden = NO;
}

/** 任务状态 */
- (void)updateMissionStatus {
    BOOL isSub = [self.modelShow parentTaskId].length;
    self.indicateBtn.hidden = isSub;
    self.indicateBtn.isShow = self.modelShow.isFolder;
    
    NSString *finishedTaskString = [NSString stringWithFormat:@"%ld/%ld",self.modelShow.finishedTask, self.modelShow.allTask];
    [self.indicateBtn setCountWithStr:finishedTaskString];
    
    BOOL indicateHide = self.modelShow.subMissionArray.count == 0;
    self.indicateBtn.hidden = indicateHide;
    
    self.eventStateIcon.hidden = !isSub;
    self.eventStateLabel.hidden = !isSub;
    
    self.leftConstraints.offset = isSub ? 25 : 0;
}

- (void)updateMissionPriority {
    UIColor *color;
    switch (self.modelShow.priority) {
        case MissionTaskPriorityLow:
            color = [UIColor mtc_colorWithHex:0xebebeb];
            break;
        case MissionTaskPriorityMid:
            color = [UIColor mtc_colorWithHex:0xffac4f];
            break;
        case MissionTaskPriorityHeigh:
            color = [UIColor mtc_colorWithHex:0xff3366];
            break;
    }
    self.stateView.backgroundColor = color;
}

#pragma mark - interface method
- (void)setCellWithModel:(MissionMainViewModel *)model {
    _modelShow = model;
    [_headerIcon sd_setImageWithURL:avatarURL(avatarType_80, [model.arrayUser firstObject]) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{
                                                                                                                             NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                                             NSFontAttributeName:[UIFont mtc_font_30]
                                                                                                                             }];
    if (model.statusType == whiteBoardStyleFinish) {
        attributedString  = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{
                                                                                                       NSForegroundColorAttributeName:[UIColor mtc_colorWithHex:0xadadad],
                                                                                                       NSFontAttributeName:[UIFont italicSystemFontOfSize:15],
                                                                                                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                                                                                                       }];
    }
    self.titleLbl.attributedText = attributedString;
    
    self.deadLineLbl.text = [model.deadlineDate mtc_dateFormate];
    self.eventStateLabel.text = model.eventStatus;
    
    [self showTimes];
    [self updateCommentStatus];
    [self updateMissionStatus];
    [self updateMissionPriority];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Initializer
- (UIImageView *)headerIcon
{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] init];
        _headerIcon.layer.cornerRadius = 5;
        _headerIcon.layer.masksToBounds = YES;
    }
    return _headerIcon;
}

- (UILabel *)deadLineLbl
{
    if (!_deadLineLbl)
    {
        _deadLineLbl = [[UILabel alloc] init];
        _deadLineLbl.textColor = [UIColor themeRed];
        _deadLineLbl.font = [UIFont mtc_font_26];
    }
    return _deadLineLbl;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
    }
    return _titleLbl;
}

- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}

- (MissionShowSubBtn *)indicateBtn {
    if (!_indicateBtn) {
        _indicateBtn = [[MissionShowSubBtn alloc] initWithFrame:CGRectMake(0, 0, 60, self.frame.size.width)];
        [_indicateBtn addTarget:self action:@selector(showSubcell) forControlEvents:UIControlEventTouchUpInside];
    }
    return _indicateBtn;
}

- (UIImageView *)clockView {
    if (!_clockView) {
        _clockView = [[UIImageView alloc] init];
        _clockView.image = [UIImage imageNamed:@"clock_red"];
    }
    return _clockView;
}

- (UIImageView *)commentView
{
    if (!_commentView)
    {
        _commentView = [[UIImageView alloc] init];
        _commentView.image = [UIImage imageNamed:@"comment"];
    }
    return _commentView;
}

- (UIImageView *)eventStateIcon
{
    if (!_eventStateIcon) {
        _eventStateIcon = [[UIImageView alloc] init];
        _eventStateIcon.image = [UIImage imageNamed:@"Mission_event_state"];
    }
    return _eventStateIcon;
}

- (UILabel *)eventStateLabel {
    if (!_eventStateLabel) {
        _eventStateLabel = [[UILabel alloc] init];
        _eventStateLabel.textColor = [UIColor minorFontColor];
        _eventStateLabel.font = [UIFont mtc_font_24];
    }
    return _eventStateLabel;
}

@end
