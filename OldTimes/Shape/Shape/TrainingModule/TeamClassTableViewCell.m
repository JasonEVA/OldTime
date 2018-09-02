//
//  TeamClassTableViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TeamClassTableViewCell.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "TeamClassModel.h"

@interface TeamClassTableViewCell()

@property (nonatomic, strong)  UILabel  *timeRange; // <##>
@property (nonatomic, strong)  UILabel  *className; // <##>
@property (nonatomic, strong)  UILabel  *classState; // <##>
@property (nonatomic, strong)  UIButton  *btnAppointment; // <##>
@property (nonatomic, strong)  NSMutableArray<UIView *>  *arraySpaceViews; // <##>
@property (nonatomic, strong)  TeamClassModel  *currentModel; // <##>
@end
@implementation TeamClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [self addSubview:self.timeRange];
        [self addSubview:self.className];
        [self addSubview:self.classState];
        [self addSubview:self.btnAppointment];
        
        // 空白填充view
        for (NSInteger i = 0; i < 3; i ++) {
            UIView *view = [UIView new];
            [self addSubview:view];
            [self.arraySpaceViews addObject:view];
        }
        [self updateConstraints];
    }
    return self;
}
- (void)setClassData:(TeamClassModel *)model {
    self.currentModel = model;
    [self setCellModelData];
}

- (void)updateConstraints {
    [self.timeRange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftSpacing);
        make.centerY.equalTo(self);
    }];
    
    [self.arraySpaceViews[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.arraySpaceViews[1].mas_width);
        make.height.equalTo(@1);
        make.left.equalTo(self.timeRange.mas_right);
    }];
    [self.className mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arraySpaceViews[0].mas_right);
        make.centerY.equalTo(self);
    }];
    [self.arraySpaceViews[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.arraySpaceViews[2].mas_width);
        make.height.equalTo(@1);
        make.left.equalTo(self.className.mas_right);
    }];

    [self.classState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arraySpaceViews[1].mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.arraySpaceViews[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(self.classState.mas_right);
        make.right.equalTo(self.btnAppointment.mas_left);
    }];

    [self.btnAppointment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-rightSpacing);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];

    [super updateConstraints];
}

- (void)btnClicked {
    self.currentModel.classState = state_booked;
    [self setCellModelData];
}

- (void)btnStateWithClassState:(TeamClassState)state {
    if (state == state_available) {
        [self.btnAppointment setEnabled:YES];
    } else {
        [self.btnAppointment setEnabled:NO];
    }
}

- (void)setCellModelData {
    [self.timeRange setText:[NSString stringWithFormat:@"%@~%@",self.currentModel.startTime,self.currentModel.endTime]];
    [self.className setText:self.currentModel.className];
    [self btnStateWithClassState:self.currentModel.classState];
    [self.classState setText:self.currentModel.classStateName];

}
#pragma mark - Init
- (UILabel *)timeRange {
    if (!_timeRange) {
        _timeRange = [[UILabel alloc] init];
        [_timeRange setText:@"12:10~13:10"];
        [_timeRange setTextColor:[UIColor whiteColor]];
        [_timeRange setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _timeRange;
}
- (UILabel *)className {
    if (!_className) {
        _className = [[UILabel alloc] init];
        [_className setText:@"人鱼马甲"];
        [_className setTextColor:[UIColor whiteColor]];
        [_className setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _className;
}
- (UILabel *)classState {
    if (!_classState) {
        _classState = [[UILabel alloc] init];
        [_classState setText:@"可预约"];
        [_classState setTextColor:[UIColor whiteColor]];
        [_classState setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _classState;
}

- (UIButton *)btnAppointment {
    if (!_btnAppointment) {
        _btnAppointment = [[UIButton alloc] init];
        [_btnAppointment setTitle:@"预约" forState:UIControlStateNormal];
        [_btnAppointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAppointment.titleLabel setFont:[UIFont systemFontOfSize:fontSize_15]];
        [_btnAppointment setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnAppointment addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAppointment;
}

- (NSMutableArray *)arraySpaceViews {
    if (!_arraySpaceViews) {
        _arraySpaceViews = [NSMutableArray arrayWithCapacity:3];
    }
    return _arraySpaceViews;
}
@end
