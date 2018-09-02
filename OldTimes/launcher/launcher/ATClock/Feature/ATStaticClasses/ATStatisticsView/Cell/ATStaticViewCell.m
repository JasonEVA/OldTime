//
//  ATStaticViewCell.m
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStaticViewCell.h"
#import <Masonry.h>
#import "DQAlertView.h"
#import "ATStaticModel.h"
#import "ATStaticOutSideDetailView.h"
#import "ATStaticOutsideModel.h"

#import "UIColor+ATHex.h"

typedef NS_ENUM(NSUInteger, workStatus) {
    workStatusNormal,  // 正常
    workStatusWorkLate, // 迟到
    workStatusLeaveEarily,  // 早退
    workStatusNoLocation, // 地点不明
    workStatusNoRecord    // 未打卡
};



@interface ATStaticViewCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *workLabel;
@property (nonatomic, strong) UILabel *outWorkLabel;

@property (nonatomic, strong) UIButton *workRemarkButton;
@property (nonatomic, strong) UIButton *outWorkRemarkButton;

@property (nonatomic, copy) NSString *workRemarkStr;
@property (nonatomic, copy) NSString *outWorkRemarkStr;

@property (nonatomic, strong) UILabel *outsideWorkLabel;
@property (nonatomic, strong) UIButton *outsideWorkButton;


@property (nonatomic, assign) double dateParam;


@end

@implementation ATStaticViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.dateLabel];
        
        self.workLabel = [[UILabel alloc] init];
        self.workLabel.font = [UIFont systemFontOfSize:14];
        self.workLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.workLabel];
        
        self.outWorkLabel = [[UILabel alloc] init];
        self.outWorkLabel.font = [UIFont systemFontOfSize:14];
        self.outWorkLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.outWorkLabel];
        
        
        self.workRemarkButton = [[UIButton alloc] init];
        [self.workRemarkButton setImage:[UIImage imageNamed:@"img_statisticsView_exclamation"] forState:UIControlStateNormal];
        [self.workRemarkButton addTarget:self action:@selector(workRemarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.workRemarkButton];
        
        self.outWorkRemarkButton = [[UIButton alloc] init];
        [self.outWorkRemarkButton setImage:[UIImage imageNamed:@"img_statisticsView_exclamation"] forState:UIControlStateNormal];
        [self.outWorkRemarkButton addTarget:self action:@selector(outWorkRemarkButtonClick) forControlEvents:UIControlEventTouchUpInside];

        [self.bgView addSubview:self.outWorkRemarkButton];
        
        // 外出
        self.outsideWorkLabel = [[UILabel alloc] init];
        self.outsideWorkLabel.text = @"外出";
        self.outsideWorkLabel.font = [UIFont systemFontOfSize:14];
        self.outsideWorkLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.outsideWorkLabel];
        
        
        self.outsideWorkButton = [[UIButton alloc] init];
        [self.outsideWorkButton setImage:[UIImage imageNamed:@"img_statisticsView_exclamation"] forState:UIControlStateNormal];
        [self.outsideWorkButton addTarget:self action:@selector(outsideWorkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:self.outsideWorkButton];
        
        [self initConstraints];
    }
    
    return self;
}


- (void)initConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).offset(-13);
        make.height.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@19);
        make.left.equalTo(self.bgView).offset(40);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.outsideWorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-100);
    }];
    
    [self.outsideWorkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.outsideWorkLabel.mas_right);
    }];
    
    
    [self.workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.outWorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.right.equalTo(self.bgView).offset(-35);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.workRemarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.workLabel.mas_right);
    }];
    
    [self.outWorkRemarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.outWorkLabel.mas_right);
    }];
    
}

- (void)updateCellWithData:(id)aCellData hideHeaderLine:(BOOL)isHeaderHidden hideFooterLine:(BOOL)isFooterHidden
{
    if ([aCellData isKindOfClass:[ATStaticModel class]]) {
        ATStaticModel *model = (ATStaticModel *)aCellData;
        
        self.dateLabel.text = [self transportTimeStamp:model.Date style:@"dd"];
        
        
        if (model.IsOut) { // 外出
            
            self.dateParam = model.Date;
            self.workLabel.hidden = YES;
            self.outWorkLabel.hidden = YES;
            
            self.workRemarkButton.hidden = YES;
            self.outWorkRemarkButton.hidden = YES;
            
            self.outsideWorkLabel.hidden = NO;
            self.outsideWorkButton.hidden = NO;
            
        }else {  // 正常上班
            
            self.outsideWorkLabel.hidden = YES;
            self.outsideWorkButton.hidden = YES;

            
            self.workLabel.hidden = NO;
            self.outWorkLabel.hidden = NO;
            
            self.workRemarkStr = model.OnWorkRemark;
            self.outWorkRemarkStr = model.OffWorkRemark;
            
            if (model.OnWorkStatus == workStatusWorkLate) { //迟到
                self.workRemarkButton.hidden = NO;
                self.workLabel.textColor = [UIColor at_redColor];
            }else if(model.OnWorkStatus == workStatusNoRecord){ // 未打卡
                self.workRemarkButton.hidden = NO;
                self.workLabel.textColor = [UIColor at_redColor];
            }else if(model.OnWorkStatus == workStatusNoLocation){ // 地点不明
                self.workRemarkButton.hidden = NO;
                self.workLabel.textColor = [UIColor at_redColor];
            }else if(model.OnWorkIsLoc == 0){ // 地点不明
                self.workRemarkButton.hidden = NO;
                self.workLabel.textColor = [UIColor at_redColor];
            }else{
                self.workRemarkButton.hidden = YES;
                self.workLabel.textColor = [UIColor at_blackColor];
            }
            
            if (model.OffWorkStatus == workStatusLeaveEarily) { //早退
                self.outWorkRemarkButton.hidden = NO;
                self.outWorkLabel.textColor = [UIColor at_redColor];
            }else if (model.OffWorkStatus == workStatusNoRecord){ //未打卡
                self.outWorkRemarkButton.hidden = NO;
                self.outWorkLabel.textColor = [UIColor at_redColor];
            }else if (model.OffWorkStatus == workStatusNoLocation) { //地点不明
                self.outWorkRemarkButton.hidden = NO;
                self.outWorkLabel.textColor = [UIColor at_redColor];
            }else if (model.OffWorkIsLoc == 0) { //地点不明
                self.outWorkRemarkButton.hidden = NO;
                self.outWorkLabel.textColor = [UIColor at_redColor];
            }else {
                self.outWorkRemarkButton.hidden = YES;
                self.outWorkLabel.textColor = [UIColor at_blackColor];
            }
            
            if (model.OnWorkTime == 0) {
                self.workLabel.text = @" - ";
                self.workRemarkButton.hidden = YES;
            }else {
                self.workLabel.text = [self transportTimeStamp:model.OnWorkTime style:@"HH:mm"];
            }
            
            if (model.OffWorkTime == 0) {
                self.outWorkLabel.text = @" - ";
                self.outWorkRemarkButton.hidden = YES;
            }else {
                self.outWorkLabel.text = [self transportTimeStamp:model.OffWorkTime style:@"HH:mm"];
            }
            
            // 上班是否异常
            if (model.OnWorkIsExcep == 0) { // 正常
                self.workRemarkButton.hidden = YES;
                
                if ([self.workLabel.text isEqualToString:@" - "]) { // 正常未打卡显示黑色
                    self.workLabel.textColor = [UIColor at_blackColor];
                }
                
            }else {
                self.workRemarkButton.hidden = NO;
                
                if ([self.workLabel.text isEqualToString:@" - "]) { // 异常未打卡显示红色
                    self.workLabel.textColor = [UIColor at_redColor];
                    self.workRemarkButton.hidden = YES;

                }
            }
            // 下班是否异常
            if (model.OffWorkIsExcep == 0) { // 正常
                self.outWorkRemarkButton.hidden = YES;
                
                if ([self.outWorkLabel.text isEqualToString:@" - "]) { // 正常未打卡显示黑色
                    self.outWorkLabel.textColor = [UIColor at_blackColor];
                }

            }else {
                self.outWorkRemarkButton.hidden = NO;
                // 异常未打卡
                self.outWorkLabel.textColor = [UIColor at_redColor];
                
                if ([self.outWorkLabel.text isEqualToString:@" - "]) { // 异常未打卡显示红色
                    self.outWorkLabel.textColor = [UIColor at_redColor];
                    self.outWorkRemarkButton.hidden = YES;

                }
            }


            if (![self.workLabel.text isEqualToString:@" - "]) {
                
                UITapGestureRecognizer *workTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workRemarkButtonClick)];
                self.workLabel.userInteractionEnabled = YES;
                [self.workLabel addGestureRecognizer:workTap];
            }
            
            
            
            if (![self.outWorkLabel.text isEqualToString:@" - "]) {
                
                UITapGestureRecognizer *outWorkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(outWorkRemarkButtonClick)];
                self.outWorkLabel.userInteractionEnabled = YES;
                [self.outWorkLabel addGestureRecognizer:outWorkTap];
                
            }
            
            UITapGestureRecognizer *outsideWorkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(outsideWorkButtonClick)];
            self.outsideWorkLabel.userInteractionEnabled = YES;
            [self.outsideWorkLabel addGestureRecognizer:outsideWorkTap];

            
            
        }
    }
}


- (NSString *)transportTimeStamp:(double)timeStamp style:(NSString *)style {
    
    NSDate *workTime=[NSDate dateWithTimeIntervalSince1970:timeStamp/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = style;
    
    return [fmt stringFromDate:workTime];
}


- (void)workRemarkButtonClick {
    
    if (self.workRemarkStr.length) {
        [self popAlertViewController:self.workRemarkStr];
    }else {
        [self popAlertViewController:@"原因不详"];
    }
}

- (void)outWorkRemarkButtonClick {
    
    if (self.outWorkRemarkStr.length) {
        [self popAlertViewController:self.outWorkRemarkStr];
    }else {
        [self popAlertViewController:@"原因不详"];
    }
}

- (void)popAlertViewController:(NSString *)message {
    
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:@"打卡时间异常备注" message:message cancelButtonTitle:@"关闭" otherButtonTitle:nil];
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:20];
    alertView.titleLabel.textColor = [UIColor at_redColor];
    
    alertView.messageLabel.font = [UIFont systemFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor at_blackColor];
    
    [alertView.cancelButton setTitleColor:[UIColor at_blackColor] forState:UIControlStateNormal];
    alertView.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    alertView.titleBottomPadding = 20;
    
    [alertView show];
}


- (void)outsideWorkButtonClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDateForRequest:staticViewCell:)]) {
        [self.delegate sendDateForRequest:self.dateParam staticViewCell:self];
    }
}

@end