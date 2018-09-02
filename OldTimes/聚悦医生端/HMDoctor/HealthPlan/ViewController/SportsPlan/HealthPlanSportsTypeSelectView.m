//
//  HealthPlanSportsTypeSelectView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportsTypeSelectView.h"

@interface HealthPlanSportsButton : UIButton

@property (nonatomic, strong) UIImageView* iconImageView;

- (id) initWithSportsType:(HealthSportTypeModel*) model;
@end

@implementation HealthPlanSportsButton

- (id) initWithSportsType:(HealthSportTypeModel*) model
{
    self = [super init];
    if (self) {
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 3.5;
        self.layer.masksToBounds = YES;
        
        [self setTitle:model.sportsName forState:UIControlStateNormal];
        [self setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

- (UIImageView*) iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

@end

@interface HealthPlanSelectedSportsTypeButton : HealthPlanSportsButton

@end

@implementation HealthPlanSelectedSportsTypeButton

- (id) initWithSportsType:(HealthSportTypeModel*) model
{
    self = [super initWithSportsType:model];
    if (self) {
        [self.iconImageView setImage:[UIImage imageNamed:@"healthplan_close"]];
    }
    return self;
}

@end

@interface HealthPlanUnSelectedSportsTypeButton : HealthPlanSportsButton

@end

@implementation HealthPlanUnSelectedSportsTypeButton

- (id) initWithSportsType:(HealthSportTypeModel*) model
{
    self = [super initWithSportsType:model];
    if (self) {
        [self.iconImageView setImage:[UIImage imageNamed:@"concern_add"]];
    }
    return self;
}

@end

@interface HealthPlanSportsTypeSelectView ()
{
    NSMutableArray* buttons;
}

@property (nonatomic, strong) NSMutableArray* unselectedSportsTyes;

@end

@implementation HealthPlanSportsTypeSelectView

- (id) init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        buttons = [NSMutableArray array];
        
    }
    return self;
}

- (void) setSelectedSportsTypes:(NSArray*) selectedSportsTyes
           unselectedSportsTyes:(NSArray*) unselectedSportsTyes
{
    _selectedSportsTyes = [NSMutableArray arrayWithArray:selectedSportsTyes];
    _unselectedSportsTyes = [NSMutableArray arrayWithArray:unselectedSportsTyes];
    
    [self createTypesButtons];
}

- (void) createTypesButtons
{
    [buttons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button removeFromSuperview];
    }];
    [buttons removeAllObjects];
    
    [self.selectedSportsTyes enumerateObjectsUsingBlock:^(HealthSportTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthPlanSelectedSportsTypeButton* button = [[HealthPlanSelectedSportsTypeButton alloc] initWithSportsType:model];
        [self addSubview:button];
        [button addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }];
    
    [self.unselectedSportsTyes enumerateObjectsUsingBlock:^(HealthSportTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthPlanUnSelectedSportsTypeButton* button = [[HealthPlanUnSelectedSportsTypeButton alloc] initWithSportsType:model];
        [self addSubview:button];
        [button addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }];
    
    [self layoutButtons];
}

- (void) layoutButtons
{
    [buttons enumerateObjectsUsingBlock:^(UIButton* cell, NSUInteger idx, BOOL * _Nonnull stop) {
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
                    UIButton* perCell = buttons[idx - 1];
                    make.top.equalTo(perCell.mas_bottom).offset(10);
                }
            }
            else
            {
                UIButton* perCell = buttons[idx - 1];
                make.left.equalTo(perCell.mas_right).offset(10);
                
                make.top.equalTo(perCell);
            }
            
            
            
            if (cell == buttons.lastObject) {
                make.bottom.equalTo(self).offset(-12.5);
            }
        }];
    }];

}

- (void) typeButtonClicked:(id) sender
{
    NSInteger typeIndex = [buttons indexOfObject:sender];
    if (typeIndex == NSNotFound) {
        return;
    }
    
    if (typeIndex < self.selectedSportsTyes.count) {
        if (self.selectedSportsTyes.count <= 1) {
            [self showAlertMessage:@"只是需要一个推荐运动。"];
            return;
        }
        //删除一个已选的运动
    
        HealthSportTypeModel* model = self.selectedSportsTyes[typeIndex];
        [self.selectedSportsTyes removeObject:model];
        [self.unselectedSportsTyes addObject:model];
    }
    else
    {
        typeIndex -= self.selectedSportsTyes.count;
        
        HealthSportTypeModel* model = self.unselectedSportsTyes[typeIndex];
        [self.unselectedSportsTyes removeObject:model];
        [self.selectedSportsTyes addObject:model];
    }
    
    [self createTypesButtons];
}

@end
