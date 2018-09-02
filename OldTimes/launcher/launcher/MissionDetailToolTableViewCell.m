//
//  MissionDetailToolTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailToolTableViewCell.h"
#import "UnifiedUserInfoManager.h"
#import "MissionDetailModel.h"
#import "Category.h"
#import "Masonry.h"

@interface MissionDetailToolTableViewCell ()

@property (nonatomic, strong) NSArray *arrayButtons;
@property (nonatomic, strong) NSMutableArray *arraySeperator;

@property (nonatomic, copy) void (^clickBlock)(NSUInteger);

@property (nonatomic, readonly) MissionDetailModel *detailModel;

@end

@implementation MissionDetailToolTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}
+ (CGFloat)heightFromDetail:(MissionDetailModel *)detailModel {
    NSString *userShowId = [[UnifiedUserInfoManager share] userShowID];
    BOOL showAll = [detailModel.createrUser isEqualToString:userShowId];
    BOOL showTwo = [[detailModel.arrayUser firstObject] isEqualToString:userShowId];
    
    if (showAll || showTwo) {
        return 45.0;
    }
    
    return 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        for (UIButton *button in self.arrayButtons) {
            [self.contentView addSubview:button];
        }
        
        [self getButtonsAtIndex:0].hidden = YES;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    UIButton *editButton = [self getButtonsAtIndex:1];
    UIButton *deleteButton = [self getButtonsAtIndex:2];
    
    [editButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        if (!deleteButton.hidden) {
            make.right.equalTo(self.contentView).dividedBy(2);
        }
        else {
            make.right.equalTo(self.contentView);
        }
    }];
    
    [deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        if (!editButton.hidden) {
            make.left.equalTo(self.contentView.mas_right).dividedBy(2);
        }
    }];
    
    for (NSInteger i = 0 ; i < [self.arraySeperator count]; i ++) {
        UIView *seperatorLine = [self.arraySeperator objectAtIndex:i];
        [seperatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self.contentView);
            make.width.equalTo(@0.5);
            make.right.equalTo(self.contentView).multipliedBy(((i + 1.0) / ([self.arraySeperator count] + 1)));
        }];
    }
}

- (void)addSeparator {
    UIView *seperatorLine = [UIView new];
    seperatorLine.backgroundColor = [UIColor borderColor];
    [self.contentView addSubview:seperatorLine];
    
    [self.arraySeperator addObject:seperatorLine];
}

#pragma mark - Interface Method
- (void)clickButtonAtIndex:(void (^)(NSUInteger))clickIndexBlock {
    self.clickBlock = clickIndexBlock;
}

- (void)setMissionDetail:(MissionDetailModel *)detailModel {
    _detailModel = detailModel;
    
    for (UIView *seperatorLine in self.arraySeperator) {
        [seperatorLine removeFromSuperview];
    }
    [self.arraySeperator removeAllObjects];
    
    if ([_detailModel.createrUser isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
        [self addSeparator];
        [self getButtonsAtIndex:1].hidden = NO;
        [self getButtonsAtIndex:2].hidden = NO;
    }
    
    else if ([[_detailModel.arrayUser firstObject] isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
        [self getButtonsAtIndex:1].hidden = NO;
        [self getButtonsAtIndex:2].hidden = YES;
    }
    else {
        [self getButtonsAtIndex:1].hidden = YES;
        [self getButtonsAtIndex:2].hidden = YES;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Private Method
- (UIButton *)getButtonsAtIndex:(NSInteger)index {
    return [self.arrayButtons objectAtIndex:index];
}

#pragma mark - Button Click
- (void)clickToSelect:(UIButton *)button {
    if (self.clickBlock) {
        self.clickBlock(button.tag);
    }
}

#pragma mark - Create
- (UIButton *)buttonWithImageName:(NSString *)imageName index:(NSUInteger)index {
    UIButton *button = [UIButton new];
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
    
    button.tintColor = [UIColor themeBlue];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    
    return button;
}

#pragma mark -  Initializer
- (NSArray *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = @[[self buttonWithImageName:@"share" index:0],
                          [self buttonWithImageName:@"pencil" index:1],
                          [self buttonWithImageName:@"trash_bigger" index:2]];
    }
    return _arrayButtons;
}

- (NSMutableArray *)arraySeperator {
    if (!_arraySeperator) {
        _arraySeperator = [NSMutableArray array];
    }
    return _arraySeperator;
}

@end
