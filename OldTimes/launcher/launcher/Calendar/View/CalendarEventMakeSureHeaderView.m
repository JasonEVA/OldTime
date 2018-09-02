//
//  CalendarEventMakeSureHeaderView.m
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarEventMakeSureHeaderView.h"
#import "CalendarEventMakeSureTimeSelectView.h"
#import "CalendarLaunchrModel.h"
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "Category.h"
#import "MyDefine.h"

static CGFloat radius = 5;
static CGFloat timeHeight = 35;

@interface CalendarEventMakeSureHeaderView ()<UIAlertViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *roundView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *lockImageView;
/** 复制按钮 */
@property (nonatomic, strong) UIButton *cpyButton;

@property (nonatomic, copy) void(^indexBlock)(NSInteger);

@property(nonatomic, copy) void(^clearBlock)() ;

// Data
/** 时间存储器 */
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *timeViewArray;

@property (nonatomic, assign) BOOL wholeDay;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, readonly) BOOL isReadOnlyMode;

@property(nonatomic, strong) CalendarEventMakeSureTimeSelectView  *selectedTimeView;

@end

@implementation CalendarEventMakeSureHeaderView

- (instancetype)initWithReadOnlyMode:(BOOL)readOnlyMode {
	if (self = [super init]) {
		_isReadOnlyMode = readOnlyMode;
	}
	
	return self;
}
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 0, 80)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.timeArray     = [NSMutableArray array];
        self.timeViewArray = [NSMutableArray array];
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.titleLabel];
    [self addSubview:self.lockImageView];
    [self addSubview:self.roundView];
    [self addSubview:self.detailLabel];
    [self addSubview:self.cpyButton];
    [self initConstraints];
}

- (void)initConstraints {
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.left.equalTo(self).offset(13);
        make.width.and.height.equalTo(@15).priorityHigh(1000);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel);
        make.right.equalTo(self.detailLabel.mas_left).offset(-8);
        make.width.height.equalTo(@(radius * 2));
    }];
    
    [self.cpyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self roundColor:[UIColor themeRed] text:LOCAL(MEETING_IMPORTANT)];
}

#pragma mark - Interface Method
- (void)setDataWithModel:(CalendarLaunchrModel *)model {

        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!model.isVisible) {
                make.left.equalTo(self.lockImageView.mas_right).offset(5);
                make.centerY.equalTo(self.lockImageView);
            }else
            {
                make.top.equalTo(self).offset(10);
                make.left.equalTo(self).offset(13);
                self.lockImageView.hidden = YES;
            }
            if (model.important) {
                make.right.equalTo(self.roundView.mas_left).offset(-5);
            }else
            {
                make.right.equalTo(self).offset(-10);
            }
        }];
        
    self.titleLabel.text = model.title;
    
    // 候补时间设置
    [self.timeArray removeAllObjects];
    [self.timeArray addObjectsFromArray:model.time];
    
    [self.roundView setHidden:!model.important];
    [self.detailLabel setHidden:!model.important];
    
    self.wholeDay = model.wholeDay;
    self.canSelect = [model.time count] > 2 && !self.isReadOnlyMode;
    
    [self addTimeArray];
    [self changeHeight];
}

- (void)getSelectIndexBlock:(void (^)(NSInteger))indexBlock {
    self.indexBlock = indexBlock;
}

- (void)clearSelectionBlock:(void (^)())block {
    self.clearBlock = block;
}
#pragma mark － uialterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self changeSelectedView:self.selectedTimeView];
    }
}



#pragma mark - Private Method
/** 计算高度变化 */
- (void)changeHeight {
    // 最小高度
    CGFloat height = 90;
    height += timeHeight * self.timeViewArray.count;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    if (self.superview) {
        [(UITableView *)(self.superview) setTableHeaderView:self];
    }
}

/** 设置⭕️颜色及文字 <－－－ 瞎扯，明明是这样🔴的(╯‵□′)╯︵┻━┻ */
- (void)roundColor:(UIColor *)roundColor text:(NSString *)text {
    self.roundView.backgroundColor = roundColor;
    self.detailLabel.textColor = roundColor;
    self.detailLabel.text = text;
}

/** 增加新的View */
- (void)addTimeArray {
    for (id view in self.timeViewArray) {
        [view removeFromSuperview];
    }
    [self.timeViewArray removeAllObjects];
    
    // 加入新东西
    UIView *lastView = self.titleLabel;
    for (NSInteger i = 0; i < self.timeArray.count; i += 2)
    {
        // 创建新候补时间
        CalendarEventMakeSureTimeSelectView *selectView = [[CalendarEventMakeSureTimeSelectView alloc] init];
		
        [selectView setIndex:i / 2 + 1];
        [selectView startTime:self.timeArray[i] endTime:self.timeArray[i + 1] wholeDay:self.wholeDay];
        
        if ([self.timeArray count] == 2) {
            [selectView setHideTitle:YES];
        }
        
        [self addSubview:selectView];
        [self.timeViewArray addObject:selectView];
        
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastView.mas_bottom);
        }];
		
		__weak typeof(self) weakSelf = self;
        // 点击时间
        [selectView didSelectBlock:^(CalendarEventMakeSureTimeSelectView *selectedView) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			if (!strongSelf) return ;
            
            //取消选择的状态
            if ([strongSelf.selectedTimeView isEqual:selectView]) {
                strongSelf.selectedTimeView = nil;
                [selectView selectStauts:NO];
                if (strongSelf.clearBlock) {
                    strongSelf.clearBlock();
                }
                return ;
            }
            strongSelf.selectedTimeView = selectedView;

			[strongSelf showAlertViewWithSelectedTimeView:selectedView];
//            [self changeSelectedView:selectedView];
        }];
        
        // 隐藏分割线
        if (i == self.timeArray.count - 2) {
            [selectView hideLine:YES];
        }
        
        // 点击响应
        [selectView setCanSelect:self.canSelect];
        
        // 对齐标准
        lastView = selectView;
    }
}

/** 改变选择对象 */
- (void)changeSelectedView:(CalendarEventMakeSureTimeSelectView *)selectedView {
    
    for (CalendarEventMakeSureTimeSelectView *selectView in self.timeViewArray)
    {
        if (selectedView == selectView) {
            [selectedView selectStauts:YES];
            if (self.indexBlock) {
                NSInteger index = [self.timeViewArray indexOfObject:selectedView];
                self.indexBlock(index);
            }
            continue;
        }
        [selectView selectStauts:NO];
    }
}

/**
 *  根据所选择候补时间给用户确认的提示
 *  @param selectedView 选择候补时间对应的时间选择器
 */
- (void)showAlertViewWithSelectedTimeView:(CalendarEventMakeSureTimeSelectView *)selectedView {
	if (self.timeViewArray.count * 2 < self.timeArray.count) {
		return;
	}
	
	NSUInteger index = [self.timeViewArray indexOfObject:selectedView];
	NSDate *startDate = self.timeArray[2*index];
	NSDate *endDate = self.timeArray[2*index+1];
	NSString *string = [startDate mtc_startToEndDate:endDate wholeDay:self.wholeDay];
	UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_SELECTEALTERNATEDATA) message:string delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CONFIRM), nil];
	[alterView show];
	
}

#pragma mark - Button Click
- (void)clickToCopy {
    //按钮暴力点击防御
    [self.cpyButton mtc_deterClickedRepeatedly];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
    
    NSString *strComponents = @"";

    for (NSInteger i = 0; i < self.timeArray.count; i += 2) {
        NSDate *startDate = self.timeArray[i];
        NSDate *endDate = self.timeArray[i + 1];
        
        NSString *string = [startDate mtc_startToEndDate:endDate wholeDay:self.wholeDay];
        string = [NSString stringWithFormat:@"%@%ld %@",LOCAL(CALENDAR_CONFIRM_ALTERNATE), i / 2 + 1, string];
        
        strComponents = [strComponents stringByAppendingFormat:@"%@%@",([strComponents length] ? @"\n":@""), string];
    }
    
    pasteboard.string = strComponents;
    
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_COPY) message:strComponents delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Initializer
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor themeBlue];
    }
    return _titleLabel;
}

-(UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView=[[UIImageView alloc]init];
        [_lockImageView setImage:[UIImage imageNamed:@"peoLock"]];
    }
    return _lockImageView;
}

- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc] init];
        _roundView.layer.cornerRadius = radius;
        _roundView.layer.masksToBounds = YES;
        _roundView.backgroundColor = [UIColor themeRed];
    }
    return _roundView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel ) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont mtc_font_26];
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (UIButton *)cpyButton {
    if (!_cpyButton) {
        _cpyButton = [[UIButton alloc] init];
        _cpyButton.expandSize = CGSizeMake(20, 0);
        [_cpyButton setTitle:LOCAL(CALENDAR_CONFIRM_COPY) forState:UIControlStateNormal];
        [_cpyButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        _cpyButton.titleLabel.font = [UIFont mtc_font_26];
        
        [_cpyButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        
        _cpyButton.layer.borderWidth = 0.5;
        _cpyButton.layer.borderColor = [UIColor themeBlue].CGColor;
        _cpyButton.layer.cornerRadius = 5;
        _cpyButton.layer.masksToBounds = YES;
        
        [_cpyButton addTarget:self action:@selector(clickToCopy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cpyButton;
}

@end
