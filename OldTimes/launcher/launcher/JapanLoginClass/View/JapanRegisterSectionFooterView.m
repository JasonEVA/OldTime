//
//  JapanRegisterSectionFooterView.m
//  launcher
//
//  Created by williamzhang on 16/4/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanRegisterSectionFooterView.h"
#import "TTTAttributedLabel.h"
#import <SVWebViewController/SVWebViewController.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface JapanPerLineView : UIView

@property (nonatomic, strong) UIButton           *button;
@property (nonatomic, strong) TTTAttributedLabel *label;

@end

@interface JapanRegisterSectionFooterView () <TTTAttributedLabelDelegate>

@property (nonatomic, copy) void (^changeBlock)(NSUInteger, BOOL);

@end

@implementation JapanRegisterSectionFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        JapanPerLineView *line1 = [[JapanPerLineView alloc] init];
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:LOCAL(REGISTER_TERM1) attributes:@{NSFontAttributeName:[UIFont mtc_font_28]}];
        NSRange protocolRange = [attributeString.string rangeOfString:LOCAL(REGISTER_TERM1_SUB1)];
        [attributeString addAttributes:@{NSLinkAttributeName:@"https://www.workhub.jp/terms"} range:protocolRange];
        
        NSRange privacyRange = [attributeString.string rangeOfString:LOCAL(REGISTER_TERM1_SUB2)];
        [attributeString addAttributes:@{NSLinkAttributeName:@"https://www.workhub.jp/privacy"} range:privacyRange];
        
        line1.label.linkAttributes = @{NSForegroundColorAttributeName:[UIColor themeBlue], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        line1.label.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor themeBlue]};
        line1.label.text = attributeString;
        line1.label.delegate = self;
        
        [line1.button addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
        line1.tag = 0;
        
        JapanPerLineView *line2 = [[JapanPerLineView alloc] init];
        line2.label.text = LOCAL(REGISTER_TERM2);
        [line2.button addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
        line2.tag = 1;
        
        [self addSubview:line1];
        [self addSubview:line2];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(24);
        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom).offset(24);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-24);
        }];
    }
    return self;
}

- (void)changeBlock:(void (^)(NSUInteger, BOOL))changeSelectBlock {
    self.changeBlock = changeSelectBlock;
}

#pragma mark - Button Click
- (void)clickToSelect:(UIButton *)button {
    button.selected ^= 1;
    !self.changeBlock ?: self.changeBlock(button.tag, button.selected);
}

#pragma mark - TTAttributedLabel Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SVModalWebViewController *webVC = [[SVModalWebViewController alloc] initWithURL:url];
    
    UIViewController *presentedViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (presentedViewController.presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
    }
    
    [presentedViewController presentViewController:webVC animated:YES completion:nil];
}

@end



@implementation JapanPerLineView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.label];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(49);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.button.mas_right).offset(12);
            make.height.equalTo(self);
            make.right.equalTo(self).offset(-12);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.button.tag = tag;
}

#pragma mark - Initializer
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        [_button setImage:[UIImage imageNamed:@"Register_Check"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"Register_uncheck"] forState:UIControlStateSelected];
    }
    return _button;
}

- (TTTAttributedLabel *)label {
    if (!_label) {
        _label = [TTTAttributedLabel new];
        _label.font      = [UIFont mtc_font_28];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end