//
//  BaseToolBarTextField.m
//  Shape
//
//  Created by Andrew Shen on 15/10/28.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseToolBarTextField.h"

@interface BaseToolBarTextField()

@end

@implementation BaseToolBarTextField

- (instancetype)initWithToolBar:(BOOL)hasToolBar backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment tag:(NSInteger)tag text:(NSString *)text inputView:(id)inputView
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:backgroundColor];
        [self setTextAlignment:alignment];
        [self setTextColor:textColor];
        [self setInputView:inputView];
        [self setText:text];
        self.tag = tag;
        if (hasToolBar) {
            [self setInputAccessoryView:self.toolBar];
            self.toolBar.tag = tag;
        }
    }
    return self;
}
// 设置toolbartitle
- (void)setToolBarTitle:(NSString *)toolBarTitle {
    [self.toolBar setMyTitel:toolBarTitle];
}

- (void)setToolBarDeletate:(id<MyToolBarDelegate>)toolBarDeletate {
    self.toolBar.MyDelegate = toolBarDeletate;
}

- (MyToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[MyToolBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    }
    return _toolBar;
}

@end
