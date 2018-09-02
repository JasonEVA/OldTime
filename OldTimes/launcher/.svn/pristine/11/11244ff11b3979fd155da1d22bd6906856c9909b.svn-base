//
//  TaskWithSegmentTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskWithSegmentTableViewCell.h"
#import "TaskSegmentWithButtonView.h"
#import "Category.h"
#import "Masonry.h"

@interface TaskWithSegmentTableViewCell ()

@property (nonatomic, strong) TaskSegmentWithButtonView *segment;

@property (nonatomic, copy) TaskWithSegmentBlock selectBlock;

@end

@implementation TaskWithSegmentTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.segment];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.segment.mas_left);
        }];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Interface Method
- (void)segmentDidSelect:(TaskWithSegmentBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)setCurrentSelectPriority:(MissionTaskPriority)priority {
    self.segment.selectedIndex = priority;
}

#pragma mark - Button Click
- (void)clickToSelect:(TaskSegmentWithButtonView *)segment {
    if (self.selectBlock) {
        self.selectBlock(segment.selectedIndex);
    }
}

#pragma mark - Initializer
- (TaskSegmentWithButtonView *)segment
{
    if (!_segment)
    {
        _segment = [[TaskSegmentWithButtonView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 140, 8, 120, 30)];
        [_segment addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont mtc_font_30];
    }
    return _lblTitle;
}
@end
