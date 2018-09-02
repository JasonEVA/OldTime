//
//  ChatEventMissionTableViewCell.m
//  launcher
//
//  Created by jasonwang on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatEventMissionTableViewCell.h"
#import "Images.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AppTaskModel.h"
#import "MyDefine.h"
#import "Category.h"

#define LOW_COLOR [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]      //优先级低的颜色
#define HIGH_COLOR [UIColor colorWithRed:246/255.0 green:20/255.0 blue:84/255.0 alpha:1]      //优先级高的颜色
#define MEDIUM_COLOR [UIColor colorWithRed:247/255.0 green:167/255.0 blue:89/255.0 alpha:1]   //优先级中的颜色
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
#define FONT_2 14
#define OFFSET 10
@interface ChatEventMissionTableViewCell()

@property (nonatomic, strong) UIButton *btnEndTime;       //截止时间
@property (nonatomic, strong) UIButton *btnProjectName;   //项目名称
@property (nonatomic, strong) UIButton *btnDone;          //完成状态
@property (nonatomic, strong) UIButton *btnChildTask;     //子任务数量
@property (nonatomic, strong) UIButton *btnLevel;         //任务等级
@property (nonatomic, strong) UIImage *imgLevelColor;     //颜色

@property (nonatomic, strong) AppTaskModel *taskModel;
@property (nonatomic, strong) MessageAppModel *messageAppModel;

@end

@implementation ChatEventMissionTableViewCell

+ (CGFloat)height { return 145;}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToShowDetail)];
        [self.bgView setUserInteractionEnabled:YES];
        [self.bgView addGestureRecognizer:tapGesture];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)clickToShowDetail {
	self.bgView.userInteractionEnabled = NO;
	[self performSelector:@selector(setUserInteractionEnabled) withObject:nil afterDelay:1.0];
    !self.showDetail ?: self.showDetail();
}

- (void)setUserInteractionEnabled {
	self.bgView.userInteractionEnabled = YES;
}

#pragma mark - setData

- (void)setCellData:(MessageBaseModel *)model
{
    //取出下层MODEL
    self.messageAppModel = model.appModel;
    self.taskModel = [AppTaskModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
    //设置标题
    [self.eventContentLabel setText:self.taskModel.title];
    if ([self.eventContentLabel.text length] == 0) {
        [self.eventContentLabel setText:self.messageAppModel.msgTitle];
    }
    //处理并设置日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.taskModel.end/1000];
    NSString *str2 = [NSDate weekdayStringFromDate:date];
    NSString *str3 = [NSString stringWithFormat:@"%@(%@)",[NSDate im_dateFormaterWithTimeInterval:self.taskModel.end],str2];
    [self.btnEndTime setTitle:str3 forState:UIControlStateNormal];
    
    if (self.taskModel.end == 0) {
//        [self.date setText:LOCAL(NEWMISSION_UNSET)];
        [self.btnEndTime setTitle:LOCAL(NEWMISSION_UNSET) forState:UIControlStateNormal];
    }
    
    //设置优先级
//    [self.priority setText:[self stateFromEnglish: self.taskModel.priority]];
    //设置项目名称
    
    [self.btnProjectName setTitle:[NSString stringWithFormat:@" %@", self.taskModel.projectName] forState:UIControlStateNormal];
    self.btnProjectName.hidden = [self.taskModel.projectName isEqualToString:@""];
    //设置任务状态
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
    //设置子任务完成进度
    NSString *str1 = [NSString stringWithFormat:@" %ld/%ld",(long)self.taskModel.finishTask,(long)self.taskModel.allTask];
    [self.btnChildTask setTitle:str1 forState:UIControlStateNormal];
    
    [self.btnLevel setTitle:[NSString stringWithFormat:@" %@",[self stateFromEnglish: self.taskModel.priority]] forState:UIControlStateNormal];
    //设置发送人及发送时间
    //[self.sendManLabel setText:model.getNickName];
    [self setEventSendManLabel:self.messageAppModel.msgFrom];
    [self.sendTimeLabel setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES]];
    
    
    [self.eventTypeLabel setText:LOCAL(Application_Mission)];
    [self  setLabelKindNale:LOCAL(Application_Mission)];
    
    //设置是否已读标志
    if (self.messageAppModel.msgReadStatus == 0) {
        [self.redpoint setHidden:NO];
    }
    else
    {
        [self.redpoint setHidden:YES];
    }
    

}
//状态由英文转为中文
- (NSString *)stateFromEnglish:(NSString *)state
{
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
    else
    {
        self.imgLevelColor = [UIImage mtc_imageColor:LOW_COLOR size:CGSizeMake(12, 12) cornerRadius:1.0f];
        [self.btnLevel setImage:self.imgLevelColor forState:UIControlStateNormal];
        return LOCAL(MISSION_LOW);
    }

}

#pragma mark - updateConstraints
- (void)updateConstraints
{
    [self.btnEndTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.line1).offset(OFFSET);
        make.height.equalTo(@20);
    }];
    [self.btnProjectName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnEndTime.mas_right).offset(10);
//        make.left.equalTo(self.bgView).offset(120);
        make.top.height.equalTo(self.btnEndTime);
        make.right.lessThanOrEqualTo(self.bgView);
    }];
    
    [self.btnDone mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnEndTime);
        make.height.equalTo(self.btnEndTime);
        make.top.equalTo(self.btnEndTime.mas_bottom).offset(15);
    }];
    
    [self.btnChildTask mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(110);
        make.height.top.equalTo(self.btnDone);
    }];
    
    [self.btnLevel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(185);
        make.height.top.equalTo(self.btnDone);
        make.right.lessThanOrEqualTo(self.bgView);
    }];

    [super updateConstraints];
}


#pragma mark - initComponent

- (void)initComponent
{
    [self.bgView addSubview:self.btnEndTime];
    [self.bgView addSubview:self.btnProjectName];
    [self.bgView addSubview:self.btnDone];
    [self.bgView addSubview:self.btnChildTask];
    [self.bgView addSubview:self.btnLevel];
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

- (UIButton *)btnChildTask
{
    if (!_btnChildTask)
    {
        _btnChildTask = [[UIButton alloc] init];
        [_btnChildTask setImage:[UIImage imageNamed:@"chat_list"] forState:UIControlStateNormal];
        [_btnChildTask setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnChildTask.enabled = NO;
        _btnChildTask.titleLabel.font = [UIFont mtc_font_28];
    }
    return _btnChildTask;
}

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

- (AppTaskModel *)taskModel
{
    if (!_taskModel) {
        _taskModel = [[AppTaskModel alloc] init];
    }
    return _taskModel;
}

- (MessageAppModel *)messageAppModel
{
    if (!_messageAppModel) {
        _messageAppModel = [[MessageAppModel alloc] init];
        
    }
    return _messageAppModel;
}

@end
