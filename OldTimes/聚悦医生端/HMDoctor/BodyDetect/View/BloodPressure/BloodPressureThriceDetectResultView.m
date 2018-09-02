//
//  BloodPressureThriceDetectResultView.m
//  HMClient
//
//  Created by lkl on 2017/6/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureThriceDetectResultView.h"

@interface BloodPressureThriceDetectResultView ()

@property (nonatomic, strong) UILabel *symptomLabel;
@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UILabel* sceneLabel;  //测量环境

@end

@implementation BloodPressureThriceDetectResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.symptomLabel];
        [self addSubview:self.timesLabel];
        [self addSubview:self.sceneLabel];
        
        [_symptomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.top.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-12.5);
        }];
        
        [_timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_symptomLabel.mas_left);
            make.top.equalTo(self.symptomLabel.mas_bottom).offset(10);
        }];
        
        [self.sceneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timesLabel);
            make.top.equalTo(self.timesLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void) setDetectResult:(BloodPressureDetectResult*) result
{
    if (!kArrayIsEmpty(result.symptomList)) {
        
        NSMutableArray *symptomList = [NSMutableArray array];
        
        for (NSDictionary *dic in result.symptomList) {
            BloodPressureSymptomModel *model = [BloodPressureSymptomModel mj_objectWithKeyValues:dic];
            [symptomList addObject:model.symptomName];
        }
        
        NSString *symptom = [self acquireStringWithArray:symptomList separator:@","];
        [_symptomLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"症状：" changePart:symptom changeColor:[UIColor commonTextColor] changeFont:[UIFont font_28]]];
    }
    else{
        [_symptomLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"症状：" changePart:@"无" changeColor:[UIColor commonTextColor] changeFont:[UIFont font_28]]];
    }

    [_timesLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"测量次数：" changePart:[NSString stringWithFormat:@"%@次",result.testCount] changeColor:[UIColor commonTextColor] changeFont:[UIFont font_28]]];
    
    if (result.testEnvName && result.testEnvName.length > 0) {
        [self.sceneLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"测量环境：" changePart:[NSString stringWithFormat:@"%@",result.testEnvName] changeColor:[UIColor commonTextColor] changeFont:[UIFont font_28]]];
    }
    else
    {
        [self.sceneLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"测量环境：" changePart:[NSString stringWithFormat:@"--"] changeColor:[UIColor commonTextColor] changeFont:[UIFont font_28]]];
    }
}

- (NSString *)acquireStringWithArray:(NSArray *)array separator:(NSString *)separator{
    __block NSString *tempString = @"";
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj length]) {
            if (!tempString.length ) {
                tempString = obj;
            }
            else {
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@%@",separator,obj]];
            }
            
        }
        
    }];
    return tempString;
}

#pragma mark -- init
- (UILabel *)symptomLabel{
    if (!_symptomLabel) {
        _symptomLabel = [UILabel new];
        [_symptomLabel setText:@"症状："];
        [_symptomLabel setTextColor:[UIColor commonGrayTextColor]];
        [_symptomLabel setFont:[UIFont font_28]];
    }
    return _symptomLabel;
}

- (UILabel *)timesLabel{
    if (!_timesLabel) {
        _timesLabel = [UILabel new];
        [_timesLabel setText:@"测量次数："];
        [_timesLabel setTextColor:[UIColor commonGrayTextColor]];
        [_timesLabel setFont:[UIFont font_28]];
    }
    return _timesLabel;
}

- (UILabel *) sceneLabel{
    if (!_sceneLabel) {
        _sceneLabel = [UILabel new];
        [_sceneLabel setText:@"测量环境："];
        [_sceneLabel setTextColor:[UIColor commonGrayTextColor]];
        [_sceneLabel setFont:[UIFont font_28]];
    }
    return _sceneLabel;
}

@end


//历次血压值
@interface BloodPressureDataView : UIView
{
    NSString *ssyValue;
    NSString *szyValue;
}
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)setDataList:(BloodPressureDataModel *)model;
@end

@implementation BloodPressureDataView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.valueLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.lineView];
    
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12.5);
            make.centerY.equalTo(self);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_offset(@1);
        }];
    }
    return self;
}


- (void)setDataList:(BloodPressureDataModel *)model{
    

    [model.detList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BloodPressureDataValue *dataModel = [BloodPressureDataValue mj_objectWithKeyValues:dic];
        
        if ([dataModel.kpiCode isEqualToString:@"SSY"]) {
            ssyValue = dataModel.testValue;
        }
        
        if ([dataModel.kpiCode isEqualToString:@"SZY"]) {
            szyValue = dataModel.testValue;
        }
    }];
    
    [_valueLabel setAttributedText:[NSAttributedString getAttributWithUnChangePart:[NSString stringWithFormat:@"%@/%@",ssyValue,szyValue] changePart:@" mmHg" changeColor:[UIColor commonGrayTextColor] changeFont:[UIFont font_28]]];
    [_dateLabel setText:model.testTime];
}
#pragma mark -- init
- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        [_valueLabel setTextColor:[UIColor commonTextColor]];
        [_valueLabel setFont:[UIFont font_28]];
    }
    return _valueLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dateLabel setFont:[UIFont font_28]];
    }
    return _dateLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    }
    return _lineView;
}

@end

@interface BloodPressureThriceDetectDataListView ()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BloodPressureThriceDetectDataListView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.top.equalTo(self);
            make.height.mas_equalTo(@40);
        }];
    }
    return self;
}

- (void) setDetectResult:(BloodPressureDetectResult *)result{
    
    [result.xyTestDataVoList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BloodPressureDataModel *model = [BloodPressureDataModel mj_objectWithKeyValues:dic];
        //布局
        BloodPressureDataView *dataView = [[BloodPressureDataView alloc] init];
        [self addSubview:dataView];
        [dataView setDataList:model];
        [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_titleLabel.mas_bottom).offset(idx*40);
            make.height.mas_equalTo(@40);
        }];
        

    }];
}

#pragma mark -- init
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"历次血压值"];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
        [_titleLabel setFont:[UIFont font_30]];
    }
    return _titleLabel;
}
@end
