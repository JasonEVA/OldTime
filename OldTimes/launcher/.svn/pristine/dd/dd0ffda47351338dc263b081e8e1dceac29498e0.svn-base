//
//  ATStaticOutSideCell.m
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATStaticOutSideCell.h"
#import "ATStaticOutsideModel.h"

@interface ATStaticOutSideCell()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *localImageView;
@property (nonatomic, strong) UILabel *locaLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIView *realBottomLineView;

@property (nonatomic, strong) UIImageView *remarkImageView;
@property (nonatomic, strong) UILabel *remarkLabel;

@end

@implementation ATStaticOutSideCell

- (UIView *)realBottomLineView {
    
    if (!_realBottomLineView) {
        _realBottomLineView = [[UIView alloc] init];
        _realBottomLineView.backgroundColor = [UIColor at_lightGrayColor];
    }
    return _realBottomLineView;
}


- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return _bottomLineView;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(5, 5) radius:5 startAngle:0 endAngle:2 * M_PI clockwise:1];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path1.CGPath;
        shapeLayer.fillColor = [UIColor at_blueColor].CGColor;
        [_circleView.layer addSublayer:shapeLayer];
    }
    
    return _circleView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor at_blackColor];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.numberOfLines = 0;
    }
    return _dateLabel;
}

- (UILabel *)locaLabel {
    
    if (!_locaLabel) {
        _locaLabel = [[UILabel alloc] init];
        _locaLabel.textColor = [UIColor at_blackColor];
        _locaLabel.numberOfLines = 0;
        _locaLabel.font = [UIFont systemFontOfSize:14];
    }
    return _locaLabel;
}


- (UIImageView *)localImageView {
    
    if (!_localImageView) {
        _localImageView = [[UIImageView alloc] init];
        _localImageView.image = [UIImage imageNamed:@"img_checkAttendance_address"];
    }
    return _localImageView;
}


- (UIImageView *)remarkImageView {

    if (!_remarkImageView) {
        _remarkImageView = [[UIImageView alloc] init];
        _remarkImageView.image = [UIImage imageNamed:@"img_checkAttendance_reason"];
    }
    return _remarkImageView;
}

- (UILabel *)remarkLabel {
    
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [UIColor at_blackColor];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.font = [UIFont systemFontOfSize:14];
    }
    return _remarkLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.locaLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.localImageView];
        [self.contentView addSubview:self.realBottomLineView];
        [self.contentView addSubview:self.remarkLabel];
        [self.contentView addSubview:self.remarkImageView];
        
        [self initConstraints];
    
    }
    
    return self;
}


- (void)initConstraints {
    
    [self.remarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locaLabel.mas_bottom).offset(15);
        make.width.equalTo(@18);
        make.height.equalTo(@20);
        make.left.equalTo(self.localImageView);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.width.equalTo(@175);
        make.left.equalTo(self.remarkImageView.mas_right).offset(8);
        make.top.equalTo(self.remarkImageView);
        
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(35);
        make.width.equalTo(@45);
        make.height.equalTo(@15);
    }];
    
    [self.localImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
        make.width.equalTo(@18);
        make.height.equalTo(@20);
    }];
    
    [self.locaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.width.equalTo(@175);
        make.left.equalTo(self.localImageView.mas_right).offset(8);
        make.top.equalTo(self.localImageView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.circleView.mas_top);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateLabel);
        make.left.mas_equalTo(self.contentView).offset(25.0 / 2);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom);
        make.centerX.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
    }];
    
    
    [self.realBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(40);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setStaticOutsideModel:(ATStaticOutsideModel *)staticOutsideModel {
    _staticOutsideModel = staticOutsideModel;
    
    NSString *timeStr = [NSString stringWithFormat:@"%f", staticOutsideModel.Time];
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *workTime=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    NSString *timeString = [fmt stringFromDate:workTime];

    self.dateLabel.text = timeString;
    self.locaLabel.text = staticOutsideModel.Location;
    self.remarkLabel.text = staticOutsideModel.Remark;
}


@end
