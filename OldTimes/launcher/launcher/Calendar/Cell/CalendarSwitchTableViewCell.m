//
//  CalendarSwitchTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarSwitchTableViewCell.h"
#import "MyDefine.h"
#import "Category.h"
#import "UIColor+Hex.h"

@interface CalendarSwitchTableViewCell ()

@property (nonatomic, strong) UISwitch *cSwitch;

@property (nonatomic, copy) CalendarSwitchDidChangeBlock didChangeBlock;

@end

@implementation CalendarSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryView = self.cSwitch;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self textLabel].font = [UIFont mtc_font_30];
        [self textLabel].textColor = [UIColor mtc_colorWithHex:0x666666];
    }
    return self;
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

#pragma mark - Button Click
- (void)clickToSwitch {
    if (self.didChangeBlock) {
        self.didChangeBlock(self.switchType, self.cSwitch.isOn);
    }
}

#pragma mark - Setter
- (void)setSwitchColor:(UIColor *)switchColor {
    self.cSwitch.onTintColor = switchColor;
}

- (void)calendarSwitchDidChange:(CalendarSwitchDidChangeBlock)block {
    self.didChangeBlock = block;
}

- (void)isOn:(BOOL)isOn {
    [self.cSwitch setOn:isOn];
}

#pragma mark - Initializer
- (UISwitch *)cSwitch {
    if (!_cSwitch) {
        _cSwitch = [[UISwitch alloc] init];
        [_cSwitch addTarget:self action:@selector(clickToSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _cSwitch;
}

@end
