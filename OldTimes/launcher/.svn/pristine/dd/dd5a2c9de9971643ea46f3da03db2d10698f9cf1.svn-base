//
//  NewSubMissionTableViewCell.m
//  launcher
//
//  Created by jasonwang on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewSubMissionTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NSDate+String.h"
#import "MyDefine.h"

#define FinishColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]

@interface NewSubMissionTableViewCell()

@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UIButton *selectView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) NewMissionDetailBaseModel *detailModel;

@end

@implementation NewSubMissionTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.myImageView];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.selectView];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.nameLb];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-3);
            make.left.equalTo(self.selectView.mas_right).offset(20);
            make.right.lessThanOrEqualTo(self.nameLb.mas_left).offset(-10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerY.equalTo(self.titelLb);
            make.height.equalTo(@1);
        }];
        
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.mas_centerY).offset(3);
            make.width.height.equalTo(@15);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myImageView.mas_right).offset(10);
            make.centerY.equalTo(self.myImageView);
            make.right.lessThanOrEqualTo(self.nameLb.mas_left).offset(-10);
        }];

    }
    return self;
}

- (void)setSubDataWithModel:(NewMissionDetailBaseModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.detailModel = model;
    //标题
    [self.titelLb setText:model.title];
    [self.nameLb setText:model.userTrueName];
    [self.timeLb setText:[self getTimeWithStartLong:model.startTime endLong:model.endTime]];
    if (model.type == whiteBoardStyleWaiting) {
        [self changState:NO];
    } else if (model.type == whiteBoardStyleFinish) {
        [self changState:YES];
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.centerY.equalTo(self.titelLb);
        make.height.equalTo(@1);
    }];
    
    self.myIndexpath = indexPath;
}

- (void)selectClick{
    if ([self.subdelegate respondsToSelector:@selector(NewSubMissionTableViewCellDelegateCallBack_statusChange:)]) {
        [self.subdelegate NewSubMissionTableViewCellDelegateCallBack_statusChange:self.myIndexpath];
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

//转换时间间隔字段
- (NSString *)getTimeWithStartLong:(long long)StartLong endLong:(long long)endLong
{
    NSString *startString = @"";
    NSString *endString = @"";
    if (StartLong) {
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:StartLong/1000];
        startString = [startDate mtc_getStringWithDateWholeDay:self.detailModel.isStartTimeAllDay];
        
    } else {
        startString = LOCAL(NEWMISSION_NO_START_TIME);
    }
    
    if (endLong) {
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endLong/1000];
        endString = [endDate mtc_getStringWithDateWholeDay:self.detailModel.isEndTimeAllDay];
    } else {
        endString = LOCAL(NEWMISSION_UNSET);
    }
    
    return [NSString stringWithFormat:@"%@~%@",startString,endString];
}

- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        [_timeLb setFont:[UIFont systemFontOfSize:14]];
        [_timeLb setTextColor:FinishColor];
    }
    return _timeLb;
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
        [_titelLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _titelLb;
}

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        [_myImageView setImage:[UIImage imageNamed:@"clock_gray"]];
    }
    return _myImageView;
}

- (UILabel *)nameLb
{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        [_nameLb setFont:[UIFont systemFontOfSize:14]];
        [_nameLb setTextColor:FinishColor];
    }
    return _nameLb;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
