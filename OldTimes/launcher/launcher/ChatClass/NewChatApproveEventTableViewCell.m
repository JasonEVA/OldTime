//
//  NewChatApproveEventTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewChatApproveEventTableViewCell.h"
#import "Images.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AvatarUtil.h"
#import "AppApprovalModel.h"
#import "MyDefine.h"
#import "Category.h"
#import "UIFont+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LeftTriangle.h"
#import "TiptiltedView.h"
#import <DateTools/DateTools.h>
#import "NewApplyFormTimeModel.h"
#import "NewApplyFormPeriodModel.h"
#import "NSDictionary+SafeManager.h"
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
#define FONT_2 14
#define OFFSET 10

typedef enum{
    btnKind_Approve = 0,
    btnKind_Reject = 1,
    btnKind_back = 2
}btnKind;

@interface NewChatApproveEventTableViewCell()
@property (nonatomic, strong) UIImageView *imgViewHead;   //头像
@property (nonatomic, strong) UILabel *lblName;           //人名
@property (nonatomic, strong) UIView *viewContent;        //包含所有数据的view
@property (nonatomic, strong) UIView *viewTitle;          //title背景色
@property (nonatomic, strong) UILabel *lblTitle;          //title

@property (nonatomic, strong) UILabel *lblKind;    //类型
@property (nonatomic, strong) UILabel *lblTime;    //时间
@property (nonatomic, strong) UILabel *lblLine3;   //title下面的分割线

@property (nonatomic,strong) UIButton * unStandardButton;//打回
@property (nonatomic,strong) UIButton * vetoButton;      //否决
@property (nonatomic,strong) UIButton * consentButton;   //同意
@property (nonatomic) BOOL isWorkFlow;
@property (nonatomic, strong) AppApprovalModel *Approvalmodel;
@property (nonatomic, strong) MessageAppModel *messageAppModel;
@property (nonatomic, strong) LeftTriangle *leftTri;
@property (nonatomic, strong) TiptiltedView *viewChapter;

/// 存放4个label
@property (nonatomic, strong) NSArray<UILabel *> *showingLabelsArray;

@end

@implementation NewChatApproveEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.showingLabelsArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = nil;
        obj.hidden = YES;
    }];
}

#pragma mark - initComponent
- (void)initComponent
{
    [self.contentView addSubview:self.imgViewHead];
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.viewContent];
    [self.viewContent addSubview:self.viewTitle];
    [self.viewTitle addSubview:self.lblTitle];
    [self.viewTitle addSubview:self.lblKind];
    [self.viewContent addSubview:self.lblLine3];
    
    for (UILabel *label in self.showingLabelsArray) {
        [self.contentView addSubview:label];
    }
    
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.leftTri];
    [self.viewContent addSubview:self.viewChapter];
    
    [self.viewContent addSubview:self.unStandardButton];
    [self.viewContent addSubview:self.vetoButton];
    [self.viewContent addSubview:self.consentButton];
    
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblName);
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.lblName.mas_bottom).offset(2);
        make.bottom.equalTo(self.lblTime.mas_top).offset(-10);
    }];
    
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(12);
        make.top.equalTo(self.imgViewHead);
//        make.height.equalTo(@20);
    }];
    
    [self.viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.viewContent);
		make.height.equalTo(@40);
    }];
    
    [self.lblKind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewTitle).offset(-15);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTitle).offset(15);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
        make.right.equalTo(self.lblKind.mas_left).offset(-5);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewTitle).offset(-3);
        make.right.equalTo(self.viewTitle.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@40);
    }];
    
    [self.lblLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewTitle);
        make.height.equalTo(@1);
        make.top.equalTo(self.viewTitle.mas_bottom).offset(-1);
    }];
    
    [self.viewChapter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewContent).offset(12);
        make.bottom.equalTo(self.viewContent).offset(2);
        make.width.equalTo(@102);
        make.height.equalTo(@50.5);
    }];
}

- (void)setCellData:(MessageBaseModel *)model
{
    //设置章
    self.viewChapter.hidden = NO;
    AppApprovalModel *approvalModel = [AppApprovalModel mj_objectWithKeyValues:model.appModel.applicationDetailDictionary];
    if ([approvalModel.approvalStatus isEqualToString:@"DENY"])
    {
        [self.viewChapter setdataWithType:viewKind_RejectApprove];
    }
    else if ([approvalModel.approvalStatus isEqualToString:@"APPROVE"])
    {
        [self.viewChapter setdataWithType:viewKind_Approve];
    }
    else if ([approvalModel.approvalStatus isEqualToString:@"CALL_BACK"])
    {
        [self.viewChapter setdataWithType:viewKind_BackApprove];
    }
    else if ([approvalModel.approvalStatus isEqualToString:@"WAITING"]) //TRANSMIT
    {
        [self.viewChapter setdataWithType:viewKind_PassTo];
    }
    else
    {
        self.viewChapter.hidden = YES;
    }
    
    self.messageAppModel = model.appModel;
    self.Approvalmodel = approvalModel;
    
    // 设置标题
    [self.lblTitle setText:self.messageAppModel.msgTitle];
    
    // 设置类型
    [self.lblKind setText:approvalModel.approvalType];
    
    // 设置显示内容
    NSArray *formArray = [self.Approvalmodel sortedForChatUI];
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont mtc_font_26], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *timeAttributes   = @{NSFontAttributeName:[UIFont mtc_font_26], NSForegroundColorAttributeName:[UIColor themeRed]};
    NSInteger count = MIN([formArray count], [self.showingLabelsArray count]);
    
    // 最后约束参考的View
    UIView *lastView = self.viewTitle;
    
    //设置显示文字
    for (NSInteger i = 0 ; i < count; i ++)
    {
        
        NewApplyFormBaseModel *formModel = [formArray objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@ : ", formModel.labelText];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:normalAttributes];
        
        id value = [approvalModel.approvalFormData valueDictonaryForKey:formModel.key];
        
        if (formModel.inputType == Form_inputType_textInput ||
            formModel.inputType == Form_inputType_textArea)
        {
            if (![value isKindOfClass:[NSString class]]) {
                value = @"";
            }
            
            if ([value length]) {
                NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:value attributes:normalAttributes];
                [attrString appendAttributedString:tmpString];
            }
        }
        else if (formModel.inputType == Form_inputType_timeSlot && [value isKindOfClass:[NSDictionary class]]) {
            NSDate *start = [value valueDateForKey:NewForm_startTime];
            NSDate *end   = [value valueDateForKey:NewForm_endTime];
			
			BOOL isWholeDay = [value valueBoolForKey:NewForm_isTimeSlotAllDay];
			
            NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:[start mtc_startToEndDate:end wholeDay:isWholeDay] attributes:timeAttributes];
            [attrString appendAttributedString:tmpString];
        }
        else if (formModel.inputType == Form_inputType_timePoint ||
                 formModel.inputType == Form_inputType_approvePeriod)
        {
            NSDate *date;
            BOOL isWholeDay = NO;
            if (formModel.inputType == Form_inputType_approvePeriod && [value isKindOfClass:[NSDictionary class]]) {
                date = [value valueDateForKey:NewForm_deadline];
                isWholeDay = [value valueBoolForKey:NewForm_isDeadLineAllDay];
            } else {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    date = [value valueDateForKey:@"startTime"];
                    isWholeDay = [value valueBoolForKey:NewForm_isTimeSlotAllDay];
                }else
                {
                    date = [approvalModel.approvalFormData valueDateForKey:formModel.key];
                }
                
            }
            
            if ([date timeIntervalSince1970] != 0) {
                
                NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:[NSDate mtc_getDateStrWihtDate:date isWholeDay:isWholeDay] attributes:timeAttributes];
                [attrString appendAttributedString:tmpString];
            }
        }
        else if (formModel.inputType == Form_inputType_singleChoose ||
                 formModel.inputType == Form_inputType_multiChoose)
        {
            if (formModel.inputType == Form_inputType_singleChoose) {
                value = @[value];
            }
            NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:[value componentsJoinedByString:@","] attributes:normalAttributes];
            [attrString appendAttributedString:tmpString];
        }
        
        // 显示
        UILabel *showLabel = [self.showingLabelsArray objectAtIndex:i];
        showLabel.attributedText = attrString;
        showLabel.hidden = NO;
        
        [showLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblTitle);
            make.right.equalTo(self.viewContent).offset(-5);
            make.top.equalTo(lastView.mas_bottom).offset(15);
            make.height.equalTo(@20);
        }];
        
        lastView = showLabel;
    }
    
    //初始化按钮
    self.isWorkFlow = [approvalModel.workflowId length] > 0;
    [self.consentButton removeConstraints:self.consentButton.constraints];
    [self.vetoButton removeConstraints:self.vetoButton.constraints];
    [self.unStandardButton removeConstraints:self.unStandardButton.constraints];
    self.consentButton.hidden = YES;
    self.vetoButton.hidden = YES;
    self.unStandardButton.hidden = YES;

    BOOL needApprove  = YES;
    BOOL needDeny     = YES;
    BOOL needCallBack = YES;
    
    if (self.messageAppModel.msgHandleStatus == 0)
    {
        //增加按钮
        //        float Width = (IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 5*2 - 15*2)/3;    //5是按钮间的宽度   8是按钮两边跟父类的距离
        
        CGFloat width = 65;

        
        /**flag: 这段代码似乎有问题**/
        if (self.isWorkFlow) {
            needApprove  = NO;
            needDeny     = NO;
            needCallBack = NO;
            
            for (NSString *str in approvalModel.triggers) {
                if ([str isEqualToString:@"APPROVE"])       needApprove = YES;
                else if ([str isEqualToString:@"DENY"])     needDeny = YES;
                else if ([str isEqualToString:@"TRANSMIT"]) needCallBack = YES;
                else if ([str isEqualToString:@"CALL_BACK"]) { /** do nothing */ }
            }
        }
        
        NSInteger i = 0;
        if (needApprove)
        {
            self.consentButton.hidden = NO;
            self.viewChapter.hidden = YES;
            [self.consentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.viewContent).offset((width + 5) * i + 15);
                make.top.equalTo(lastView.mas_bottom).offset(12);
                make.height.equalTo(@30);
                make.width.equalTo(@(width));
                make.bottom.equalTo(self.viewContent).offset(-10).priorityLow();
            }];
            i++;
        }
        
        if (needDeny)
        {
            self.vetoButton.hidden = NO;
            self.viewChapter.hidden = YES;
            [self.vetoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.viewContent).offset((width + 5) * i + 15);
                make.top.equalTo(lastView.mas_bottom).offset(12);
                make.height.equalTo(@30);
                make.width.equalTo(@(width));
                make.bottom.equalTo(self.viewContent).offset(-10).priorityLow();
            }];
            i++;
        }
        
        if (needCallBack)
        {
            self.unStandardButton.hidden = NO;
            self.viewChapter.hidden = YES;
            [self.unStandardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.viewContent).offset((width + 5) * i + 15);
                make.top.equalTo(lastView.mas_bottom).offset(12);
                make.height.equalTo(@30);
                make.width.equalTo(@(width));
                make.bottom.equalTo(self.viewContent).offset(-10).priorityLow();
            }];
            i++;
        }
    }
    
    //显示优化
    if (!needDeny && !needApprove && !needCallBack) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.viewContent).offset(-10);
        }];
    }
    
    //修复在转发时，被转发方印章和按钮同时显示的问题
//    self.viewChapter.hidden = !self.unStandardButton.hidden&&!self.vetoButton.hidden&&!self.consentButton.hidden;
    
    [self.lblName setText: model.appModel.msgFrom];
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES]];

    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, model.appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (CGFloat)cellHeightWithAppModel:(MessageAppModel *)content {
	MessageAppModel *  messageAppModel = (MessageAppModel*)content;
	AppApprovalModel *approveModel = [AppApprovalModel mj_objectWithKeyValues:messageAppModel.applicationDetailDictionary];
	
	// 要显示的行数
	NSInteger showIndex = MIN(4, [approveModel sortedForChatUI].count);
	CGFloat height = 97.5 + showIndex * 35;
	if (messageAppModel.msgHandleStatus == 0) {
		height += 50;
	} else {
		height += 20;
	}
	
	return height;
	
}

#pragma mark - tool
- (void)setBtnHidden:(BOOL)isHidden
{
    _unStandardButton.hidden = isHidden;//打回
    _vetoButton.hidden = isHidden;      //否决
    _consentButton.hidden = isHidden;   //同意
}

- (NSString *)getDeadLineTime:(long long)time
{
    if (time <= 0)
    {
        return nil;
    }
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
    }
    else if (date.year == today.year)
    {
        //        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld%@",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute,LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld",(long)date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@",[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    if ([str hasPrefix:@"1970"]) return @"";
    return str;
} 

- (void)btnClick:(UIButton *)sender
{
    NSString *type;
    switch (sender.tag)
    {
        case btnKind_Approve:
            type = @"APPROVE";
            break;
        case btnKind_Reject:
            type = @"DENY";
            break;
        case btnKind_back:
            type = @"CALL_BACK";
            break;
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(approvalCellButtonClick:path_row: isWorkFlow:)]) {
        [_delegate approvalCellButtonClick:type path_row:self.path_row isWorkFlow:self.isWorkFlow];
    }
}

#pragma mark - Create
- (UILabel *)createShowingLabel {
    UILabel *label = [UILabel new];
    
    label.font = [UIFont mtc_font_26];
    label.textColor = [UIColor blackColor];
    
    return label;
}

#pragma mark - InIt UI
- (NSArray<UILabel *> *)showingLabelsArray {
    if (!_showingLabelsArray) {
        _showingLabelsArray = @[[self createShowingLabel], [self createShowingLabel], [self createShowingLabel], [self createShowingLabel]];
    }
    
    return _showingLabelsArray;
}

- (TiptiltedView *)viewChapter
{
    if (!_viewChapter)
    {
        _viewChapter = [[TiptiltedView alloc] init];
    }
    return _viewChapter;
}

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor mtc_colorWithHex:0xe8f6f1] colorBorderColor:[UIColor mtc_colorWithHex:0xa7e1cc]];
    }
    return _leftTri;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 2;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
        [_lblName setTextColor:[UIColor blackColor]];
        [_lblName setFont:[UIFont mtc_font_26]];
    }
    return _lblName;
}

- (UIView *)viewContent
{
    if (!_viewContent)
    {
        _viewContent = [[UIView alloc] init];
        [_viewContent setBackgroundColor:[UIColor whiteColor]];
        _viewContent.layer.cornerRadius = 10;
        _viewContent.layer.borderColor = [UIColor mtc_colorWithHex:0xa7e1cc].CGColor;
        _viewContent.layer.borderWidth = 1;
        _viewContent.clipsToBounds = YES;
    }
    return _viewContent;
}

- (UIView *)viewTitle
{
    if (!_viewTitle)
    {
        _viewTitle = [[UIView alloc] init];
        [_viewTitle setBackgroundColor:[UIColor mtc_colorWithHex:0xe8f6f1]];
        //        _viewTitle.layer.cornerRadius = 10;
        _viewTitle.clipsToBounds = YES;
    }
    return _viewTitle;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setFont:[UIFont mtc_font_30]];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    }
   
    return _lblTitle;
}

- (UILabel *)lblKind
{
    if (!_lblKind)
    {
        _lblKind = [[UILabel alloc] init];
        [_lblKind setFont:[UIFont mtc_font_30]];
        [_lblKind setTextColor:[UIColor mtc_colorWithHex:0x29ba85]];
        [_lblKind setTextAlignment:NSTextAlignmentRight];
        [_lblKind setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        //        [_lblKind setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblKind;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setTextAlignment:NSTextAlignmentCenter];
        [_lblTime setFont:[UIFont mtc_font_26]];
        [_lblTime setTextColor:GRAY_COLOR];
    }
    return _lblTime;
}

- (UIButton *)unStandardButton
{
    if (!_unStandardButton) {
        _unStandardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unStandardButton setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
        _unStandardButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _unStandardButton.layer.cornerRadius = 3.0f;
        _unStandardButton.clipsToBounds = YES;
        _unStandardButton.layer.borderWidth = 1.0f;
        _unStandardButton.tag = btnKind_back;
        [_unStandardButton setTitleColor:[UIColor mtc_colorWithHex:0xff8500] forState:UIControlStateNormal];
        _unStandardButton.layer.borderColor = [UIColor mtc_colorWithHex:0xff8500].CGColor;
        [_unStandardButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unStandardButton;
}

- (UIButton *)vetoButton{
    if (!_vetoButton) {
        _vetoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vetoButton setTitle:LOCAL(REFUSE) forState:UIControlStateNormal];
        [_vetoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _vetoButton.tag = btnKind_Reject;
        _vetoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _vetoButton.layer.cornerRadius = 3.0f;
        _vetoButton.clipsToBounds = YES;
        _vetoButton.layer.borderWidth = 1.0f;
        [_vetoButton setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
        _vetoButton.layer.borderColor = [UIColor themeRed].CGColor;
        [_vetoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _vetoButton;
}
- (UIButton *)consentButton{
    if (!_consentButton) {
        _consentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consentButton setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
        _consentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _consentButton.layer.cornerRadius = 3.0f;
        _consentButton.clipsToBounds = YES;
        _consentButton.layer.borderWidth = 1.0f;
        _consentButton.tag = btnKind_Approve;
        [_consentButton setTitleColor:[UIColor themeGreen] forState:UIControlStateNormal];
        _consentButton.layer.borderColor = [UIColor themeGreen].CGColor;
        [_consentButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _consentButton;
}

- (UILabel *)lblLine3
{
    if (!_lblLine3)
    {
        _lblLine3 = [[UILabel alloc] init];
        _lblLine3.backgroundColor = [UIColor mtc_colorWithHex:0xa7e1cc];
    }
    return _lblLine3;
}

@end
