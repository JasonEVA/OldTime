//
//  ASDatePicker.m
//  AnimationDemo
//
//  Created by Andrew Shen on 2017/1/5.
//  Copyright © 2017年 AndrewShen. All rights reserved.
//

#import "ASDatePicker.h"
#import <Masonry/Masonry.h>
@interface ASDatePicker ()
@property (nonatomic)  BOOL  showToolbar; // <##>
@property (nonatomic, strong)  UIToolbar  *toolBar; // <##>
@property (nonatomic, strong)  UIDatePicker  *datePicker; // <##>
@property (nonatomic, copy)  ASDatePickerCompletionHandler  completion; // <##>
@end
@implementation ASDatePicker

#pragma mark - Override

- (instancetype)initWithToolbar:(BOOL)showToolbar
{
    self = [super init];
    if (self) {
        _showToolbar = showToolbar;
        [self p_configElements];
    }
    return self;
}


//- (instancetype)init
//{
//    return [self initWithToolbar:YES];
//}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self p_configElements];
//    }
//    return self;
//}

#pragma mark - Interface Method

- (void)addDatePickerCompletionNoti:(ASDatePickerCompletionHandler)handler {
    self.completion = handler;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    [self.datePicker setDate:date animated:animated];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    [self.datePicker setMinimumDate:minimumDate];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    [self.datePicker setMaximumDate:maximumDate];
}

- (NSDate *)minimumDate {
    return self.datePicker.minimumDate;
}

- (NSDate *)maximumDate {
    return self.datePicker.maximumDate;
}
#pragma mark - Private Method

- (void)p_configElements {
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.toolBar.mas_bottom);
        make.height.mas_equalTo(216);
    }];
}
#pragma mark - Event Response

- (void)p_cancelItemAction {
    if (self.completion) {
        self.completion(NO, nil);
    }
}

- (void)p_confirmItemAction {
    if (self.completion) {
        self.completion(YES, self.datePicker.date);
    }
}

- (void)p_dateChanged:(UIDatePicker *)picker {
    if (self.showToolbar) {
        return;
    }
    if (self.completion) {
        self.completion(YES, picker.date);
    }
}
#pragma mark - Delegate


#pragma mark - Init

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(p_cancelItemAction)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(p_confirmItemAction)];
        _toolBar.items = @[cancelItem, flexibleSpace, confirmItem];
    }
    return _toolBar;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(p_dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
@end
