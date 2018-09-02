//
//  NewTaskWithSegmentTableViewCell.m
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewTaskWithSegmentTableViewCell.h"
#import "NewTaskSegmentWithButtonView.h"
#import "Category.h"
#import "Masonry.h"
#import "UIFont+Util.h"

@interface NewTaskWithSegmentTableViewCell ()

@property (nonatomic, strong) NewTaskSegmentWithButtonView *segment;

@property (nonatomic, copy) NewTaskWithSegmentBlock selectBlock;

@end

@implementation NewTaskWithSegmentTableViewCell

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
        
        [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@245);
            make.centerY.equalTo(self);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Interface Method
- (void)segmentDidSelect:(NewTaskWithSegmentBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)setCurrentSelectPriority:(MissionTaskPriority)priority {
    self.segment.selectedIndex = priority;
}

#pragma mark - Button Click
- (void)clickToSelect:(NewTaskSegmentWithButtonView *)segment {
    if (self.selectBlock) {
        self.selectBlock(segment.selectedIndex);
    }
}

#pragma mark - Initializer
- (NewTaskSegmentWithButtonView *)segment
{
    if (!_segment)
    {
        _segment = [[NewTaskSegmentWithButtonView alloc] init];
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
        _lblTitle.font = [UIFont mtc_font_28];
    }
    return _lblTitle;
}
@end
