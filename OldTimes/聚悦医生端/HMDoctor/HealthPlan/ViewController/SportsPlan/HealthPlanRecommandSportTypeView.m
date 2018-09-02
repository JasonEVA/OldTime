//
//  HealthPlanRecommanSportTypeView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanRecommandSportTypeView.h"

@interface HealthPlanRecommandSportTypeCell : UIView

@property (nonatomic, strong) UILabel* typeLabel;

- (instancetype)initWithSportTypeModel:(HealthSportTypeModel*) typeModel;

@end

@implementation HealthPlanRecommandSportTypeCell

- (instancetype)initWithSportTypeModel:(HealthSportTypeModel*) typeModel
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self.typeLabel setText:typeModel.sportsName];
    }
    return self;
}

#pragma mark - settingAndGetting
- (UILabel*) typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [self addSubview:_typeLabel];
        
        [_typeLabel setFont:[UIFont systemFontOfSize:13]];
        [_typeLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _typeLabel;
}

@end

@interface HealthPlanRecommandSportTypeView ()

@property (nonatomic, strong) NSArray* sportsTypes;
@property (nonatomic, strong) NSMutableArray* sportsTypeCells;

@end

@implementation HealthPlanRecommandSportTypeView

- (id) init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (id) initWithSportsTypes:(NSArray*) sportsTypes
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _sportsTypes = sportsTypes;
        [self createTypeCells];
        [self layoutTypeCells];
    }
    return self;
}

- (void) setSportsTypes:(NSArray*) sportsTypes
{
    _sportsTypes = sportsTypes;
    [self createTypeCells];
    [self layoutTypeCells];
}

- (void) createTypeCells
{
    if (!self.sportsTypes || self.sportsTypes.count == 0) {
        return;
    }
    if (_sportsTypeCells) {
        [_sportsTypeCells enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview removeFromSuperview];
        }];
        [_sportsTypeCells removeAllObjects];
    }
    else
    {
        _sportsTypeCells = [NSMutableArray array];
    }
    
    [self.sportsTypes enumerateObjectsUsingBlock:^(HealthSportTypeModel* typeModel, NSUInteger idx, BOOL * _Nonnull stop)
    {
        HealthPlanRecommandSportTypeCell* typeCell = [[HealthPlanRecommandSportTypeCell alloc] initWithSportTypeModel:typeModel];
        [self addSubview:typeCell];
        [_sportsTypeCells addObject:typeCell];
        
    }];
}

- (void) layoutTypeCells
{
    [self.sportsTypeCells enumerateObjectsUsingBlock:^(HealthPlanRecommandSportTypeCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@((kScreenWidth - 55)/4));
            
            if ((idx % 4) == 0)
            {
                make.left.equalTo(self).offset(12.5);
                if (idx == 0) {
                    make.top.equalTo(self).offset(12.5);
                }
                else
                {
                    HealthPlanRecommandSportTypeCell* perCell = self.sportsTypeCells[idx - 1];
                    make.top.equalTo(perCell.mas_bottom).offset(10);
                }
            }
            else
            {
                HealthPlanRecommandSportTypeCell* perCell = self.sportsTypeCells[idx - 1];
                make.left.equalTo(perCell.mas_right).offset(10);
                
                make.top.equalTo(perCell);
            }
            
            
            
            if (cell == self.sportsTypeCells.lastObject) {
                make.bottom.equalTo(self).offset(-12.5);
            }
        }];
    }];
}

@end
