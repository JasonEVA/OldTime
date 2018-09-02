//
//  ApplyDetail_ReviewTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyDetail_ReviewTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIButton+DeterReClicked.h"
#import "MyDefine.h"

@interface ApplyDetail_ReviewTableViewCell ()

@property(nonatomic, strong) UIButton  *transferBtn;

@property(nonatomic, strong) UIButton  *unAcceptBtn;

@property(nonatomic, strong) UIButton  *acceptBtn;

@property (nonatomic, assign) FROMTYPE type;

@property (nonatomic, strong) NSMutableArray *arraySeperator;

@end

@implementation ApplyDetail_ReviewTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.transferBtn];
        [self.contentView addSubview:self.unAcceptBtn];
        [self.contentView addSubview:self.acceptBtn];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.type == kFromReciver) {
        [self.transferBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.top.bottom.equalTo(@[self.unAcceptBtn,self.acceptBtn]);
        }];
        
        [self.unAcceptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.transferBtn.mas_right);
        }];
        
        [self.acceptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.unAcceptBtn.mas_right);
            make.right.equalTo(self.contentView);
        }];
    }
    
    else {
        [self.unAcceptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.contentView);
            make.width.equalTo(self.acceptBtn);
        }];
        [self.acceptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.unAcceptBtn.mas_right);
            make.right.top.bottom.equalTo(self.contentView);
        }];
    }
}

#pragma mark - interface method
- (void)setIconWithType:(FROMTYPE)fromType
{
    for (UIView *seperatorLine in self.arraySeperator) {
        [seperatorLine removeFromSuperview];
    }
    
    [self.arraySeperator removeAllObjects];
    
    _type = fromType;
    switch (fromType) {
        case kFromReciver:
        {
            self.transferBtn.hidden = NO;
            [self setUpBtnWith:LOCAL(APPLY_SENDER_BACKWARD_TITLE) btn:self.transferBtn imageName:@"backward-gray"];
            [self setUpBtnWith:LOCAL(APPLY_SENDER_UNACCEPT_TITLE) btn:self.unAcceptBtn imageName:@"X_gray"];
            [self setUpBtnWith:LOCAL(APPLY_SENDER_ACCEPT_TITLE) btn:self.acceptBtn imageName:@"Accept"];

            [self addSeparatorLine:2];
        }
            break;
        case kFromSender:
        {
            self.transferBtn.hidden = YES;
            [self.transferBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            [self.unAcceptBtn setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
            [self.acceptBtn setImage:[UIImage imageNamed:@"trash_black"] forState:UIControlStateNormal];
            
            [self addSeparatorLine:1];
        }
            break;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


#pragma mark - private method
- (void)setUpBtnWith:(NSString *)title btn:(UIButton *)btn imageName:(NSString *)imageName
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
}

- (void)addSeparatorLine:(NSInteger)numberOfLines
{
    for (NSInteger index = 0; index < numberOfLines; index++) {
        CGFloat itemWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / (numberOfLines + 1.0);
      
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (index + 1), 0, 0.5, CGRectGetHeight(self.contentView.frame))];
        view.backgroundColor = [UIColor minorFontColor];
        
        [self.contentView addSubview:view];
    }
}

- (void)btnClick:(UIButton *)btn
{
    //按钮暴力点击防御
    [self.transferBtn mtc_deterClickedRepeatedly];
    [self.unAcceptBtn mtc_deterClickedRepeatedly];
    [self.acceptBtn mtc_deterClickedRepeatedly];
    
    if ([self.delegate respondsToSelector:@selector(ApplyDetail_ReviewTableViewCellPassTheBtn:)])
    {
        [self.delegate ApplyDetail_ReviewTableViewCellPassTheBtn:btn];
    }
}

#pragma mark -  initilizer
- (UIButton *)transferBtn
{
    if (!_transferBtn)
    {
        _transferBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_transferBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _transferBtn.tag = 1;
    }
    return _transferBtn;
}

- (UIButton *)unAcceptBtn
{
    if (!_unAcceptBtn)
    {
        _unAcceptBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_unAcceptBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _unAcceptBtn.tag = 2;
    }
    return _unAcceptBtn;
}

- (UIButton *)acceptBtn
{
    if (!_acceptBtn)
    {
        _acceptBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_acceptBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _acceptBtn.tag = 3;
    }
    return _acceptBtn;
}

- (NSMutableArray *)arraySeperator {
    if (!_arraySeperator) {
        _arraySeperator = [NSMutableArray array];
    }
    return _arraySeperator;
}

@end

