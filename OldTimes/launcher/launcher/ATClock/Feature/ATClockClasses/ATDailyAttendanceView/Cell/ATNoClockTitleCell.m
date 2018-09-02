
//
//  ATNoClockTitleCell.m
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATNoClockTitleCell.h"
#import "ATNoClockTitleCellModel.h"

#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"

@interface ATNoClockTitleCell ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation ATNoClockTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        
        [self initConstraints];
    }
    
    return self;
}

- (void)initConstraints {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.circleView.mas_top);
        make.width.mas_equalTo(0.5);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.left.mas_equalTo(self.contentView).offset(25.0 / 2);
        make.width.height.mas_equalTo(10);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom);
        make.centerX.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLab);
        make.left.mas_equalTo(self.circleView.mas_right).offset(25);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.titleLab.mas_right).offset(25);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(- 30);
    }];
}

- (void)updateCellWithData:(id)aCellData hideHeaderLine:(BOOL)isHeaderHidden hideFooterLine:(BOOL)isFooterHidden
{
    if ([aCellData isKindOfClass:[ATNoClockTitleCellModel class]]) {
        ATNoClockTitleCellModel *model = (ATNoClockTitleCellModel *)aCellData;
        self.titleLab.text = model.titleStr;
        self.timeLab.text = model.dateStr;
        
        if (model.isHideTopLine) {
            self.topLineView.hidden = YES;
        } else {
            self.topLineView.hidden = NO;
        }
    }
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

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel at_createLabWithText:@"" fontSize:15.0 titleColor:[UIColor at_blackColor]];
        [_titleLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _titleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel at_createLabWithText:@"" fontSize:14.0 titleColor:[UIColor at_darkGrayColor]];
    }
    
    return _timeLab;
}

@end
