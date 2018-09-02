//
//  HMThirdEditionPatitentInfoReportTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThirdEditionPatitentInfoReportTableViewCell.h"
#import "HMThirdEditionPatitentInfoModel.h"
#import "HMImaginarylineView.h"

#define scale  (ScreenWidth / (750.0 / 2))

@interface HMThirdEditionPatitentInfoReportTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *lastLb;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *ScreeningResultPageButton; //查看筛查表
@property (nonatomic, copy) NSString *admissionId; //筛查表id
@end

@implementation HMThirdEditionPatitentInfoReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(3, 20));
        }];
        
        [self.contentView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(_lineView.mas_right).offset(5);
            make.height.mas_equalTo(@20);
        }];
    }
    return self;
}

- (void)fillDiagnoseDataWithModel:(HMThirdEditionPatitentInfoModel *)model {
    if (!model) {
        return;
    }
    [self.titelLb setText:@"诊断"];

    if (model.userIDC && model.userIDC.count) {
        __block NSMutableArray *tempArr = [NSMutableArray array];
        __block NSString *mainDiagnose = @"";
        [model.userIDC enumerateObjectsUsingBlock:^(HMThirdEditionPatitentDiagnoseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.orderIndex == 1) {
                mainDiagnose = obj.diseaseName;
            }
            else {
                [tempArr addObject:obj.diseaseName];
            }
        }];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:mainDiagnose forKey:@"主要诊断："];
        [tempDict setObject:[self acquireStringWithArray:tempArr separator:@"；"] forKey:@"次要诊断："];
        
        [self fillDataWithDict:tempDict onlyKeyIsShow:NO];
    }
    else {
        UILabel *tempLb = [self acquiceLabel];
        [tempLb setText:@"暂无诊断"];
        [self.contentView addSubview:tempLb];
        [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
            //make.bottom.equalTo(self.contentView).offset(-20);
        }];

    }
}

- (void)fillHealthRiskDataWithModel:(HMThirdEditionPatitentInfoModel *)model {
    if (!model) {
        return;
    }
    [self.titelLb setText:@"健康风险评估报告"];
    self.admissionId = model.admissionId;
    if ([model.screeningResultPage isEqualToString:@"Y"]) {
        [self.contentView addSubview:self.ScreeningResultPageButton];
        [self.ScreeningResultPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLb.mas_top);
            make.right.equalTo(self.contentView).with.offset(-12);
        }];
    }

    if (model.hasAdmission) {
        if (model.admissionStatus == 2) {
            if (model.assessList && model.assessList.count) {
                __block NSMutableArray *tempKeyArr = [NSMutableArray array];
                __block NSMutableArray *tempVeaulArr = [NSMutableArray array];
                __weak typeof(self) weakSelf = self;
                [[self acquireOrderWithArray:model.assessList] enumerateObjectsUsingBlock:^(HMThirdEditionPatitentHealthRiskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [tempKeyArr addObject:[NSString stringWithFormat:@"%@：",obj.moudleTypeName]];
                    [tempVeaulArr addObject:[strongSelf acquireStringWithArray:obj.assessResult separator:@"  " ]];
                }];
                
                [self fillHealthRiskDataWithDict:tempKeyArr allVeauls:tempVeaulArr];
            }
            else {
                UILabel *tempLb = [self acquiceLabel];
                [tempLb setText:@"经筛查，该用户的健康状况良好！"];
                [self.contentView addSubview:tempLb];
                [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    //make.centerX.equalTo(self.contentView);
                    make.left.equalTo(self.lineView.mas_left);
                    make.top.equalTo(self.titelLb.mas_bottom).offset(10);
                    //make.bottom.equalTo(self.contentView).offset(-20);
                }];
            }
        }
        else {
            UILabel *tempLb = [self acquiceLabel];
            [tempLb setText:@"筛查中..."];
            [self.contentView addSubview:tempLb];
            [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.centerX.equalTo(self.contentView);
                make.left.equalTo(self.lineView.mas_left);
                make.top.equalTo(self.titelLb.mas_bottom).offset(10);
                //make.bottom.equalTo(self.contentView).offset(-20);
            }];
            
        }

    }
    else {
        UILabel *tempLb = [self acquiceLabel];
        [tempLb setText:@"健康风险筛查未完成"];
        [self.contentView addSubview:tempLb];
        [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.lineView.mas_left);
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
            //make.bottom.equalTo(self.contentView).offset(-20);
        }];

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

- (void)fillDataWithDict:(NSMutableDictionary *)dict onlyKeyIsShow:(BOOL)onlyKeyIsShow{
    __weak typeof(self) weakSelf = self;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!onlyKeyIsShow && [obj length]) {
            UILabel *keyLb = [strongSelf acquiceLabel];
            UILabel *veaulLb = [strongSelf acquiceLabel];
            [keyLb setText:key];
            [veaulLb setText:obj];
            
            [strongSelf.contentView addSubview:keyLb];
            [strongSelf.contentView addSubview:veaulLb];
            
            [keyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                if (strongSelf.lastLb) {
                    make.top.equalTo(strongSelf.lastLb.mas_bottom).offset(5);
                }
                else {
                    make.top.equalTo(strongSelf.titelLb.mas_bottom).offset(10);
                }
                make.left.equalTo(strongSelf.lineView);
                make.width.equalTo(@80);
            }];
            
            [veaulLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(keyLb);
                make.left.equalTo(keyLb.mas_right);
                make.right.lessThanOrEqualTo(strongSelf.contentView).offset(-15);
            }];
            
            strongSelf.lastLb = veaulLb;

        }
        if (onlyKeyIsShow) {
            UILabel *keyLb = [strongSelf acquiceLabel];
            UILabel *veaulLb = [strongSelf acquiceLabel];
            [keyLb setText:key];
            [veaulLb setText:obj];
            
            [strongSelf.contentView addSubview:keyLb];
            [strongSelf.contentView addSubview:veaulLb];
            
            [keyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                if (strongSelf.lastLb) {
                    make.top.equalTo(strongSelf.lastLb.mas_bottom).offset(5);
                }
                else {
                    make.top.equalTo(strongSelf.titelLb.mas_bottom).offset(10);
                }
                make.left.equalTo(strongSelf.lineView);
            }];
            
            [veaulLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(keyLb);
                make.left.equalTo(keyLb.mas_right);
                make.right.lessThanOrEqualTo(strongSelf.contentView).offset(-15);
            }];
            if ([key length]) {
                strongSelf.lastLb = keyLb;
            }
            if ([obj length]) {
                strongSelf.lastLb = veaulLb;
            }
        }
        
    }];
    
    [self.lastLb mas_updateConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
}

//健康风险评估UI布局方法
- (void)fillHealthRiskDataWithDict:(NSArray *)allKeys allVeauls:(NSArray *)allVeauls {
    __weak typeof(self) weakSelf = self;
    [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UILabel *keyLb = [strongSelf acquiceLabel];
        [keyLb setFont:[UIFont font_28]];
        [keyLb setTextColor:[UIColor colorWithHexString:@"666666"]];
        UILabel *veaulLb = [strongSelf acquiceLabel];
        [keyLb setText:obj];
        [veaulLb setText:allVeauls[idx]];
        
        [strongSelf.contentView addSubview:keyLb];
        [strongSelf.contentView addSubview:veaulLb];
        if (strongSelf.lastLb) {
            HMImaginarylineView *line = [HMImaginarylineView new];
            [strongSelf.contentView addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(strongSelf.lineView);
                make.right.equalTo(strongSelf.contentView).offset(-15*scale);
                make.height.equalTo(@0.5);
                make.top.equalTo(strongSelf.lastLb.mas_bottom).offset(10);
            }];
            
            [keyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line.mas_bottom).offset(10);
                make.left.equalTo(strongSelf.lineView);
            }];
            
        }
        else {
            [keyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.titelLb.mas_bottom).offset(10);
                make.left.equalTo(strongSelf.lineView);
            }];
        }
        
        
        
        [veaulLb mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(keyLb.mas_bottom).offset(5);
            //make.left.equalTo(keyLb);
            //make.right.lessThanOrEqualTo(self.contentView).offset(-15);
            make.top.equalTo(keyLb.mas_top);
            make.right.equalTo(strongSelf.contentView).offset(-15);
            make.left.greaterThanOrEqualTo(strongSelf.lineView.mas_left);
        }];
        strongSelf.lastLb = veaulLb;

    }];
    

    [self.lastLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

    
}


- (NSArray *)acquireOrderWithArray:(NSArray *)array {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"moudleType" ascending:YES];
    
    NSArray *sortArray = [NSArray arrayWithObjects:descriptor,nil];
    
    NSMutableArray* allMsgs = [array sortedArrayUsingDescriptors:sortArray].mutableCopy;
    return allMsgs;
}

- (UILabel *)acquiceLabel {
    UILabel *tempLb = [UILabel new];
    [tempLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [tempLb setFont:[UIFont font_28]];
    [tempLb setNumberOfLines:0];
    return tempLb;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)ScreeningResultPageButtonClick:(UIButton *)sender
{
    if (_isScreeningResultPageBlock) {
        _isScreeningResultPageBlock();
    }
//    if (self.admissionId) {
//        [HMViewControllerManager createViewControllerWithControllerName:@"HMScreeningInventoryViewController" ControllerObject:self.admissionId];
//    }
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_32]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@"标题"];
    }
    return _titelLb;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _lineView;
}

- (UIButton *)ScreeningResultPageButton{
    if (!_ScreeningResultPageButton) {
        _ScreeningResultPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ScreeningResultPageButton setBackgroundColor:[UIColor whiteColor]];
        [_ScreeningResultPageButton setTitle:@"查看筛查表" forState:UIControlStateNormal];
        [_ScreeningResultPageButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_ScreeningResultPageButton.titleLabel setFont:[UIFont font_28]];
        [_ScreeningResultPageButton addTarget:self action:@selector(ScreeningResultPageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ScreeningResultPageButton;
}

@end
