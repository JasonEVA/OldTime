//
//  NewEventScheduleTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewEventScheduleTableViewCell.h"
#import "Images.h"
#import "AppScheduleModel.h"
#import "NSDate+MsgManager.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "NSDate+String.h"
#import "AvatarUtil.h"
#import "Category.h"
#import "UIFont+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LeftTriangle.h"
#import "TiptiltedView.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    Attend,
    Not_Attend,
} AttendEnum;

#define FONT_2 14
#define OFFSET 10
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]
#define BLUE_COLOR [UIColor colorWithRed:27/255.0 green:131/255.0 blue:254/255.0 alpha:1]

@interface NewEventScheduleTableViewCell()
@property (nonatomic, strong) UIImageView *imgViewHead;   //头像
@property (nonatomic, strong) UILabel *lblName;           //人名
@property (nonatomic, strong) UIView *viewContent;        //包含所有数据的view
@property (nonatomic, strong) UIView *viewTitle;          //title背景色
@property (nonatomic, strong) UILabel *lblTitle;          //title
@property (nonatomic, strong) UILabel *lblText1;          //时间
@property (nonatomic, strong) UILabel *lblText2;          //地点
@property (nonatomic, strong) UILabel *lblKind;           //类型
@property (nonatomic, strong) UILabel *lblTime;           //时间
@property (nonatomic, strong) UILabel *lblLine3;          //titile下面的分割线
@property (nonatomic, strong) UIImageView *imgView1;      //时间图标
@property (nonatomic, strong) UIImageView *imgView2;      //地点图标
@property (nonatomic,strong) UIButton * btnAttend;        //参加
@property (nonatomic,strong) UIButton * btnNotAttend;       //不参加
@property (nonatomic, strong) AppScheduleModel *scheduleModel;
@property (nonatomic, strong) MessageAppModel *messageAppModel;
@property (nonatomic, strong) LeftTriangle *leftTri;
@property (nonatomic, strong) TiptiltedView *viewChapter;
@end

@implementation NewEventScheduleTableViewCell

+ (CGFloat)heightForModel:(MessageBaseModel *)model {
    return model.appModel.msgHandleStatus == 1 ? 167.5 : 207.5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        [self setNeedsUpdateConstraints];
    }
    return self;
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
    
    [self.contentView addSubview:self.imgView1];
    [self.contentView addSubview:self.imgView2];
    
    [self.contentView addSubview:self.lblText1];
    [self.contentView addSubview:self.lblText2];
    
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.leftTri];
    [self.viewContent addSubview:self.viewChapter];
    
    [self.viewContent addSubview:self.btnAttend];
    [self.viewContent addSubview:self.btnNotAttend];
}

- (void)updateConstraints
{
    
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(12);
        make.top.equalTo(self.imgViewHead);
//        make.height.equalTo(@20);
    }];
    
//    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lblName);
//        make.height.equalTo(@110);
//        make.right.equalTo(self.contentView).offset(-13);
//        make.top.equalTo(self.lblName.mas_bottom).offset(2);
//    }];
    
    [self.viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.viewContent);
        make.height.equalTo(@40);
    }];
    
    [self.lblKind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewTitle).offset(-12);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
        //        make.width.equalTo(@50);
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTitle).offset(12);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
        make.right.equalTo(self.lblKind.mas_left).offset(-5);
    }];
    
    [self.imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle);
        //        make.top.equalTo(self.viewTitle.mas_bottom).offset(8);150
        make.centerY.equalTo(self.lblText1);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    [self.imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.width.equalTo(@16);
        make.centerY.equalTo(self.lblText2);
        make.left.equalTo(self.lblTitle);
        //        make.top.equalTo(self.lblText1.mas_bottom).offset(8);
    }];
    
    [self.lblText1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView1.mas_right).offset(8);
        make.top.equalTo(self.viewTitle.mas_bottom).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.viewContent.mas_right).offset(-5);
    }];
    
    [self.lblText2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView2.mas_right).offset(8);
        make.top.equalTo(self.lblText1.mas_bottom).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.viewContent.mas_right).offset(-5);
    }];
    
//    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@20);
//        make.top.equalTo(self.viewContent.mas_bottom);
//    }];
    
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
    
//    [self.viewChapter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.viewContent).offset(12);
//        make.bottom.equalTo(self.viewContent).offset(2);
//        make.width.equalTo(@102);
//        make.height.equalTo(@50.5);
//    }];
//    float Width = (IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 5*2 - 8*2)/3;    //5是按钮间的宽度   8是按钮两边跟父类的距离
//    [self.btnAttend mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.viewContent).offset((Width + 5)*0 + 8);
//        make.bottom.equalTo(self.viewContent).offset(-12);
//        make.height.equalTo(@30);
//        make.width.equalTo(@(Width));
//    }];
//    
//    [self.btnNotAttend mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.viewContent).offset((Width + 5)*1 + 8);
//        make.bottom.equalTo(self.viewContent).offset(-12);
//        make.height.equalTo(@30);
//        make.width.equalTo(@(Width));
//    }];
    
    [super updateConstraints];
}

- (void)setCellDataWithSystem:(MessageBaseModel *)model
{
    //初始行高
    self.rowHight = 193;
    //取出下层model
    self.messageAppModel = model.appModel;
    self.scheduleModel = [AppScheduleModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
    //设置标题 姓名
    [self.lblName setText:model.appModel.msgFrom];
    [self.lblTitle setText:self.messageAppModel.msgContent];
    
    //设置时间
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES]];
    
    //设置类别
    if ([model.appModel.msgAppType isEqualToString:@"MEETING"])
    {
        [self.lblKind setText:LOCAL(MEETING)];
    }
    else if ([model.appModel.msgAppType isEqualToString:@"EVENT"])
    {
        [self.lblKind setText:@"事件"];
    }
    
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, model.appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.viewChapter.hidden = NO;
    if (/*(!model.appModel.scheduleModel.isAgree && model.appModel.msgHandleStatus == 1)|| */[model.appModel.msgTransType isEqualToString:@"meetingRefuseAttendDefinite"]  || [model.appModel.msgTransType isEqualToString:@"meetingRefuseAttend"])
    {
        [self.viewChapter setdataWithType:viewKind_RejectAttend];
    }
    else if (self.scheduleModel.isAgree ||[model.appModel.msgTransType isEqualToString:@"meetingAttend"] || [model.appModel.msgTransType isEqualToString:@"meetingAttendDefinite"])
    {
        [self.viewChapter setdataWithType:viewKind_Attended];
    }
    else
    {
        self.viewChapter.hidden = YES;
    }
    
    //设置时间时间
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.start/1000];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.end/1000];
    NSString * string = [date1 mtc_startToEndDate:date2];
    [self.lblText1 setText:string];
    
    //设置地点 （会议室优先级高）
    if (self.scheduleModel.roomName.length != 0)
    {
        //设置会议场地
        [self.lblText2 setText:self.scheduleModel.roomName];
    }
    else
    {
        [self.lblText2 setText:self.scheduleModel.external];
    }
    
    float Width = (IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 5*2 - 8*2)/3;    //5是按钮间的宽度   8是按钮两边跟父类的距离
    if (self.messageAppModel.msgHandleStatus) {
        //已处理，隐藏下方按钮
        self.btnNotAttend.hidden = YES;
        self.btnAttend.hidden = YES;
        self.rowHight = self.rowHight - 41;
        
        [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblName);
            make.height.equalTo(@110);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.lblName.mas_bottom).offset(2);
        }];
        
        [self.lblTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.top.equalTo(self.viewContent.mas_bottom);
        }];
        
        [self.viewChapter mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewContent).offset(12);
            make.bottom.equalTo(self.viewContent).offset(2);
            make.width.equalTo(@102);
            make.height.equalTo(@50.5);
        }];
    }
    else
    {
        //未处理，显示下方按钮
        self.btnNotAttend.hidden = NO;
        self.btnAttend.hidden = NO;
        
        [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblName);
            make.height.equalTo(@150);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.lblName.mas_bottom).offset(2);
        }];
        
        [self.lblTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.top.equalTo(self.viewContent.mas_bottom);
        }];
        [self.btnAttend mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewContent).offset((Width + 5)*0 + 8);
            make.bottom.equalTo(self.viewContent).offset(-12);
            make.height.equalTo(@30);
            make.width.equalTo(@(Width));
        }];
        
        [self.btnNotAttend mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewContent).offset((Width + 5)*1 + 8);
            make.bottom.equalTo(self.viewContent).offset(-12);
            make.height.equalTo(@30);
            make.width.equalTo(@(Width));
        }];
        
        [self.viewChapter mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewContent).offset(12);
            make.bottom.equalTo(self.viewContent).offset(2);
            make.width.equalTo(@102);
            make.height.equalTo(@50.5);
        }];
    }
    
    //设置是否已读
    //    if (self.messageAppModel.msgReadStatus == 0) {
    //        [self.redpoint setHidden:NO];
    //    }
    //    else
    //    {
    //        [self.redpoint setHidden:YES];
    //    }
}

- (void)setCellData:(MessageBaseModel *)model
{
    //初始行高
    self.rowHight = 193;
    //取出下层model
    self.messageAppModel = model.appModel;
    self.scheduleModel = [AppScheduleModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
    //设置标题 姓名
    [self.lblName setText:model.appModel.msgFrom];
    [self.lblTitle setText:self.messageAppModel.msgTitle];
    
    //设置类别
    if ([model.appModel.msgAppType isEqualToString:@"MEETING"])
    {
        [self.lblKind setText:LOCAL(MEETING)];
    }
    else if ([model.appModel.msgAppType isEqualToString:@"EVENT"])
    {
        [self.lblKind setText:@"事件"];
    }
    
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES]];
    
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, model.appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.viewChapter.hidden = NO;
    if ((!self.scheduleModel.isAgree && model.appModel.msgHandleStatus == 1)|| [model.appModel.msgTransType isEqualToString:@"meetingRefuseAttendDefinite"]  || [model.appModel.msgTransType isEqualToString:@"meetingRefuseAttend"])
    {
        [self.viewChapter setdataWithType:viewKind_RejectAttend];
    }
    else if (self.scheduleModel.isAgree ||[model.appModel.msgTransType isEqualToString:@"meetingAttend"] || [model.appModel.msgTransType isEqualToString:@"meetingAttendDefinite"])
    {
        [self.viewChapter setdataWithType:viewKind_Attended];
    }
    else
    {
        self.viewChapter.hidden = YES;
    }
    
    //设置时间时间
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.start/1000];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.end/1000];
    NSString * string = [date1 mtc_startToEndDate:date2];
    [self.lblText1 setText:string];
    
    //设置地点 （会议室优先级高）
    if (self.scheduleModel.roomName.length != 0)
    {
        //设置会议场地
        [self.lblText2 setText:self.scheduleModel.roomName];
    }
    else
    {
        [self.lblText2 setText:self.scheduleModel.external];
    }
    
    float Width = (IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 5*2 - 8*2)/3;    //5是按钮间的宽度   8是按钮两边跟父类的距离
    if (self.messageAppModel.msgHandleStatus) {
        //已处理，隐藏下方按钮
        self.btnNotAttend.hidden = YES;
        self.btnAttend.hidden = YES;
        self.rowHight = self.rowHight - 41;
        
        [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblName);
            make.height.equalTo(@110);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.lblName.mas_bottom).offset(2);
        }];
        
        [self.lblTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.top.equalTo(self.viewContent.mas_bottom);
        }];
        
        [self.viewChapter mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewContent).offset(12);
            make.bottom.equalTo(self.viewContent).offset(2);
            make.width.equalTo(@102);
            make.height.equalTo(@50.5);
        }];
    }
    else
    {
        //未处理，显示下方按钮
        self.btnNotAttend.hidden = NO;
        self.btnAttend.hidden = NO;
        [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblName);
            make.height.equalTo(@150);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.lblName.mas_bottom).offset(2);
        }];
        
        [self.viewChapter mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewContent).offset(12);
            make.bottom.equalTo(self.viewContent).offset(2);
            make.width.equalTo(@102);
            make.height.equalTo(@50.5);
        }];
        
        [self.lblTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.top.equalTo(self.viewContent.mas_bottom);
        }];
        [self.btnAttend mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewContent).offset((Width + 5)*0 + 8);
            make.bottom.equalTo(self.viewContent).offset(-12);
            make.height.equalTo(@30);
            make.width.equalTo(@(Width));
        }];
        
        [self.btnNotAttend mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewContent).offset((Width + 5)*1 + 8);
            make.bottom.equalTo(self.viewContent).offset(-12);
            make.height.equalTo(@30);
            make.width.equalTo(@(Width));
        }];
    }
    

    //设置是否已读
//    if (self.messageAppModel.msgReadStatus == 0) {
//        [self.redpoint setHidden:NO];
//    }
//    else
//    {
//        [self.redpoint setHidden:YES];
//    }
}

- (void)btnClick:(UIButton *)sender
{
    BOOL agree;
    if (sender.tag == 0)
    {
        agree = YES;
    }
    else
    {
        agree = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:ShowId:)])
    {
        [self.delegate ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:agree ShowId:self.scheduleModel.id];
    }
}

#pragma mark - InIt UI
- (UIImageView *)imgView1
{
    if (!_imgView1)
    {
        _imgView1 = [[UIImageView alloc] init];
        [_imgView1 setImage:[UIImage imageNamed:@"chat_calendar_eventTime"]];
        
    }
    return _imgView1;
}

- (UIImageView *)imgView2
{
    if (!_imgView2)
    {
        _imgView2 = [[UIImageView alloc] init];
        [_imgView2 setImage:[UIImage imageNamed:@"chat_pointer"]];
    }
    return _imgView2;
}

- (UILabel *)lblText1
{
    if (!_lblText1)
    {
        _lblText1 = [[UILabel alloc] init];
        [_lblText1 setTextAlignment:NSTextAlignmentLeft];
        [_lblText1 setFont:[UIFont mtc_font_26]];
        [_lblText1 setTextColor:[UIColor blackColor]];
    }
    return _lblText1;
}

- (UILabel *)lblText2
{
    if (!_lblText2)
    {
        _lblText2 = [[UILabel alloc] init];
        [_lblText2 setTextAlignment:NSTextAlignmentLeft];
        [_lblText2 setFont:[UIFont mtc_font_26]];
        [_lblText2 setTextColor:[UIColor blackColor]];
    }
    return _lblText2;
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
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor: [UIColor mtc_colorWithHex:0xdfeefe] colorBorderColor:[UIColor mtc_colorWithHex:0xc9d8e9]];
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
        _viewContent.layer.borderColor = [UIColor mtc_colorWithHex:0xc9d8e9].CGColor;
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
        [_viewTitle setBackgroundColor:[UIColor mtc_colorWithHex:0xdfeefe]];
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
        [_lblKind setTextColor:[UIColor mtc_colorWithHex:0x3e99ff]];
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

- (UIButton *)btnNotAttend
{
    if (!_btnNotAttend) {
        _btnNotAttend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnNotAttend setTitle:LOCAL(MEETING_NOTATTEND) forState:UIControlStateNormal];
        [_btnNotAttend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnNotAttend.tag = 1;
        _btnNotAttend.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnNotAttend.layer.cornerRadius = 3.0f;
        _btnNotAttend.clipsToBounds = YES;
        _btnNotAttend.layer.borderWidth = 2.0f;
        [_btnNotAttend setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
        _btnNotAttend.layer.borderColor = [UIColor themeRed].CGColor;
        [_btnNotAttend addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnNotAttend;
}
- (UIButton *)btnAttend{
    if (!_btnAttend) {
        _btnAttend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAttend setTitle:LOCAL(MEETING_ATTEND) forState:UIControlStateNormal];
        _btnAttend.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnAttend.layer.cornerRadius = 3.0f;
        _btnAttend.clipsToBounds = YES;
        _btnAttend.layer.borderWidth = 2.0f;
        _btnAttend.tag = 0;
        [_btnAttend setTitleColor:[UIColor themeGreen] forState:UIControlStateNormal];
        _btnAttend.layer.borderColor = [UIColor themeGreen].CGColor;
        [_btnAttend addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnAttend;
}

- (UILabel *)lblLine3
{
    if (!_lblLine3)
    {
        _lblLine3 = [[UILabel alloc] init];
        _lblLine3.backgroundColor = [UIColor mtc_colorWithHex:0xc9d8e9];
    }
    return _lblLine3;
}
@end
