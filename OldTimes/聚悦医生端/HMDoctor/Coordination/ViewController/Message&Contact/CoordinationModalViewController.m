//
//  CoordinationModalViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationModalViewController.h"

@interface CoordinationModalViewController ()

@property (nonatomic, strong)  UILabel  *alertTitle; // <##>
@property (nonatomic, strong)  UILabel  *alertMessage; // <##>
@property (nonatomic, strong)  UIView  *containerView; // <##>
@property (nonatomic, strong)  UIView  *bgView; // <##>
@property (nonatomic, strong)  UIView  *inputView; // <##>
@property (nonatomic, strong)  UIButton  *btnCancel; // <##>
@property (nonatomic, strong)  UIButton  *btnDestructive; // <##>

@property (nonatomic, copy)  NSString  *strTitle; // <##>
@property (nonatomic, copy)  NSString  *strMessage; // <##>

@property (nonatomic, copy)  NSString  *cancelTitle; // <##>
@property (nonatomic, copy)  NSString  *destructiveTitle; // <##>

@property (nonatomic, strong)  NSMutableArray  *arrayBtnTitle; // <##>
@end

@implementation CoordinationModalViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CoordinationModalViewControllerDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super init];
    if (self) {
        //
        self.strTitle = title;
        self.strMessage = message;
        self.delegate = delegate;
        self.cancelTitle = cancelButtonTitle;
        self.destructiveTitle = destructiveButtonTitle;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Interface Method

- (void)addInputView:(UIView *)view height:(CGFloat)height {
    if (view) {
        self.inputView = view;
        [self.containerView addSubview:self.inputView];
        [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView).insets(UIEdgeInsetsMake(0, 25, 0, 25));
            make.bottom.equalTo(self.btnCancel.mas_top).offset(-22);
            make.height.mas_equalTo(height);
            if (self.strMessage.length == 0 && self.strTitle.length == 0) {
                make.top.equalTo(self.containerView).offset(25);
            }  else {
                make.top.equalTo((self.strMessage.length > 0 ? self.alertMessage.mas_bottom : (self.strTitle.length > 0 ? self.alertTitle.mas_bottom : self.containerView))).offset(15);
            }
            
        }];

    }
}
#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
    baseView.backgroundColor = [UIColor blackColor];
    baseView.alpha = 0.5;
    [self.view addSubview:baseView];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.containerView];
    
    if (self.strTitle.length > 0) {
        [self.containerView addSubview:self.alertTitle];
    }
    if (self.strMessage.length > 0) {
        [self.containerView addSubview:self.alertMessage];
    }
    
    [self.containerView addSubview:self.btnCancel];
    
    if (self.destructiveTitle.length > 0) {
        [self.containerView addSubview:self.btnDestructive];
    }
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.right.equalTo(self.bgView).insets(UIEdgeInsetsMake(0, 27.5, 0, 27.5));
    }];
    
    if (self.strTitle.length > 0) {
        [self.alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView).insets(UIEdgeInsetsMake(22, 25, 0, 25));
        }];
    }
    
    if (self.strMessage.length > 0) {
        if (self.strTitle.length > 0) {
            [self.alertMessage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.alertTitle);
                make.top.equalTo(self.alertTitle.mas_bottom).offset(12.5);

            }];
        }
        else {
            [self.alertMessage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.containerView).insets(UIEdgeInsetsMake(15, 25, 0, 25));
            }];
        }
    }
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.containerView);
        make.top.greaterThanOrEqualTo(self.containerView).offset(100);
        make.height.mas_equalTo(45);
        if (self.destructiveTitle.length == 0) {
            make.right.equalTo(self.containerView);
        }
        if (self.strTitle.length > 0) {
            make.top.greaterThanOrEqualTo(self.alertTitle.mas_bottom).offset(25);
        }
        if (self.strMessage.length > 0) {
            make.top.greaterThanOrEqualTo(self.alertMessage.mas_bottom).offset(25);
        }

    }];
    
    if (self.destructiveTitle.length > 0) {
        [self.btnDestructive mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnCancel.mas_right);
            make.height.width.equalTo(self.btnCancel);
            make.right.bottom.equalTo(self.containerView);
        }];
    }


}

// 设置数据
- (void)configData {
    
}

#pragma mark - Event Response

- (void)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex: Tag:)]) {
        [self.delegate coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:sender.tag Tag:self.tag];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Init

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor clearColor]];
    }
    return _bgView;
    
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView.layer setCornerRadius:5];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)alertTitle {
    if (!_alertTitle) {
        _alertTitle = [UILabel new];
        [_alertTitle setFont:[UIFont font_30]];
        [_alertTitle setTextColor:[UIColor commonBlackTextColor_333333]];
        [_alertTitle setText:self.strTitle ? : @""];
        [_alertTitle setNumberOfLines:0];
        [_alertTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_alertTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return _alertTitle;
}

- (UILabel *)alertMessage {
    if (!_alertMessage) {
        _alertMessage = [UILabel new];
        [_alertMessage setFont:[UIFont font_24]];
        [_alertMessage setTextColor:[UIColor commonLightGrayColor_999999]];
        [_alertMessage setText:self.strMessage ? : @""];
        [_alertMessage setNumberOfLines:0];
        [_alertMessage setLineBreakMode:NSLineBreakByWordWrapping];
        [_alertMessage setTextAlignment:NSTextAlignmentCenter];
    }
    return _alertMessage;

}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setBackgroundImage:[UIImage at_imageWithColor:[UIColor commonLightGrayColor_ebebeb] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont font_28]];
        [_btnCancel setTitleColor:[UIColor commonDarkGrayColor_666666] forState:UIControlStateNormal];
        [_btnCancel setTitle:self.cancelTitle.length > 0 ? self.cancelTitle : @"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.tag = 0;
    }
    return _btnCancel;
}

- (UIButton *)btnDestructive {
    if (!_btnDestructive) {
        _btnDestructive = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDestructive setBackgroundImage:[UIImage at_imageWithColor:[UIColor colorWithHexString:@"ff3366"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnDestructive.titleLabel setFont:[UIFont font_28]];
        [_btnDestructive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDestructive setTitle:self.destructiveTitle.length > 0 ? self.destructiveTitle : @"确定" forState:UIControlStateNormal];
        [_btnDestructive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnDestructive.tag = 1;

    }
    return _btnDestructive;
}

@end
