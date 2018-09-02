//
//  NewSiteMessageRoundsAlterView.m
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageRoundsAlterView.h"
#import "UIImage+EX.h"

@interface NewSiteMessageRoundsAlterView ()
@property (nonatomic, strong) UIButton *cardView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIButton *closeImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIButton *yesBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UIButton *comfigBtn;
@property (nonatomic, copy) ButtonClick buttonClick;
@property (nonatomic, strong) UIButton *selectedBtn;       //选中btn

@end
@implementation NewSiteMessageRoundsAlterView

+ (NewSiteMessageRoundsAlterView *)shareRoundsView{
    static NewSiteMessageRoundsAlterView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NewSiteMessageRoundsAlterView alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        [self addGestureRecognizer:tap];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        [self addSubview:self.cardView];
        [self.cardView addSubview:self.titelLb];
        [self.cardView addSubview:self.closeImageView];
        [self.cardView addSubview:self.line];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.yesBtn];
        [self.cardView addSubview:self.noBtn];
        [self.cardView addSubview:self.comfigBtn];
        
        [self configElements];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@280);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cardView);
        make.top.equalTo(self.cardView).offset(15);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(15);
        make.right.left.equalTo(self.cardView);
        make.height.equalTo(@0.5);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.cardView).offset(20);
        make.right.equalTo(self.cardView).offset(-20);
        
    }];
    
    [self.yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView.mas_centerX).offset(-30);
        make.height.equalTo(@25);
        make.top.equalTo(self.contentLb.mas_bottom).offset(15);
    }];
    [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.yesBtn);

        make.left.equalTo(self.cardView.mas_centerX).offset(20);
        make.height.equalTo(@25);
    }];
    
    [self.comfigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yesBtn.mas_bottom).offset(15);
        make.left.equalTo(self.cardView).offset(15);
        make.right.equalTo(self.cardView).offset(-15);
        make.height.equalTo(@35);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];

}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}
#pragma mark - event Response
- (void)buttonClick:(UIButton *)btn {
    if (!self.selectedBtn) {
        self.selectedBtn = btn;
        [btn setSelected:YES];
        [self.comfigBtn setEnabled:YES];
    }
    else {
        if (self.selectedBtn.tag == btn.tag) {
            return;
        }
        else {
            [self.selectedBtn setSelected:NO];
            [btn setSelected:YES];
        }
        self.selectedBtn = btn;
    }
}
- (void)closeClick {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)comfigClick {
    if (self.buttonClick) {
        self.buttonClick(self.selectedBtn.tag);
    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)showWithModel:(NewSiteMessageRoundsModel *)model btnClick:(ButtonClick)block {
    [self.contentLb setText:model.msg];
    self.buttonClick = block;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
}
#pragma mark - init UI

- (UIButton *)cardView
{
    if (!_cardView) {
        _cardView = [UIButton new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
}

- (UIButton *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [[UIButton alloc] init];
        [_closeImageView setBackgroundImage:[UIImage imageNamed:@"NewSite_RoundsClose"] forState:UIControlStateNormal];
        [_closeImageView addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
}
    return _closeImageView;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"医生问候" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setNumberOfLines:0];
        
    }
    return _titelLb;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        [_line setBackgroundColor:[UIColor commonCuttingLineColor]];
    }
    return _line;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
        
    }
    return _contentLb;
}

- (UIButton *)yesBtn {
    if (!_yesBtn) {
        _yesBtn = [UIButton new];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_yesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_yesBtn setTag:1];
        [_yesBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"有"];
        [lb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_yesBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yesBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_yesBtn.imageView);
        }];
    }
    return _yesBtn;
}

- (UIButton *)noBtn {
    if (!_noBtn) {
        _noBtn = [UIButton new];
        [_noBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_noBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_noBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_noBtn setTag:0];
        [_noBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"没有"];
        [lb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_noBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_noBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_noBtn.imageView);
        }];
    }
    return _noBtn;
}

- (UIButton *)comfigBtn {
    if (!_comfigBtn) {
        _comfigBtn = [UIButton new];
        [_comfigBtn setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_comfigBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_comfigBtn.layer setCornerRadius:5];
        [_comfigBtn setClipsToBounds:YES];
        [_comfigBtn setEnabled:NO];
        [_comfigBtn addTarget:self action:@selector(comfigClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfigBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
