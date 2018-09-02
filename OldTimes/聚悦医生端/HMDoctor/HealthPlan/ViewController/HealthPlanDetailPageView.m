//
//  HealthPlanDetailPageView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/31.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanDetailPageView.h"

@interface HealthPlanDetailPagePointCell : UIView

@property (nonatomic, strong) UIView* pointView;
@property (nonatomic, strong) UIView* flagView;

@property (nonatomic, assign) BOOL isShown;

@end

@implementation HealthPlanDetailPagePointCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1.5);
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.pointView.mas_bottom).offset(3.5);
    }];
}


#pragma mark settingAndGetting
- (UIView*) pointView
{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        [self addSubview:_pointView];
        
        _pointView.layer.cornerRadius = 2.5;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

- (UIView*) flagView
{
    if (!_flagView) {
        _flagView = [[UIView alloc] init];
        [self addSubview:_flagView];
        [_flagView setBackgroundColor:[UIColor mainThemeColor]];
        [_flagView setHidden:YES];
    }
    return _flagView;
}

- (void) setIsShown:(BOOL)isShown
{
    if (isShown) {
        [self.pointView setBackgroundColor:[UIColor mainThemeColor]];
    }
    else
    {
        [self.pointView setBackgroundColor:[UIColor commonGrayTextColor]];
    }
}
@end

@interface HealthPlanDetailPagePointView : UIView
{
    NSInteger pageCount;
    NSMutableArray* pointCells;
}

- (void) setPageCount:(NSInteger) count;
- (void) setCurrentPage:(NSInteger) index;

- (void) setPage:(NSInteger) page isValid:(BOOL) valid;
@end

@implementation HealthPlanDetailPagePointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) setPageCount:(NSInteger) count
{
    pageCount = count;
    [self createPageCells];
}

- (void) createPageCells
{
    pointCells = [NSMutableArray array];
    for (NSInteger index = 0; index < pageCount; ++index)
    {
        HealthPlanDetailPagePointCell* cell = [[HealthPlanDetailPagePointCell alloc] init];
        [pointCells addObject:cell];
        [self addSubview:cell];
    }
    
    [pointCells enumerateObjectsUsingBlock:^(HealthPlanDetailPagePointCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 15));
            make.top.equalTo(self);
            
            if (cell == pointCells.firstObject) {
                make.left.equalTo(self);
            }
            else
            {
                HealthPlanDetailPagePointCell* perCell = pointCells[idx - 1];
                make.width.equalTo(perCell);
                make.left.equalTo(perCell.mas_right).offset(5);
            }
            if (cell == pointCells.lastObject) {
                make.right.equalTo(self);
            }
            
            [cell setIsShown:NO];
        }];
        
        
    }];
}

- (void) setCurrentPage:(NSInteger) index
{
    [pointCells enumerateObjectsUsingBlock:^(HealthPlanDetailPagePointCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setIsShown:(idx == index)];
    }];
}

- (void) setPage:(NSInteger) page isValid:(BOOL) valid
{
    if (!pointCells || pointCells.count == 0) {
        return;
    }
    if (page < 0 || page >= pointCells.count) {
        return;
    }
    HealthPlanDetailPagePointCell* cell = pointCells[page];
    [cell.flagView setHidden:valid];
}
@end

@interface HealthPlanDetailPageTitleView : UIView

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* titleLabel;



- (void) setHealthPlanDetailSectionModel:(HealthPlanDetailSectionModel*) model;
@end

@implementation HealthPlanDetailPageTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.height.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self.imageView.mas_right).offset(8);
    }];
}

- (void) setHealthPlanDetailSectionModel:(HealthPlanDetailSectionModel*) model
{
    [self.titleLabel setText:model.title];
    NSString* imageName = [NSString stringWithFormat:@"icon_healthplan_%@", model.code];
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark - settingAndGetting
- (UIImageView*) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
    }
    return _titleLabel;
}

@end

@interface HealthPlanDetailPageView ()

@property (nonatomic, strong) HealthPlanDetailPageTitleView* titleView;
@property (nonatomic, strong) HealthPlanDetailPagePointView* pointView;


@end

@implementation HealthPlanDetailPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(5);
    }];
    

}

- (void) setHealthPlanDetailSectionModel:(HealthPlanDetailSectionModel*) model
{
    [self.titleView setHealthPlanDetailSectionModel:model];
}

- (void) setPageCount:(NSInteger) count
{
    [self.pointView setPageCount:count];
}

- (void) setCurrentPage:(NSInteger) index
{
    [self.pointView setCurrentPage:index];
}

- (void) setPage:(NSInteger) page isValid:(BOOL) valid
{
    [self.pointView setPage:page isValid:valid];
}
#pragma mark - settingAndGetting
- (HealthPlanDetailPageTitleView*) titleView
{
    if (!_titleView) {
        _titleView = [[HealthPlanDetailPageTitleView alloc] init];
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (HealthPlanDetailPagePointView*) pointView
{
    if (!_pointView) {
        _pointView = [[HealthPlanDetailPagePointView alloc] init];
        [self addSubview:_pointView];
    }
    return _pointView;
}

@end
