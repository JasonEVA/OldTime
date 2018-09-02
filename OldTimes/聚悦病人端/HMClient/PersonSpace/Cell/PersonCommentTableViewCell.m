//
//  PersonCommentTableViewCell.m
//  HMClient
//
//  Created by Dee on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用户评价cell

#import "PersonCommentTableViewCell.h"

@interface PersonCommentTableViewCell ()

@property(nonatomic, strong) UILabel  *commentStarLabel;

@property(nonatomic, strong) NSMutableArray  *starBtnArray;

@property(nonatomic, copy)  commentStarCountCallBackBlock myBlock;

@end

@implementation PersonCommentTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.contentView addSubview:self.commentStarLabel];
    [self.commentStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    for (int i = 0; i< 5; i ++)
    {
        UIButton *btn = self.starBtnArray[i];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentStarLabel.mas_right).offset(20 + i *25);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@20);
        }];
    }
}

#pragma mark - interFaceMethod
- (void)getStarCountWithBlock:(commentStarCountCallBackBlock)block
{
    self.myBlock = block;
}

#pragma mark - eventRespond
- (void)touchAction:(UIButton *)sender
{
    sender.selected ^= 1;

    for (UIButton *btn in self.starBtnArray)
    {
        if (btn.tag <= sender.tag)
        {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }
    if (self.myBlock)
    {
        self.myBlock(sender.tag + 1);
    }
}

#pragma mark - setterAndGetter
- (UILabel *)commentStarLabel
{
    if (!_commentStarLabel) {
        _commentStarLabel =[[UILabel alloc] init];
        _commentStarLabel.text = @"评分: ";
        
    }
    return _commentStarLabel;
}

- (NSMutableArray *)starBtnArray
{
    if (!_starBtnArray)
    {
        _starBtnArray  = [NSMutableArray array];
        for (int i = 0; i< 5 ; i++)
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"person_start_icon"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"person_evalue_unselected"] forState:UIControlStateNormal];
            [_starBtnArray  addObject:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _starBtnArray;
}
@end
