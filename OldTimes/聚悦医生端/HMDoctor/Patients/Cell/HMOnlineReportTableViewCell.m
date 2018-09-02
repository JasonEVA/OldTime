//
//  HMOnlineReportTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineReportTableViewCell.h"

@interface HMOnlineReportTableViewCell ()

@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation HMOnlineReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.namelabel];
        [self.contentView addSubview:self.resultLabel];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@12);
    }];
    
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_namelabel.mas_left);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12);
        make.top.equalTo(_namelabel.mas_bottom).offset(10);
    }];
}

- (void)setBfzResultListModel:(BfzResultListModel *)model
{
    if (!model) {
        return;
    }
    [_namelabel setText:model.surveyMoudleName];
    
    NSMutableArray *evaluateResult = [NSMutableArray array];
    
    [model.evaluateResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [evaluateResult addObject:obj];
    }];
    
    [_resultLabel setText:[self acquireStringWithArray:evaluateResult separator:@" ;"]];
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

- (UILabel *)namelabel{
    if (!_namelabel) {
        _namelabel = [UILabel new];
        [_namelabel setFont:[UIFont font_28]];
        [_namelabel setTextColor:[UIColor commonGrayTextColor]];
        [_namelabel setNumberOfLines:0];
        [_namelabel setText:@"疾病风险评估"];
    }
    return _namelabel;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [UILabel new];
        [_resultLabel setFont:[UIFont font_28]];
        [_resultLabel setTextColor:[UIColor commonGrayTextColor]];
        [_resultLabel setNumberOfLines:0];
        //[_resultLabel setText:@"有睡眠问题"];
    }
    return _resultLabel;
}

@end



@interface HMDiagnoseReportTableViewCell ()

@property (nonatomic, strong) UILabel *mainDiaLabel;
@property (nonatomic, strong) UILabel *minorDiaLabel;

@end

@implementation HMDiagnoseReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.mainDiaLabel];
        [self.contentView addSubview:self.minorDiaLabel];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_mainDiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@12);
    }];
    
    [_minorDiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainDiaLabel.mas_left);
        make.top.equalTo(_mainDiaLabel.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
}

- (void)fillDiagnoseDataList:(NSArray *)dataList
{
    if (!dataList || dataList.count == 0) {
        [_mainDiaLabel setText:@"暂无诊断"];
        [_minorDiaLabel setHidden:YES];
        return;
    }
    
    [_minorDiaLabel setHidden:NO];
    __block NSMutableArray *tempArr = [NSMutableArray array];
    __block NSString *mainDiagnose = @"";
    [dataList enumerateObjectsUsingBlock:^(HMThirdEditionPatitentDiagnoseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.orderIndex == 1) {
            mainDiagnose = obj.diseaseName;
        }
        else {
            [tempArr addObject:obj.diseaseName];
        }
    }];
    
    [_mainDiaLabel setText:[NSString stringWithFormat:@"主要诊断：%@",mainDiagnose]];
    
    NSString *minordiaStr = [self acquireStringWithArray:tempArr separator:@" ;"];
    [_minorDiaLabel setText:[NSString stringWithFormat:@"次要诊断：%@",minordiaStr]];
    
    if (tempArr.count == 0) {
        [_minorDiaLabel setHidden:YES];
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

- (UILabel *)mainDiaLabel{
    if (!_mainDiaLabel) {
        _mainDiaLabel = [UILabel new];
        [_mainDiaLabel setFont:[UIFont font_28]];
        [_mainDiaLabel setTextColor:[UIColor commonGrayTextColor]];
        [_mainDiaLabel setNumberOfLines:0];
        [_mainDiaLabel setText:@"主要诊断："];
    }
    return _mainDiaLabel;
}

- (UILabel *)minorDiaLabel {
    if (!_minorDiaLabel) {
        _minorDiaLabel = [UILabel new];
        [_minorDiaLabel setFont:[UIFont font_28]];
        [_minorDiaLabel setTextColor:[UIColor commonGrayTextColor]];
        [_minorDiaLabel setNumberOfLines:0];
        [_minorDiaLabel setText:@"次要诊断："];
    }
    return _minorDiaLabel;
}


@end
