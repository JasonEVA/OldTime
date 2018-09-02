//
//  NewMissionDetailTitelTableViewCell.m
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionDetailTitelTableViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "WhiteBoradStatusType.h"
#import "MyDefine.h"

#define FinishColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]

@interface NewMissionDetailTitelTableViewCell()

@property (nonatomic, strong) UILabel *levelLb;
@property (nonatomic, strong) UIView *point;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectView;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation NewMissionDetailTitelTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.levelLb];
        [self addSubview:self.point];
        [self addSubview:self.selectView];
        [self addSubview:self.lineView];
        [self addSubview:self.titelLb];
        
        [self.levelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
        
        [self.point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.levelLb.mas_left).offset(-10);
            make.width.height.equalTo(@8);
        }];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.selectView.mas_right).offset(20);
            make.right.lessThanOrEqualTo(self.point.mas_left).offset(-10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerY.equalTo(self.titelLb);
            make.height.equalTo(@1);
        }];

    }
    return self;
}


#pragma mark - Private Method
- (void)setDataWithModel:(NewMissionDetailModel *)model
{
    //标题
    [self.titelLb setText:model.title];
    [self setPriority:model.priority];
    if (model.type == whiteBoardStyleWaiting) {
        [self changState:NO];
    } else if (model.type == whiteBoardStyleFinish) {
        [self changState:YES];
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.centerY.equalTo(self.titelLb);
        make.height.equalTo(@1);
    }];

    
}
- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor mtc_colorWithHex:0x666666];
            priorityString = LOCAL(MISSION_LOW);
            break;
        case MissionTaskPriorityMid:
            color = [UIColor mtc_colorWithHex:0xffac4f];
            priorityString = LOCAL(MISSION_MEDIUM);
            break;
        case MissionTaskPriorityHeigh:
            color = [UIColor mtc_colorWithHex:0xff3366];
            priorityString = LOCAL(MISSION_HIGH);
            break;
        case MissionTaskPriorityWithout:
            color = [UIColor clearColor];
            priorityString = @"";
            break;
    }
    self.levelLb.text = priorityString;
    self.point.backgroundColor = color;
    self.levelLb.textColor = color;
}



- (void)selectClick{
    if ([self.delegate respondsToSelector:@selector(NewMissionDetailTitelTableViewCellDelegateCallBack_statusChange)]) {
        [self.delegate NewMissionDetailTitelTableViewCellDelegateCallBack_statusChange];
//        self.selectView.selected ^=1;
//        [self changState:self.selectView.selected];
    }
}

- (void)changState:(BOOL)isSelect
{
    [self.lineView setHidden:!isSelect];
    [self.selectView setSelected:isSelect];
    if (isSelect) {
        [self.titelLb setTextColor:FinishColor];
    } else {
        [self.titelLb setTextColor:[UIColor blackColor]];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)levelLb
{
    if (!_levelLb) {
        _levelLb = [[UILabel alloc] init];
        [_levelLb setText:LOCAL(MISSION_HIGH)];
        [_levelLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _levelLb;
}

- (UIView *)point
{
    if (!_point) {
        _point = [[UIView alloc] init];
        [_point setBackgroundColor:[UIColor themeRed]];
        [_point.layer setCornerRadius:4];
    }
    return _point;
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

- (UIButton *)selectView
{
    if (!_selectView) {
        _selectView = [[UIButton alloc] init];
        [_selectView setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
        [_selectView setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateSelected];
        [_selectView addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectView;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [[UILabel alloc] init];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _titelLb;
}
@end
