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

#define FinishColor [UIColor colorWithHexString:@"3333333"]

@interface NewMissionDetailTitelTableViewCell()

@property (nonatomic, strong) UILabel *levelLb;
@property (nonatomic, strong) UIView *point;
@property (nonatomic, strong) UIButton *selectView;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation NewMissionDetailTitelTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addSubview:self.levelLb];
        [self addSubview:self.point];
        [self addSubview:self.selectView];
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
            make.left.equalTo(self.selectView.mas_right).offset(15);
            make.right.lessThanOrEqualTo(self.point.mas_left).offset(-10);
        }];
    }
    return self;
}


#pragma mark - Private Method

- (void)setDataWithModel:(MissionDetailModel *)model
{
    //标题
    [self.titelLb setText:model.taskTitle];
    [self setPriority:model.taskPriority];
    
    self.titelLb.textColor = [UIColor blackColor];
    
    // 处理✅图标问题 ＋ title颜色
    if (model.taskStatus == TaskStatusTypeExpired){ //过期
        [self.selectView setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        //self.selectView.selected = NO;
    }else if(model.taskStatus == TaskStatusTypeDone) //完成
    {
        [self.selectView setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateNormal];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        //self.selectView.selected = YES;
    }
    else if(model.taskStatus == TaskStatusTypeDisabled) //拒绝
    {
        [self.selectView setImage:[UIImage imageNamed:@"Mission_RefuseAlrelday"] forState:UIControlStateNormal];
       // self.selectView.selected = YES;
        if (self.titelLb.text) {
            [self.titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc] initWithString:self.titelLb.text attributes:attribtDic];
            self.titelLb.attributedText = AttributeStr;
        }

    }else if(model.taskStatus == TaskStatusTypeActivated && !model.isSendFromMe) //接受
    {
        [self.selectView setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"3333333"]];
    }
}

- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor colorWithHex:0xcccccc];
            priorityString = @"低";
            break;
        case MissionTaskPriorityMid:
            color = [UIColor colorWithHex:0xffac4f];
            priorityString = @"中";
            break;
        case MissionTaskPriorityHigh:
            color = [UIColor colorWithHex:0xff3366];
            priorityString = @"高";
            break;
        case MissionTaskPriorityNone:
            color = [UIColor clearColor];
            priorityString = @"";
            break;
    }
    self.levelLb.text = priorityString;
    self.point.backgroundColor = color;
    self.levelLb.textColor = color;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Init 

- (UILabel *)levelLb
{
    if (!_levelLb) {
        _levelLb = [[UILabel alloc] init];
        [_levelLb setText:@"很高"];
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


- (UIButton *)selectView
{
    if (!_selectView) {
        _selectView = [[UIButton alloc] init];
        [_selectView setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateSelected];
        [_selectView setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
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
