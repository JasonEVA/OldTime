//
//  IntegralStartOperateView.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralStartOperateView.h"

@interface IntegralStartOperateCell : UIButton

@property (nonatomic, strong) UIImageView* notOpenedImageView;

- (void) showNotOpen:(BOOL) notOpen;
@end

@implementation IntegralStartOperateCell

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = CGRectMake((contentRect.size.width - 24)/2, 15, 24, 24);
    return imageRect;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = CGRectMake(0, 49, contentRect.size.width, 24);
    return titleRect;
}

- (UIImageView*) notOpenedImageView
{
    if (!_notOpenedImageView) {
        _notOpenedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_wkt"]];
        [self addSubview:_notOpenedImageView];
        [_notOpenedImageView setHidden:YES];
        
        [_notOpenedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
        }];
    }
    return _notOpenedImageView;
}

- (void) showNotOpen:(BOOL) notOpen
{
    [self.notOpenedImageView setHidden:!notOpen];
}

@end

@interface IntegralStartOperateView ()

@property (nonatomic, readonly) NSArray* operateCells;
@end

@implementation IntegralStartOperateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        [self createOperateCells];
    }
    return self;
}

- (void) createOperateCells
{
    NSMutableArray* cells = [NSMutableArray array];
    NSArray* imageNames = @[@"integral_rule_icon", @"integral_strategy_icon", @"integral_mall_icon"];
    NSArray* titles = @[@"会员等级说明", @"积分攻略", @"积分商城"];
    [imageNames enumerateObjectsUsingBlock:^(NSString* imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        IntegralStartOperateCell* cell = [IntegralStartOperateCell buttonWithType:UIButtonTypeCustom];
        [self addSubview:cell];
        [cells addObject:cell];
        
        if (imageName != [imageNames firstObject])
        {
            UIView* lineView = [[UIView alloc] init];
            [cell addSubview:lineView];
            [lineView setBackgroundColor:[UIColor commonControlBorderColor]];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell);
                make.top.equalTo(cell).with.offset(15);
                make.bottom.equalTo(cell).with.offset(-15);
                make.width.mas_equalTo(@1);
            }];
        }
        
        [cell setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [cell setTitle:titles[idx] forState:UIControlStateNormal];
        [cell setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [cell.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cell addTarget:self action:@selector(operateCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell showNotOpen:(idx == IntegralStartOperate_Mall)];
        
        [self addSubview:cell];
    }];
    
    _operateCells = cells;
    
    [self layoutCells];
}

- (void) layoutCells
{
    [self.operateCells enumerateObjectsUsingBlock:^(IntegralStartOperateCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            
            if (cell == [self.operateCells firstObject])
            {
                make.left.equalTo(self).with.offset(5);
            }
            else
            {
                IntegralStartOperateCell* perCell = self.operateCells[idx - 1];
                make.left.equalTo(perCell.mas_right);
                make.width.equalTo(perCell);
            }
            
            if (cell == self.operateCells.lastObject) {
                make.right.equalTo(self).with.offset(-5);
            }
        }];
    }];
}



- (void) operateCellClicked:(id) sender
{
    NSInteger index = [self.operateCells indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
//    if (index == IntegralStartOperate_Mall) {
//        return;
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(operateButtonClicked:)])
    {
        [_delegate operateButtonClicked:index];
    }
}

@end
