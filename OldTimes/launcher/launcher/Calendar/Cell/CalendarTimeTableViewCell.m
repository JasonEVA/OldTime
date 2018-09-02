//
//  CalendarTimeTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarTimeTableViewCell.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface CalendarTimeTableViewCell ()

@property (nonatomic, strong) UILabel *lbTitle;

// Data
/** 时间数组 */
@property (nonatomic, strong) NSMutableArray *arrayTime;
/** 是否是全天模式 */
@property (nonatomic, assign) BOOL wholeDayMode;

@end

@implementation CalendarTimeTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UIImage *imageDisclosureIndicator       = [UIImage imageNamed:@"disclosureIndicator"];
//        UIImageView *imgViewDisclosureIndicator = [[UIImageView alloc] initWithImage:imageDisclosureIndicator];
//        self.accessoryView = imgViewDisclosureIndicator;
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self.contentView addSubview:self.lbTitle];
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        NSInteger s;
        if ([[UIScreen mainScreen] scale] == 3)
        {
            s = 18;
        }
        else
        {
            s = 15;
        }
        make.left.equalTo(self.contentView).offset(s);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - Interface Method
- (void)setTitle:(NSString *)title {
    self.lbTitle.text = title;
}

/** 设置时间，timeArray中成双成对出现 */
- (void)setStandByTime:(NSArray *)timeArray wholeDayMode:(BOOL)isWholeDay {
    // 先清除已有时间
    for (UILabel *label in self.arrayTime) {
        [label removeFromSuperview];
    }
    
    [self.arrayTime removeAllObjects];
    
    self.wholeDayMode = isWholeDay;
    // 加入时间
    for (NSInteger i = 0; i < timeArray.count; i += 2) {
        UILabel *label = [self createLableOfIndex:(i / 2) + 1 startTime:timeArray[i] endTime:timeArray[i + 1] onlyOne:[timeArray count] == 2];
        [self.contentView addSubview:label];
        [self.arrayTime addObject:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbTitle.mas_right).offset(30);
            make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        }];
        
        if (i == 0) {
            // 第一条，上中2个位置变换
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (timeArray.count == 2) {
                    // 中点
                    make.centerY.equalTo(self.contentView);
                } else {
                    // 上面
                    make.top.equalTo(self.contentView).offset(10);
                }
            }];
        }
        
        else if (i == 2) {
            // 第二条,中下2个位置
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (timeArray.count == 4) {
                    // 下
                    make.bottom.equalTo(self.contentView).offset(-10);
                } else {
                    make.centerY.equalTo(self.contentView);
                }
            }];
        }
        else {
            // 下位置
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }
}

#pragma mark - Private Method
/** 组数与时间 */
- (UILabel *)createLableOfIndex:(NSInteger)index startTime:(NSDate *)startTime endTime:(NSDate *)endTime onlyOne:(BOOL)onlyOne {
    UILabel *label = [[UILabel alloc] init];
    
    // 候补1（前缀）
    NSString *prefix = [NSString stringWithFormat:@"%@%ld ", LOCAL(CALENDAR_CONFIRM_ALTERNATE), index];
    if (onlyOne) {
        prefix = [NSString stringWithFormat:@"%@ ",LOCAL(CALENDAR_TIME)];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", prefix, [startTime mtc_startToEndDate:endTime wholeDay:self.wholeDayMode]];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor mediumFontColor],NSFontAttributeName:[UIFont mtc_font_26]}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(prefix.length, str.length - prefix.length)];
    
    label.attributedText = attrStr;
    [label setAdjustsFontSizeToFitWidth:YES];
    return label;
}

#pragma mark - Initializer
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.font = [UIFont mtc_font_30];
        _lbTitle.textColor = [UIColor mtc_colorWithHex:0x666666];
        _lbTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _lbTitle;
}

- (NSMutableArray *)arrayTime {
    if (!_arrayTime) {
        _arrayTime = [NSMutableArray array];
    }
    return _arrayTime;
}

@end
