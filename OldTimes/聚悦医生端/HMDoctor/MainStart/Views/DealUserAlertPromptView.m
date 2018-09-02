//
//  DealUserAlertPromptView.m
//  HMDoctor
//
//  Created by lkl on 2017/7/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DealUserAlertPromptView.h"

static int disHeight = 40;//全局变量

@interface DealUserAlertPromptView ()

@property (nonatomic, strong) UIButton *dealBtn;

@end

@implementation DealUserAlertPromptView

#pragma mark -- 重写init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        [self configConstraints];
        
        [self creatShowAnimation];
    }
    return self;
}

#pragma mark - Private Method
// 设置约束
- (void)configConstraints {
    
    [self addSubview:self.bgView];
    [_bgView addSubview:self.warningIcon];
    [_bgView addSubview:self.contenLabel];
    [_bgView addSubview:self.dealBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(-disHeight);
        make.height.mas_equalTo(disHeight);
    }];
    
    [_warningIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(10);
        make.centerY.equalTo(_bgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [_dealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.centerY.equalTo(_bgView);
        make.width.mas_equalTo(@50);
    }];
    
    [_contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_warningIcon.mas_right).offset(8);
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_dealBtn.mas_left).offset(-3);
    }];
}

#pragma mark - Interface Method
//弹出视图
- (void)showPromptWithViewController:(UIViewController *)viewControllow prompt:(NSString *)prompt
{
    [self.contenLabel setText:prompt];
    [viewControllow.navigationController.view insertSubview:self belowSubview:viewControllow.navigationController.navigationBar];
}

//动画效果
-(void)creatShowAnimation
{
    CGFloat duration = 0.75;
    [UIView animateWithDuration:duration animations:^{
        
        // 往下移动一个label的高度
        _bgView.transform = CGAffineTransformMakeTranslation(0, disHeight);
    } completion:^(BOOL finished) {
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //[self disappearAnimation];
        });
    }];
    
}

//消失动画
-(void)disappearAnimation
{
    CGFloat duration = 0.75;
    
    // 延迟delay秒后，再执行动画
    CGFloat delay = 0.5;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // 恢复到原来的位置
        _bgView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        // 删除控件
        //[_bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
    if (self.returnsAnEventBlock)
    {
        self.returnsAnEventBlock(); // 调用回调函数
    }
}

- (void)dealBtnClick{
    if (self.returnsAnEventBlock)
    {
        self.returnsAnEventBlock(); // 调用回调函数
    }
}

#pragma mark - Init
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"fdffe5"]];
        //------- 添加单击手势 -------
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealBtnClick)]];
    }
    return _bgView;
}

- (UIImageView *)warningIcon{
    if (!_warningIcon) {
        _warningIcon = [UIImageView new];
        [_warningIcon setImage:[UIImage imageNamed:@"icon_warn"]];
    }
    return _warningIcon;
}

- (UILabel *)contenLabel{
    if (!_contenLabel) {
        _contenLabel = [UILabel new];
        [_contenLabel setTextColor:[UIColor commonTextColor]];
        [_contenLabel setFont:[UIFont font_26]];
    }
    return _contenLabel;
}

- (UIButton *)dealBtn{
    if (!_dealBtn) {
        _dealBtn = [UIButton new];
        [_dealBtn setTitle:@"处理 >" forState:UIControlStateNormal];
        [_dealBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        _dealBtn.titleLabel.font = [UIFont font_28];
        _dealBtn.userInteractionEnabled = NO;
    }
    return _dealBtn;
}

@end
