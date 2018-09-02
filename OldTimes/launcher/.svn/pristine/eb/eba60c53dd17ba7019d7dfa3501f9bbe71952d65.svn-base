//
//  MeetingAddNewMenberTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingAddNewMenberTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"

static CGFloat defaultHeight = 80;

@interface MeetingAddNewMenberTableViewCell()

@property (nonatomic, strong) UILabel *myDetailLabel;   //人名label

@property (nonatomic, strong) UILabel *moreLabel;

@end

@implementation MeetingAddNewMenberTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]); }

+ (CGFloat)heightFromArrayString:(NSArray *)strings
                        showMore:(BOOL)showMore
               accessoryTypeMode:(BOOL)accessoryTypeMode
{
    NSString *string = [strings componentsJoinedByString:@"、"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"\u00a0"];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    // 80 15 15对应initStyle中各个label的位置
    CGFloat maxWitdh = screenWidth - 80 - 15 - 15 - 10 - (accessoryTypeMode ? 30 : 0);
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWitdh, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    
    CGFloat calculatedHeight = ceil(size.height) + 22;
    if (calculatedHeight < defaultHeight) {
        if (calculatedHeight < 45) {
            return 45;
        }
        return calculatedHeight;
    }
    
    return showMore ? (defaultHeight + 30) : calculatedHeight;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;

        [self.contentView addSubview:self.myDetailLabel];
        [self.contentView addSubview:self.myTextLabel];
        [self.contentView addSubview:self.moreLabel];
        
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(80);
        }];
        
        [self.myDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myTextLabel.mas_right).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        //6+ 上更多显示有问题
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myDetailLabel.mas_bottom);
            make.left.equalTo(self.myDetailLabel);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

#pragma mark - Interface Methods
- (void)dataWithStrings:(NSArray *)strings showMore:(BOOL)showMore {
    
    NSString *string = [strings componentsJoinedByString:@"、"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"\u00a0"];
    [self.myDetailLabel setText:string];
    
    if (!showMore) {
        self.moreLabel.hidden = YES;
    }
    else {
        self.moreLabel.hidden = [self showMoreIfNeedWithString:string];
    }
    
    self.moreLabel.text = self.moreLabel.hidden ? @"" : LOCAL(APPLY_MORE);
}

#pragma mark - Private Method 
- (BOOL)showMoreIfNeedWithString:(NSString *)string {

    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    // 80 15 15对应initStyle中各个label的位置
    CGFloat maxWitdh = screenWidth - 80 - 15 - 15 - 10 - (self.accessoryType != UITableViewCellAccessoryNone ? 30 : 0);
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWitdh, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    
    CGFloat calculatedHeight = ceil(size.height);
    return calculatedHeight < defaultHeight;
}

#pragma mark - Initializer
@synthesize myTextLabel = _myTextLabel;
- (UILabel *)myTextLabel
{
    if (!_myTextLabel) {
        _myTextLabel = [[UILabel alloc] init];
        _myTextLabel.textColor = [UIColor blackColor];
        _myTextLabel.font = [UIFont mtc_font_30];
    }
    return _myTextLabel;
}

- (UILabel *)myDetailLabel
{
    if (!_myDetailLabel) {
        _myDetailLabel = [[UILabel alloc] init];
        _myDetailLabel.font = [UIFont mtc_font_30];
        _myDetailLabel.textColor = [UIColor minorFontColor];
        [_myDetailLabel setNumberOfLines:0];
        _myDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _myDetailLabel;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [UILabel new];
        _moreLabel.textColor = [UIColor mtc_colorWithHex:0x2e9efb];
        _moreLabel.text = LOCAL(APPLY_MORE);
        _moreLabel.font = [UIFont mtc_font_30];
        _moreLabel.hidden = YES;
        [_moreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _moreLabel;
}

@end
