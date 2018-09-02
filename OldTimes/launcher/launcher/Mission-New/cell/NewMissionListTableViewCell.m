//
//  NewMissionListTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NSDate+MsgManager.h"
#import <UIImageView+WebCache.h>
#import "AvatarUtil.h"
#import "MyDefine.h"
#import "Category.h"

#define FinishColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]
#define LOW_COLOR [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]      //优先级低的颜色
#define HIGH_COLOR [UIColor colorWithRed:246/255.0 green:20/255.0 blue:84/255.0 alpha:1]      //优先级高的颜色
#define MEDIUM_COLOR [UIColor colorWithRed:247/255.0 green:167/255.0 blue:89/255.0 alpha:1]   //优先级中的颜色
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
static CGFloat const kTotalSecondInADay = 86400;

@interface NewMissionListTableViewCell ()

@property (nonatomic,strong) UIView * bgView ;  // 背景 (用来实现偏移)

@property (nonatomic,strong) UIButton * iconMarkButton; // 已完成未完成操作的按钮

@property (nonatomic,strong) UILabel * titleLabel; // title

// 截止时间
@property (nonatomic,strong) UIImageView * iconClockImgView;
@property (nonatomic,strong) UILabel * timeLabel;
// 工程名称
@property (nonatomic,strong) UIImageView * iconProjectImgView;
@property (nonatomic,strong) UILabel * projectNameLabel;
// 附件
@property (nonatomic,strong) UIImageView * iconFileImgView;
// 评论
@property (nonatomic,strong) UIImageView * iconDiscussLabel;

// 优先级
@property (nonatomic,strong) UIView * priorityView ;

// 已完成 title 下滑线
@property (nonatomic,strong) UIView * lineView;

// 未完成/全部 比例
@property (nonatomic,strong) UILabel *  ratioLabel;
// 展开闭合 图片
@property (nonatomic,strong) UIImageView * switchButton;

// 头像
@property (nonatomic,strong) UIImageView * headImageView ;
// 展开 闭合 背景按钮
@property (nonatomic,strong) UIButton * bgButton;
//  cell 下边 边界
@property (nonatomic,strong) UIView * lineView2;
// 是否展示头像
@property (nonatomic,assign) BOOL  isNeedShowImage;

@property (nonatomic,strong) NSString * seachText ; // 之前有搜索 ,后来不做了
@end

@implementation NewMissionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self coutomView];
        
    }
    return self;
}

- (void)iconMarkButtonClick
{
//    if (_iconMarkButton.selected) {
//        _iconMarkButton.selected = NO;
//        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateNormal];
//        self.titleLabel.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1];
//    }else {
//        _iconMarkButton.selected = YES;
//        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
//        self.titleLabel.textColor = [UIColor blackColor];
//    }
    
    if (_buttonDelegate && [_buttonDelegate respondsToSelector:@selector(NewMissionListTableViewCell_CompleteButtonClick:)]) {
        [_buttonDelegate NewMissionListTableViewCell_CompleteButtonClick:_path];
    }

}
- (void)switchButtonClick
{
    if (self.bgButton.selected) {
        [_switchButton setImage:[UIImage imageNamed:@"Mission_folder_off"]];
        self.bgButton.selected = NO;
    }else {
        [_switchButton setImage:[UIImage imageNamed:@"Mission_folder_on"]];
        self.bgButton.selected = YES;
    }
	_opening = self.bgButton.selected;
	
    if (_buttonDelegate && [_buttonDelegate respondsToSelector:@selector(NewMissionListTableViewCell_SwitchButtonClick:)]) {
        [_buttonDelegate NewMissionListTableViewCell_SwitchButtonClick:_path];
    }
    
}

#pragma mark -
- (void)setProjrctData:(TaskListModel *)model
{
    [self setViewData:model];
    [self setViewFromWithSkewing:YES];
}
- (void)setNeedShowHeadImg:(BOOL)isNeed
{
    self.isNeedShowImage = isNeed;
}

- (void)setCellData:(TaskListModel *)model
{
    [self setViewData:model];
    [self setViewFromWithSkewing:NO];
}
- (void)setSearchText:(NSString *)string
{
    _seachText = string;
}


- (UIColor *)getTaskColorWithPriority:(NSString *)priority
{
    UIColor * color;
    if ([priority isEqualToString:NONE_NEW]) {
        color = [UIColor whiteColor];//GRAY_COLOR;
    }else if ([priority isEqualToString:LOW_NEW]) {
        color = LOW_COLOR;
    }else if ([priority isEqualToString:MEDIUM_NEW]) {
        color = MEDIUM_COLOR;
    }else if ([priority isEqualToString:HIGH_NEW]) {
        color = HIGH_COLOR;
    }
    return color;
}

- (void)SetLineHidden:(BOOL)hidden
{
    self.lineView2.hidden = hidden;
}

- (void)coutomView
{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.priorityView];
    [self.bgView addSubview:self.iconMarkButton];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.iconClockImgView];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.iconProjectImgView];
    [self.bgView addSubview:self.projectNameLabel];
    [self.bgView addSubview:self.iconFileImgView];
    [self.bgView addSubview:self.iconDiscussLabel];
    [self.bgView addSubview:self.switchButton];
	
    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.bgButton];
    [self.bgView addSubview:self.lineView2];
    
    [self setViewFromWithSkewing:NO];

}

- (void)setViewData:(TaskListModel *)model
{
    //改变➡️
    if (model.isOpen) {
        [_switchButton setImage:[UIImage imageNamed:@"Mission_folder_on"]];
        self.bgButton.selected = YES;
    }else {
        [_switchButton setImage:[UIImage imageNamed:@"Mission_folder_off"]];
        self.bgButton.selected = NO;
    }
	_opening = model.isOpen;
    
    // 优先级颜色
    [self.priorityView setBackgroundColor:[self getTaskColorWithPriority:model.priority]];
    
    // 设置结束时间
    BOOL isMissionOverTimeOrNearby24h = NO;
    [self.timeLabel setText:[self getTimeWithModel:model isMissionOverTimeOrNearby:&isMissionOverTimeOrNearby24h]];
    [self.timeLabel setTextColor: (isMissionOverTimeOrNearby24h ? HIGH_COLOR : [UIColor blackColor])];
    
    self.iconClockImgView.highlighted = isMissionOverTimeOrNearby24h;
    
    // 设置是否完成
    if ([model.type isEqualToString:WAITING_NEW] || [model.type isEqualToString:@"Wating"]){
        // 待办
        _iconMarkButton.selected = NO;
        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
        self.titleLabel.textColor = [UIColor blackColor];
        _lineView.hidden = YES;
    }
    else {
        // 完成
        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateNormal];
        _iconMarkButton.selected = YES;
        
        self.titleLabel.textColor = FinishColor;
        self.timeLabel.textColor = FinishColor;
        self.iconClockImgView.highlighted = NO;
        _lineView.hidden = NO;
    }
    // 设置任务标题
    self.titleLabel.attributedText = [self text:model.title searchText:_seachText];

    // 设置项目名称
    if (model.projectName.length) {
        self.projectNameLabel.text = model.projectName;
        self.projectNameLabel.hidden = NO;
        self.iconProjectImgView.hidden = NO;
    }else {
        self.projectNameLabel.hidden = YES;
        self.iconProjectImgView.hidden = YES;
    }
    // 设置是否显示评论
    if (model.isComment) {
        // 有评论
        self.iconDiscussLabel.hidden = NO;
    }else {
        // 没有评论
        self.iconDiscussLabel.hidden = YES;
    }
    // 设置是否有附件
    if (model.isAnnex) {
        // 有
        self.iconFileImgView.hidden = NO;
    }else {
        self.iconFileImgView.hidden = YES;
    }
    // 设置是否是子任务
    if (model.level == 1) {
        // 跟任务
        // 是否有子任务
        if (model.allTask == 0) {
            // 没有子任务
            [self.switchButton setHidden:YES];
        }else {
            // 包含子任务
            [self.switchButton setHidden:NO];
        }
    }else {
        // 子任务
        [self.switchButton setHidden:YES];
    }
    if (_isNeedShowImage) {
        NSURL *urlHead = avatarURL(avatarType_default, model.userName);
        [self.headImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"]];
        [self.headImageView setHidden:NO];
    }else {
        [self.headImageView setHidden:YES];
    }
}
// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    if (!text) {
        text = @"";
    }
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

//转换时间间隔字段
- (NSString *)getTimeWithModel:(TaskListModel *)model isMissionOverTimeOrNearby:(BOOL *)isOver
{
    long long startLong = model.startTime;
    long long endLong = model.endTime;
    
    NSString *startString = @"";
    NSString *endString = @"";
    if (startLong) {
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startLong/1000];
        startString = [startDate mtc_getStringWithDateWholeDay:model.isStartTimeAllDay];
        
    } else {
        startString = LOCAL(NEWMISSION_NO_START_TIME);
    }
    
    if (endLong) {
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endLong/1000];
        
        NSDate *limitedDate = [NSDate dateWithTimeIntervalSinceNow:kTotalSecondInADay];
        NSComparisonResult result = [limitedDate compare: endDate];
        *isOver = result > 0;
        
        endString = [endDate mtc_getStringWithDateWholeDay:model.isEndTimeAllDay];
    } else {
        endString = LOCAL(NEWMISSION_UNSET);
    }
    
    
    if (startLong && endLong)
    {
        return [NSString stringWithFormat:@"%@~%@",startString,endString];
    }
    else if (startLong)
    {
        return [NSString stringWithFormat:@"%@ %@",LOCAL(NEWMISSION_SELECT_START_TIME),startString];
    }
    else if (endLong)
    {
        return [NSString stringWithFormat:@"%@ %@",LOCAL(NEWMISSION_SELECT_END_TIME),endString];
    }
    else
    {
        return [NSString stringWithFormat:@"%@、%@",startString, endString];
    }
}

//isNeedSkewing判断是否是子任务
- (void)setViewFromWithSkewing:(BOOL)isNeedSkewing
{
    // 背景
    if (isNeedSkewing) {
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(30);
        }];
    }else {
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
    }
    // 优先级
    [self.priorityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@5);
    }];
    
    // 是否完成
    [self.iconMarkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priorityView).offset(10);
        make.centerY.equalTo(self.bgView);
    }];
   
    [self.iconMarkButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.iconMarkButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    // 头像
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
        make.centerY.equalTo(self.bgView);
        make.width.height.equalTo(@40);
    }];

    if (_isNeedShowImage) {
        // 需要头像
        if (self.iconClockImgView.hidden && self.iconProjectImgView.hidden && self.iconFileImgView.hidden && self.iconDiscussLabel.hidden)
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImageView.mas_right).offset(10);
                make.centerY.equalTo(self.bgView);
                make.height.equalTo(@30);
                make.width.lessThanOrEqualTo(@(IOS_SCREEN_WIDTH - 200));
            }];
        }else
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImageView.mas_right).offset(10);
                make.top.equalTo(self.bgView);
                make.height.equalTo(@30);
                make.width.lessThanOrEqualTo(@(IOS_SCREEN_WIDTH - 200));
            }];
        }
    }
    else
    {
        if (self.iconClockImgView.hidden && self.iconProjectImgView.hidden && self.iconFileImgView.hidden && self.iconDiscussLabel.hidden)
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
                make.centerY.equalTo(self.bgView);
                make.height.equalTo(@30);
                make.width.lessThanOrEqualTo(@(IOS_SCREEN_WIDTH - 200));
            }];
        }
        else
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
                make.top.equalTo(self.bgView);
                make.height.equalTo(@30);
                make.width.lessThanOrEqualTo(@(IOS_SCREEN_WIDTH - 200));
            }];
        }
    }
    
    // 线
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.height.equalTo(@1);
    }];
    
    
    // 项目名
    if (!self.iconProjectImgView.hidden)
    {
            // 无截止时间
        [self.iconProjectImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        
        [self.projectNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconProjectImgView.mas_right).offset(10);
            make.centerY.equalTo(self.iconProjectImgView);
            make.width.lessThanOrEqualTo(self.bgView.mas_width).dividedBy(2);
        }];
    }
    
    
    // 截止时间
    if (!self.iconClockImgView.hidden)
    {
        //没有项目名
        if (self.iconProjectImgView.hidden)
        {
            [self.iconClockImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//                make.width.height.equalTo(@15);
            }];
        }else
        {
            [self.iconClockImgView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.projectNameLabel.mas_right).offset(5);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//                make.width.equalTo(@15);
            }];
        }
        
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconClockImgView.mas_right).offset(10);
            make.centerY.equalTo(self.iconClockImgView);
            if (self.iconProjectImgView.hidden)
            {
                make.width.lessThanOrEqualTo(@(IOS_SCREEN_WIDTH - 100));
            }else
            {
                make.width.lessThanOrEqualTo(@100);
            }
        }];
    }

    
    // 文件
    [self setFileConstraint];
    // 评论
    [self setDiscussConstraint];
    
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-5);
        make.centerY.equalTo(self.bgView);
    }];

    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchButton.mas_right);
        make.top.bottom.equalTo(self.bgView);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.bgView);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.bgView).offset(10);
    }];
}

- (void)setFileConstraint
{
    /*
    if (self.iconClockImgView.hidden && self.iconProjectImgView.hidden) {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left).offset (5);
//            make.centerY.equalTo(self.iconClockImgView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }else if (self.iconClockImgView.hidden && !self.iconProjectImgView.hidden) {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.projectNameLabel.mas_right).offset (5);
            make.centerY.equalTo(self.iconProjectImgView);
        }];
    }else if (!self.iconClockImgView.hidden && self.iconProjectImgView.hidden) {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_right).offset(5);
            make.centerY.equalTo(self.iconProjectImgView);
        }];
    }
     */
    if (!self.iconClockImgView.hidden)
    {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_right).offset(5);
            make.centerY.equalTo(self.iconProjectImgView);
        }];
    }else
    if (!self.iconProjectImgView.hidden)
    {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.projectNameLabel.mas_right).offset (5);
            make.centerY.equalTo(self.iconProjectImgView);
        }];
    }
    else
    {
        [self.iconFileImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left).offset (5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }
}
- (void)setDiscussConstraint
{
    if (!self.iconFileImgView.hidden) {
        [self.iconDiscussLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconFileImgView.mas_right).offset(5);
            make.centerY.equalTo(self.iconFileImgView);
            make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-10).priorityHigh();
        }];
    }else if (self.iconFileImgView.hidden && !self.iconClockImgView.hidden) {
        [self.iconDiscussLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_right).offset(5);
            make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-10).priorityHigh();
            make.centerY.equalTo(self.iconClockImgView);
        }];
    }else if (self.iconFileImgView.hidden && self.iconProjectImgView.hidden && self.iconClockImgView.hidden) {
        [self.iconDiscussLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-10).priorityHigh();
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }
}

- (UIView *)getSnapCurrentCell {
	//获取截屏
	UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndPDFContext();
	
	UIView *snapShot = [[UIImageView alloc] initWithImage:image];
	snapShot.layer.masksToBounds = NO;
	snapShot.layer.cornerRadius = 0.8;
	snapShot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
	snapShot.layer.shadowRadius = 0.4;
	snapShot.layer.shadowOpacity = 0.4;
	return snapShot;
}

- (void)setOpening:(BOOL)opening {
	_opening = opening;
	self.bgButton.selected = !opening;
	[self switchButtonClick];
}
#pragma mark - Lazy Initialize
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 3.0;
    }
    return _headImageView;
}
- (UIView *)priorityView
{
    if (!_priorityView) {
        _priorityView = [[UIView alloc] init];
        _priorityView.userInteractionEnabled = YES;
    }
    return _priorityView;
}

- (UIButton *)iconMarkButton
{
    if (!_iconMarkButton) {
        _iconMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconMarkButton addTarget:self action:@selector(iconMarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
    }
    return _iconMarkButton;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _titleLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.userInteractionEnabled = YES;
        _lineView.backgroundColor = FinishColor;
    }
    return _lineView;
}

- (UIImageView *)iconClockImgView
{
    if (!_iconClockImgView) {
        _iconClockImgView = [[UIImageView alloc] init];
        _iconClockImgView.userInteractionEnabled = YES;
        _iconClockImgView.image = [UIImage imageNamed:@"New_TimeClock"];
        _iconClockImgView.highlightedImage = [UIImage imageNamed:@"clock_red"];
        
    }
    return _iconClockImgView;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _timeLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIImageView *)iconProjectImgView
{
    if (!_iconProjectImgView) {
        _iconProjectImgView = [[UIImageView alloc] init];
        _iconProjectImgView.userInteractionEnabled  = YES;
        _iconProjectImgView.image = [UIImage imageNamed:@"folder"];
    }
    return _iconProjectImgView;
}
- (UILabel *)projectNameLabel
{
    if (!_projectNameLabel) {
        _projectNameLabel = [[UILabel alloc] init];
        _projectNameLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
        _projectNameLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _projectNameLabel;
}

- (UIImageView *)iconFileImgView
{
    if (!_iconFileImgView) {
        _iconFileImgView = [[UIImageView alloc] init];
        _iconFileImgView.userInteractionEnabled  = YES;
        _iconFileImgView.image = [UIImage imageNamed:@"paper-clip"];
    }
    return _iconFileImgView;
}
- (UIImageView *)iconDiscussLabel
{
    if (!_iconDiscussLabel) {
        _iconDiscussLabel = [[UIImageView alloc] init];
        _iconDiscussLabel.userInteractionEnabled  = YES;
        _iconDiscussLabel.image = [UIImage imageNamed:@"speach"];
    }
    return _iconDiscussLabel;
}

- (UILabel *)ratioLabel
{
    if (!_ratioLabel) {
        _ratioLabel = [[UILabel alloc] init];
        _ratioLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
        _ratioLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _ratioLabel;
}

- (UIImageView *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UIImageView alloc] init];
        [_switchButton setImage:[UIImage imageNamed:@"Mission_folder_off"]];
    }
    return _switchButton;
}
- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(switchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.userInteractionEnabled = YES;
        _lineView2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    return _lineView2;
}

@end
