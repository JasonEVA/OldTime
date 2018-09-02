//
//  NewChatEventMissionTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewChatEventMissionTableViewCell.h"
#import "Images.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AppTaskModel.h"
#import "MyDefine.h"
#import "Category.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AvatarUtil.h"
#import "UIFont+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LeftTriangle.h"
#import <DateTools/DateTools.h>

#define LOW_COLOR [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]      //优先级低的颜色
#define HIGH_COLOR [UIColor colorWithRed:246/255.0 green:20/255.0 blue:84/255.0 alpha:1]      //优先级高的颜色
#define MEDIUM_COLOR [UIColor colorWithRed:247/255.0 green:167/255.0 blue:89/255.0 alpha:1]   //优先级中的颜色
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
#define FONT_2 14
#define OFFSET 10
static BOOL needExtendHeight = NO;

@interface NewChatEventMissionTableViewCell()
@property (nonatomic, strong) UIImageView *imgViewHead;   //头像
@property (nonatomic, strong) UILabel *lblName;           //人名
@property (nonatomic, strong) UIView *viewContent;        //包含所有数据的view
@property (nonatomic, strong) UIView *viewTitle;          //title背景色
@property (nonatomic, strong) UILabel *lblTitle;          //title
@property (nonatomic, strong) UIButton *btnEndTime;       //截止时间
@property (nonatomic, strong) UIButton *btnProjectName;   //项目名称
@property (nonatomic, strong) UIButton *btnDone;          //完成状态
//@property (nonatomic, strong) UIButton *btnChildTask;     //子任务数量
@property (nonatomic, strong) UIButton *btnLevel;         //任务等级
@property (nonatomic, strong) UIImage *imgLevelColor;     //颜色
@property (nonatomic, strong) UILabel *lblKind;    //类型
@property (nonatomic, strong) UILabel *lblTime;    //时间
@property (nonatomic, strong) UILabel *lblLine3;   //titile下面的分割线
@property (nonatomic, strong) AppTaskModel *taskModel;
@property (nonatomic, strong) MessageAppModel *messageAppModel;
@property (nonatomic, strong) LeftTriangle *leftTri;
@end

@implementation NewChatEventMissionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        
        self.backgroundColor = [UIColor clearColor];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToShowDetail)];
//        [self.bgView setUserInteractionEnabled:YES];
//        [self.bgView addGestureRecognizer:tapGesture];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - updateConstraints

- (void)updateConstraints
{
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(12);
        make.top.equalTo(self.imgViewHead);
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
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.top.equalTo(self.viewContent.mas_bottom);
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
    
    [super updateConstraints];
}

#pragma mark - setData

- (void)setCellData:(MessageBaseModel *)model
{
    //取出下层MODEL
    self.messageAppModel = model.appModel;
    self.taskModel = [AppTaskModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
    
    //设置标题 姓名 头像
    //设置标题 姓名
    [self.lblName setText:model.appModel.msgFrom];
    
    [self.lblTitle setText:self.messageAppModel.msgTitle];
    
    //设置时间
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES]];
    
    //设置类别

    [self.lblKind setText:LOCAL(Application_Mission)];
    
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, model.appModel.msgFromID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    
    if (self.taskModel.end <= 0)
    {
		
    }
    else
    {
        //处理并设置日期
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.taskModel.end/1000];
        NSString *str2 = [NSDate weekdayStringFromDate:date];
        NSString *str3 = [NSString stringWithFormat:@" %@(%@)",[NSDate im_dateFormaterWithTimeInterval:self.taskModel.end],str2];
        [self.btnEndTime setTitle:str3 forState:UIControlStateNormal];
    }
    
    if (self.taskModel.projectName.length> 0)
    {
        [self.btnProjectName setTitle:[NSString stringWithFormat:@" %@", self.taskModel.projectName] forState:UIControlStateNormal];
    }
    
    if ([self.taskModel.stateType isEqualToString:@"FINISH"])
    {
        [self.btnDone setTitle:[NSString stringWithFormat:@" %@",LOCAL(IM_CHATCARD_DONE)] forState:UIControlStateNormal];
        [self.btnDone setImage:[UIImage imageNamed:@"chat_mission_done"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnDone setTitle:[NSString stringWithFormat:@" %@",LOCAL(IM_CHATCARD_UNDONE)] forState:UIControlStateNormal];
        [self.btnDone setImage:[UIImage imageNamed:@"chat_mission_undone"] forState:UIControlStateNormal];
    }
    
//    NSString *str1 = [NSString stringWithFormat:@" %ld/%ld",(long)self.taskModel.finishTask,(long)self.taskModel.allTask];
//    [self.btnChildTask setTitle:str1 forState:UIControlStateNormal];
    
    [self.btnLevel setTitle:[NSString stringWithFormat:@" %@",[self stateFromEnglish: self.taskModel.priority]] forState:UIControlStateNormal];

    if (self.taskModel.end <= 0)
    {
        self.btnEndTime.hidden = YES;
        if (self.taskModel.projectName.length> 0)
        {
            self.btnProjectName.hidden = NO;
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@125);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];

            [self.btnProjectName mas_remakeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.btnEndTime.mas_right).offset(10);
                make.left.equalTo(self.viewContent).offset(12);
                make.top.equalTo(self.viewContent.mas_top).offset(55);
                make.right.lessThanOrEqualTo(self.viewContent);
                make.height.equalTo(@20);
            }];
            
            [self.btnDone mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.btnProjectName);
                make.height.equalTo(self.btnProjectName);
                make.top.equalTo(self.btnProjectName.mas_bottom).offset(15);
            }];
            
//            [self.btnChildTask mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.viewContent).offset(110);
//                make.height.top.equalTo(self.btnDone);
//            }];
            
            [self.btnLevel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.btnDone.mas_right).offset(30);
                make.height.top.equalTo(self.btnDone);
                make.right.lessThanOrEqualTo(self.viewContent);
            }];
        }
        else
        {
            self.btnProjectName.hidden = YES;
            [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblName);
                make.height.equalTo(@90);
                make.right.equalTo(self.contentView).offset(-13);
                make.top.equalTo(self.lblName.mas_bottom).offset(2);
            }];
            
            [self.btnDone mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblTitle);
                make.height.equalTo(@20);
                make.top.equalTo(self.viewContent.mas_top).offset(55);
            }];
            
//            [self.btnChildTask mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.viewContent.mas_left).offset(110);
//                make.height.top.equalTo(self.btnDone);
//            }];
            
            [self.btnLevel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.btnDone.mas_right).offset(30);
                make.height.top.equalTo(self.btnDone);
                make.right.lessThanOrEqualTo(self.viewContent);
            }];
        }
    }
    else
    {
        [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblName);
            make.height.equalTo(@125);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.lblName.mas_bottom).offset(2);
        }];
        
        self.btnEndTime.hidden = NO;
        [self.btnEndTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblTitle);
            make.top.equalTo(self.viewContent.mas_top).offset(55);
            make.height.equalTo(@20);
        }];
        
        if (self.taskModel.projectName.length> 0)
        {
            self.btnProjectName.hidden  = NO;
            [self.btnProjectName mas_remakeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.btnEndTime.mas_right).offset(10);
                make.left.equalTo(self.viewContent).offset(120);
                make.top.height.equalTo(self.btnEndTime);
                make.right.lessThanOrEqualTo(self.viewContent);
            }];
        }
        else
        {
            self.btnProjectName.hidden  = YES;
        }
        
        [self.btnDone mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnEndTime);
            make.height.equalTo(self.btnEndTime);
            make.top.equalTo(self.btnEndTime.mas_bottom).offset(15);
        }];
        
//        [self.btnChildTask mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.viewContent.mas_left).offset(110);
//            make.height.top.equalTo(self.btnDone);
//        }];
        
        [self.btnLevel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnDone.mas_right).offset(30);
            make.height.top.equalTo(self.btnDone);
            make.right.lessThanOrEqualTo(self.viewContent);
        }];
    }

	[self setNeedExpandCellHeightWithTaskModel:self.taskModel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
//    //设置是否已读标志
//    if (self.messageAppModel.msgReadStatus == 0) {
//        [self.redpoint setHidden:NO];
//    }
//    else
//    {
//        [self.redpoint setHidden:YES];
//    }
}

//状态由英文转为中文
- (NSString *)stateFromEnglish:(NSString *)state
{
    self.btnLevel.hidden = NO;
    if ([state isEqualToString:@"MEDIUM"]) {
        self.imgLevelColor = [UIImage mtc_imageColor:MEDIUM_COLOR size:CGSizeMake(12, 12) cornerRadius:1.0f];
        [self.btnLevel setImage:self.imgLevelColor forState:UIControlStateNormal];
        return LOCAL(MISSION_MEDIUM);
    }
    else if ([state isEqualToString:@"HIGH"])
    {
        self.imgLevelColor = [UIImage mtc_imageColor:HIGH_COLOR size:CGSizeMake(12, 12) cornerRadius:1.0f];
        [self.btnLevel setImage:self.imgLevelColor forState:UIControlStateNormal];
        return LOCAL(MISSION_HIGH);
    }
    else if ([state isEqualToString:@"LOW"])
    {
        self.imgLevelColor = [UIImage mtc_imageColor:LOW_COLOR size:CGSizeMake(12, 12) cornerRadius:1.0f];
        [self.btnLevel setImage:self.imgLevelColor forState:UIControlStateNormal];
        return LOCAL(MISSION_LOW);
    }
    else
    {
        self.btnLevel.hidden = YES;
        return @"";
    }
}

- (void)setNeedExpandCellHeightWithTaskModel:(AppTaskModel *)model {
	if (model.end <=0 && model.projectName.length == 0) {
		needExtendHeight = NO;
	} else {
		needExtendHeight = YES;
	}
}

+ (CGFloat)height {
	if (needExtendHeight) {
		return 97.5 + 2 * 35 + 15;
	} else {
		return 97.5 + 35 + 15;
	}
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
    [self.viewContent addSubview:self.btnEndTime];
    [self.viewContent addSubview:self.btnProjectName];
    [self.viewContent addSubview:self.btnDone];
//    [self.viewContent addSubview:self.btnChildTask];
    [self.viewContent addSubview:self.btnLevel];
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.leftTri];
}

#pragma mark - InIt UI
- (UIButton *)btnEndTime
{
    if (!_btnEndTime)
    {
        _btnEndTime = [[UIButton alloc] init];
        [_btnEndTime setImage:[UIImage imageNamed:@"Mission_NewclockRed"] forState:UIControlStateNormal];
//        [_btnEndTime setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_btnEndTime setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_btnEndTime setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
        _btnEndTime.enabled = NO;
        _btnEndTime.titleLabel.font = [UIFont mtc_font_28];
    }
    return _btnEndTime;
}

- (UIButton *)btnProjectName
{
    if (!_btnProjectName)
    {
        _btnProjectName = [[UIButton alloc] init];
        [_btnProjectName setImage:[UIImage imageNamed:@"chat_folder"] forState:UIControlStateNormal];
        [_btnProjectName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnProjectName.enabled = NO;
        _btnProjectName.titleLabel.font = [UIFont mtc_font_28];
    }
    return _btnProjectName;
}

- (UIButton *)btnDone
{
    if (!_btnDone)
    {
        _btnDone = [[UIButton alloc] init];
        [_btnDone setImage:[UIImage imageNamed:@"chat_mission_undone"] forState:UIControlStateNormal];
        [_btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnDone.enabled = NO;
        _btnDone.titleLabel.font = [UIFont mtc_font_28];
    }
    return _btnDone;
}

//- (UIButton *)btnChildTask
//{
//    if (!_btnChildTask)
//    {
//        _btnChildTask = [[UIButton alloc] init];
//        [_btnChildTask setImage:[UIImage imageNamed:@"chat_list"] forState:UIControlStateNormal];
//        [_btnChildTask setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _btnChildTask.enabled = NO;
//        _btnChildTask.titleLabel.font = [UIFont mtc_font_28];
//    }
//    return _btnChildTask;
//}

- (UIButton *)btnLevel
{
    if (!_btnLevel)
    {
        _btnLevel = [[UIButton alloc] init];
        [_btnLevel setImage:self.imgLevelColor forState:UIControlStateNormal];
        [_btnLevel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnLevel.enabled = NO;
        _btnLevel.titleLabel.font = [UIFont mtc_font_28];
    }
    return _btnLevel;
}

- (UIImage *)imgLevelColor
{
    if (!_imgLevelColor)
    {
        _imgLevelColor = [UIImage mtc_imageColor:[UIColor whiteColor] size:CGSizeMake(10, 10) cornerRadius:1.0f];
    }
    return _imgLevelColor;
}

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor mtc_colorWithHex:0xfbf6ee] colorBorderColor:[UIColor mtc_colorWithHex:0xf6d4ae]];
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
        _viewContent.layer.borderColor = [UIColor mtc_colorWithHex:0xf6d4ae].CGColor;
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
        [_viewTitle setBackgroundColor:[UIColor mtc_colorWithHex:0xfbf6ee]];
        [_viewTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
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
//        [_lblTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblTitle;
}

- (UILabel *)lblKind
{
    if (!_lblKind)
    {
        _lblKind = [[UILabel alloc] init];
        [_lblKind setFont:[UIFont mtc_font_30]];
        [_lblKind setTextColor:[UIColor mtc_colorWithHex:0xffa020]];
        [_lblKind setTextAlignment:NSTextAlignmentRight];
        [_lblKind setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_lblKind setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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

- (UILabel *)lblLine3
{
    if (!_lblLine3)
    {
        _lblLine3 = [[UILabel alloc] init];
        _lblLine3.backgroundColor = [UIColor mtc_colorWithHex:0xf6d4ae];
    }
    return _lblLine3;
}
@end