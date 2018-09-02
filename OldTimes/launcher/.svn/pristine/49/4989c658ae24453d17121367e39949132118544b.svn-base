//
//  ATCheckAttendanceViewCell.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATCheckAttendanceViewCell.h"
#import "ATPunchCardModel.h"

#import "NSString+ATConverter.h"
#import "NSDate+ATCompare.h"
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"

@interface ATCheckAttendanceViewCell ()
{
    ATPunchCardModel *_cardModel;
}
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UIImageView *addressIV;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UIView *reasonView;
@property (nonatomic, strong) UIImageView *reasonIV;
@property (nonatomic, strong) UILabel *reasonLab;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation ATCheckAttendanceViewCell

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

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [UILabel at_createLabWithText:@"" fontSize:15.0 titleColor:[UIColor at_redColor]];
    }
    
    return _statusLab;
}

- (UIImageView *)addressIV {
    if (!_addressIV) {
        _addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_checkAttendance_address"]];
    }
    
    return _addressIV;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [UILabel at_createLabWithText:@"" fontSize:13.0 titleColor:[UIColor at_darkGrayColor]];
        _addressLab.numberOfLines = 0;
    }
    
    return _addressLab;
}

- (UIView *)reasonView {
    if (!_reasonView) {
        _reasonView = [[UIView alloc] init];
    }
    
    return _reasonView;
}

- (UIImageView *)reasonIV {
    if (!_reasonIV) {
        _reasonIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_checkAttendance_reason"]];
    }
    
    return _reasonIV;
}

- (UILabel *)reasonLab {
    if (!_reasonLab) {
        _reasonLab = [UILabel at_createLabWithText:@"" fontSize:13.0 titleColor:[UIColor at_darkGrayColor]];
        _reasonLab.numberOfLines = 0;
    }
    
    return _reasonLab;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton at_createBtnWithTitle:nil fontSize:0 titleColor:nil imgName:@"img_checkAttendance_editing" bgColor:nil addTarget:self selector:nil];//@selector(editBtnClicked)
    }
    
    return _editBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.statusLab];
        [self.contentView addSubview:self.addressIV];
        [self.contentView addSubview:self.addressLab];
        [self.contentView addSubview:self.reasonView];
        [self.reasonView addSubview:self.reasonIV];
        [self.reasonView addSubview:self.reasonLab];
        [self.reasonView addSubview:self.editBtn];
        
        [self initConstraints];
    }
    
    return self;
}

- (void)initConstraints
{
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.circleView);
        make.bottom.mas_equalTo(self.circleView.mas_top);
        make.width.mas_equalTo(0.5);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusLab);
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
//        make.width.mas_equalTo(30);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.titleLab.mas_right).offset(25);
    }];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLab);
        make.left.mas_equalTo(self.timeLab.mas_right).offset(25);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(- 30);
    }];
    
    [self.addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.timeLab);
        make.width.height.mas_equalTo(15);
    }];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressIV);
        make.left.mas_equalTo(self.addressIV.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(- 10);
    }];
    
    [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.addressIV);
        make.right.mas_equalTo(self.contentView).offset(- 10);
        make.bottom.mas_lessThanOrEqualTo(self.contentView);
    }];
    
    [self.reasonIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonView);
//        make.centerY.mas_equalTo(self.reasonView);
        make.left.mas_equalTo(self.reasonView);
        make.width.height.mas_equalTo(15);
    }];
    [self.reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonView);
        make.left.mas_equalTo(self.reasonIV.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self.editBtn.mas_left).offset(- 5);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reasonIV);
        make.right.mas_equalTo(self.reasonView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(self.reasonView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"***self.addressIV.frame:%@*****",NSStringFromCGRect(self.addressIV.frame));
}

- (void)updateCellWithData:(id)aCellData hideHeaderLine:(BOOL)isHeaderHidden hideFooterLine:(BOOL)isFooterHidden
{
    if ([aCellData isKindOfClass:[ATPunchCardModel class]]) {
        ATPunchCardModel *model = (ATPunchCardModel *)aCellData;
        _cardModel = model;
        NSInteger signType = model.SignType.unsignedIntegerValue;
        if (1 == signType) {
            self.titleLab.text = @"上班";
        } else if (2 == signType) {
            self.titleLab.text = @"下班";
        } else if (3 == signType) {
            self.titleLab.text = @"外勤";
        }
        if (model.isFirstModel) {
            self.topLineView.hidden = YES;
        } else {
            self.topLineView.hidden = NO;
        }
        self.timeLab.text = [NSString at_getFormatterDateStrWithFormatterStr:@"HH:mm" timeStamp:model.Time];
        self.addressLab.text = model.Location;
         self.reasonLab.text = model.Remark == nil || [model.Remark isEqualToString:@""]?@"未填写":[model.Remark stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (model.isAbnormal) {
            if (3 != signType) {
                self.statusLab.text = @"异常";
            }
            self.reasonView.hidden = NO;
        } else {
            self.statusLab.text = @"";
            self.reasonView.hidden = YES;
        }
    }
}

- (void)editBtnClicked
{
    if (_block) {
        _block(_cardModel);
    }
}

- (void)cellOfEditingBtnClicked:(ATCheckAttendanceViewCellBlock)block
{
    _block = block;
}

@end
