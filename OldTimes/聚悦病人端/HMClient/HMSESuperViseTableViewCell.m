//
//  HMSESuperViseTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSESuperViseTableViewCell.h"
#import "HMSuperViseGraphView.h"
#import "HMEachTestModel.h"
#import "HMSuperViseHistogramView.h"
#import "HMSuperViseNLModel.h"

#define SCLOCE    (kScreenWidth/375)
@interface HMSESuperViseTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *statusLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *targetLb;
@property (nonatomic, strong) UILabel *unitLb;
@property (nonatomic, strong) UILabel *emptyLb;
@property (nonatomic, strong) UIButton *toTestBtn;
@property (nonatomic, copy) NSString *typeString;

@property (nonatomic, strong) HMSuperViseGraphView *graphView;
@property (nonatomic, strong) HMSuperViseHistogramView *histogrsamView;
@end


@implementation HMSESuperViseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.timeLb];
        [self.backView addSubview:self.toTestBtn];
        [self.backView addSubview:self.titelLb];
        [self.backView addSubview:self.statusLb];
        [self.backView addSubview:self.targetLb];
        [self.backView addSubview:self.unitLb];
        [self.backView addSubview:self.emptyLb];
        [self.backView addSubview:self.graphView];
        [self.backView addSubview:self.histogrsamView];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(15);
            make.left.equalTo(self.backView).offset(15);
        }];
        
        
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(5);
        }];
        
        [self.targetLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLb.mas_bottom).offset(10);
            make.left.equalTo(self.titelLb);
        }];
        
        [self.unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.targetLb.mas_right);
            make.bottom.equalTo(self.targetLb);
        }];
        
        [self.emptyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.top.equalTo(self.titelLb.mas_bottom).offset(8);
        }];
        
        [self.toTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.top.equalTo(self.emptyLb.mas_bottom).offset(12);
            make.height.equalTo(@30);
            make.width.equalTo(@85);
        }];
        
        [self.graphView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backView);
            make.right.equalTo(self.backView).offset(-20);
            make.width.equalTo(@160);
            make.height.equalTo(@75);
        }];
        
        [self.histogrsamView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.graphView);
        }];
        
        [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titelLb);
            make.left.equalTo(self.titelLb.mas_right).offset(5);
            make.right.lessThanOrEqualTo(self.graphView.mas_left).offset(-5);
        }];
        
        [self.emptyLb setHidden:YES];
        [self.toTestBtn setHidden:YES];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)toTestClick {
    [self targetValueDashboardClicked:self.typeString];
}

- (void)targetValueDashboardClicked:(NSString *)kpiCode {
    NSString *controllerName = nil;
    if (!kpiCode || 0 == kpiCode.length) {
        return;
    }
    if ([kpiCode isEqualToString:@"XY"]) {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TZ"]) {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XT"]) {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XD"]) {
        //心电
        controllerName = @"ECGDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        //心率
        controllerName = @"HeartRateDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XZ"]) {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"OXY"]) {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"NL"]) {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"HX"]) {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TEM"]) {
        //体温
        controllerName = @"BodyTemperatureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        //峰流速值
        controllerName = @"PEFDetectStartViewController";
    }
    if (!controllerName || 0 == controllerName.length) {
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
}

- (void)fillDataWith:(NSString *)typeString dataArr:(NSArray *)dataArr {
    self.typeString = typeString;
    __block NSMutableArray <HMEachTestModel *>*modelArr = [HMEachTestModel mj_objectArrayWithKeyValuesArray:dataArr];
    HMEachTestModel *model = modelArr.firstObject;
    [self.statusLb setText:model.testResult];
    [self.statusLb setTextColor:model.status ? [UIColor colorWithHexString:@"ff9c37"]:[UIColor mainThemeColor]];
    NSDate *date = [NSDate dateWithString:model.time formatString:@"yyyy-MM-dd HH:mm:ss"];
    
    [self.timeLb setText:[date formattedDateWithFormat:@"MM-dd HH:mm"]];
    [self.unitLb setText:model.unit];
    
    if (![typeString isEqualToString:@"XY"]) {
        [self.targetLb setText:model.testValue];
    }
    CGFloat maxTarget = 0;
    CGFloat minTarget = 0;
    if ([typeString isEqualToString:@"XY"]) {
        // 血压
        [self.titelLb setText:@"血压"];
        if (kScreenWidth < 375) {
            [self.targetLb setFont:[UIFont systemFontOfSize:13]];
        }
        [self.targetLb setText:[NSString stringWithFormat:@"%@/%@",model.ssy,model.szy]];
        maxTarget = 200;
        minTarget = 60;
    }
    else if ([typeString isEqualToString:@"XT"]) {
        // 血糖
        [self.titelLb setText:@"血糖"];
        maxTarget = 8;
        minTarget = 3;
    }
    else if ([typeString isEqualToString:@"HX"]) {
        // 呼吸
        [self.titelLb setText:@"呼吸"];
        maxTarget = 20;
        minTarget = 12;
    }
    else if ([typeString isEqualToString:@"NL"]) {
        // 尿量
        [self.titelLb setText:@"尿量"];
        maxTarget = 1000;
        minTarget = 0;
        
        NSArray <HMSuperViseNLModel *>*tempArr = [HMSuperViseNLModel mj_objectArrayWithKeyValuesArray:dataArr];
        if (tempArr && tempArr.count) {
            [modelArr removeAllObjects];
            [tempArr enumerateObjectsUsingBlock:^(HMSuperViseNLModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj && obj.list) {
                    [modelArr insertObject:obj.list atIndex:0];
                }
            }];
        }
        
        if (kScreenWidth < 375) {
            [self.targetLb setFont:[UIFont systemFontOfSize:13]];
        }
        
        HMSuperViseNLModel *tempModel = tempArr.firstObject;
        if (tempModel.list && tempModel.list.count) {
            switch (tempModel.list.count) {
                case 1:
                {
                    [self.targetLb setText:tempModel.list.firstObject.testValue];
                    if ([tempModel.list.firstObject.kpiCode isEqualToString:@"NL_SUB_DAY"]) {
                        [self.statusLb setText:@"日"];
                    }
                    else {
                        [self.statusLb setText:@"夜"];
                    }
                    break;
                }
                case 2:
                {
                    [self.statusLb setText:@"日/夜"];
                    if ([tempModel.list.firstObject.kpiCode isEqualToString:@"NL_SUB_DAY"]) {
                        [self.targetLb setText:[NSString stringWithFormat:@"%@/%@",tempModel.list.firstObject.testValue,tempModel.list.lastObject.testValue]];
                    }
                    else {
                        [self.targetLb setText:[NSString stringWithFormat:@"%@/%@",tempModel.list.lastObject.testValue,tempModel.list.firstObject.testValue]];
                    }
                    break;
                }
                    
                    
                default:
                    break;
            }
        }
        
        [self.statusLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        NSDate *date = [NSDate dateWithString:tempModel.time formatString:@"yyyy-MM-dd"];
        
        [self.timeLb setText:[date formattedDateWithFormat:@"MM-dd"]];
        [self.unitLb setText:tempModel.list.lastObject.unit];
       
    }
    else if ([typeString isEqualToString:@"TZ"]) {
        // 体重
        [self.titelLb setText:@"体重"];
        [self.timeLb setText:[date formattedDateWithFormat:@"MM-dd"]];

        if (modelArr.count) {
            __block CGFloat tempMax = 0;
            __block CGFloat tempMin = 0;
            [modelArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!idx) {
                    tempMax = obj.testValue.floatValue;
                    tempMin = obj.testValue.floatValue;
                }
                else {
                    tempMin = MIN(tempMin, obj.testValue.floatValue);
                    tempMax = MAX(tempMax, obj.testValue.floatValue);
                }
            }];
            maxTarget = tempMax + 10;
            minTarget = tempMin - 10;
        }
        
    }
    else if ([typeString isEqualToString:@"OXY"]) {
        // 血氧
        [self.titelLb setText:@"血氧"];
        maxTarget = 100;
        minTarget = 90;
    }
    else if ([typeString isEqualToString:@"XL"]) {
        // 心率
        [self.titelLb setText:@"心率"];
        maxTarget = 150;
        minTarget = 60;
    }
    else if ([typeString isEqualToString:@"TEM"]) {
        // 体温
        [self.titelLb setText:@"体温"];
        maxTarget = 40;
        minTarget = 36;
    }
    else if ([typeString isEqualToString:@"FLSZ"]) {
        // 呼吸峰流速值
        [self.titelLb setText:@"呼气峰流速值"];
        if (modelArr.count) {
            __block CGFloat tempMax = 0;
            __block CGFloat tempMin = 0;
            [modelArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!idx) {
                    tempMax = obj.testValue.floatValue;
                    tempMin = obj.testValue.floatValue;
                }
                else {
                    tempMin = MIN(tempMin, obj.testValue.floatValue);
                    tempMax = MAX(tempMax, obj.testValue.floatValue);
                }
            }];
            maxTarget = tempMax + 100;
            minTarget = MAX(0, tempMin - 100);
        }

    }
    
    if ([typeString isEqualToString:@"XY"]) {
        [self.graphView setHidden:NO];
        [self.histogrsamView setHidden:YES];
        // 血压
        __block NSMutableArray *array1 = [NSMutableArray array];
        __block NSMutableArray *array2 = [NSMutableArray array];
        __block NSMutableArray *statusArr = [NSMutableArray array];
        [modelArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array1 insertObject:obj.ssy atIndex:0];
            [array2 insertObject:obj.szy atIndex:0];
            [statusArr insertObject:@(obj.status) atIndex:0];
        }];
        [self.graphView fillDataWithArrayOne:array1 arrayTwo:array2 maxTarget:maxTarget minTarget:minTarget statusArr:statusArr];
    }
    else if ([typeString isEqualToString:@"NL"]) {
        // 尿量
        [self.graphView setHidden:YES];
        [self.histogrsamView setHidden:!([modelArr isKindOfClass:[NSArray class]] && modelArr.count)];
        if ([modelArr isKindOfClass:[NSArray class]] && modelArr.count) {
            [self.histogrsamView fillDataWithArr:modelArr maxTarget:maxTarget minTarget:minTarget];
        }
    }
    else if ([typeString isEqualToString:@"FLSZ"]) {
        // 峰流速值
        [self.graphView setHidden:NO];
        [self.histogrsamView setHidden:YES];
        
        __block NSMutableArray *array = [NSMutableArray array];
        __block NSMutableArray *statusArr = [NSMutableArray array];
        [modelArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array insertObject:obj.testValue atIndex:0];
            [statusArr insertObject:@(obj.timeStage) atIndex:0];
        }];

        [self.graphView fillFLSZDataWithArr:array maxTarget:maxTarget minTarget:minTarget statusArr:statusArr];
    }
    else {
        [self.graphView setHidden:NO];
        [self.histogrsamView setHidden:YES];
        
        __block NSMutableArray *array = [NSMutableArray array];
        __block NSMutableArray *statusArr = [NSMutableArray array];
        [modelArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array insertObject:obj.testValue atIndex:0];
            [statusArr insertObject:@(obj.status) atIndex:0];
        }];
        
        [self.graphView fillDataWithArr:array maxTarget:maxTarget minTarget:minTarget statusArr:statusArr];

    }
    
    
    [self.emptyLb setHidden:dataArr.count];
    [self.toTestBtn setHidden:dataArr.count];
    [self.statusLb setHidden:!dataArr.count];
    [self.timeLb setHidden:!dataArr.count];
    [self.targetLb setHidden:!dataArr.count];
    [self.unitLb setHidden:!dataArr.count];
    [self.graphView setHidden:!dataArr.count];
    
    [self.emptyLb setText:[NSString stringWithFormat:@"您还没有测过一次%@哦！",self.titelLb.text]];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [_backView.layer setCornerRadius:3];
    }
    return _backView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setText:@"心率"];
    }
    return _titelLb;
}

- (UILabel *)statusLb {
    if (!_statusLb) {
        _statusLb = [UILabel new];
        [_statusLb setTextColor:[UIColor colorWithHexString:@"255555"]];
        [_statusLb setFont:[UIFont systemFontOfSize:15]];
        [_statusLb setText:@"偏高"];
    }
    return _statusLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLb setFont:[UIFont systemFontOfSize:12]];
        [_timeLb setText:@"05-11 11:30"];
    }
    return _timeLb;
}

- (UILabel *)targetLb {
    if (!_targetLb) {
        _targetLb = [UILabel new];
        [_targetLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_targetLb setFont:[UIFont systemFontOfSize:25]];
        [_targetLb setText:@"130"];
    }
    return _targetLb;
}

- (UILabel *)unitLb {
    if (!_unitLb) {
        _unitLb = [UILabel new];
        [_unitLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_unitLb setFont:[UIFont systemFontOfSize:12]];
        [_unitLb setText:@"次/分"];
    }
    return _unitLb;
}

- (UILabel *)emptyLb {
    if (!_emptyLb) {
        _emptyLb = [UILabel new];
        [_emptyLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_emptyLb setFont:[UIFont systemFontOfSize:15]];
        [_emptyLb setText:@"您还没有测过一次体温哦！"];
    }
    return _emptyLb;
}

- (UIButton *)toTestBtn {
    if (!_toTestBtn) {
        _toTestBtn = [[UIButton alloc] init];
        [_toTestBtn.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [_toTestBtn.layer setBorderWidth:0.5];
        [_toTestBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_toTestBtn.layer setCornerRadius:15];
        [_toTestBtn setTitle:@"去测量" forState:UIControlStateNormal];
        [_toTestBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_toTestBtn addTarget:self action:@selector(toTestClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toTestBtn;
}

- (HMSuperViseGraphView *)graphView {
    if (!_graphView) {
        _graphView = [HMSuperViseGraphView new];
    }
    return _graphView;
}

- (HMSuperViseHistogramView *)histogrsamView {
    if (!_histogrsamView) {
        _histogrsamView = [HMSuperViseHistogramView new];
    }
    return _histogrsamView;
}
@end
