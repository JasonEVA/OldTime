//
//  ApplyCommentView.m
//  launcher
//
//  Created by Kyle He on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyCommentView.h"
#import "UIView+Util.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "UIImage+Manager.h"
#import "MyDefine.h"
#import "AvatarUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ApplyCommentView ()<UIAlertViewDelegate>

@property(nonatomic, strong) UITextView  *commentView;

@property(nonatomic, strong) UIButton  *checkBtn;

@property(nonatomic, strong) UIButton  *cancleBtn;

@property(nonatomic, strong) UILabel  *titileLbl;

/**
 *  下一个审批人：
 */
@property(nonatomic, strong) UILabel  *nextLbl;

@property(nonatomic, strong) UIImageView  *headerIcon;

@property(nonatomic, strong) UILabel  *headerName;

@property(nonatomic, strong) UIButton  *nextBtn;

@property(nonatomic, strong) UIView *backgroundView;

@property(nonatomic, strong) UIView  *contentView;

@end

@implementation ApplyCommentView

- (instancetype)initWithFrame:(CGRect)frame withType:(COMMENTSTATUS)status
{
    if (self = [super initWithFrame:frame])
    {
        self.status = status;
         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.frame = frame;
        if (status == 0 || status == 3)
        {
            self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 150);
        }else
        {
            self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 190);
        }
        [self addSubview:self.contentView];
        if (status == 3)
        {
            self.titileLbl.text = LOCAL(NEWMEETING_CANCELREASON);
        }
        [self createFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFramesChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - interface method
- (void)showKeyBoard
{
    [self.commentView becomeFirstResponder];
}

- (void)setCommentViewStatus:(COMMENTSTATUS)status 
{
    self.status = 1;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setHeadName:(NSString *)name
{
    self.headerName.text = name;
}

- (void)setHeadNameWithModel:(ContactPersonDetailInformationModel *)model
{
    self.headerName.text = model.u_true_name;
    [self.headerIcon sd_setImageWithURL:avatarURL(avatarType_80, model.show_id) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
}

#pragma mark - private method

- (void)keyBoardFramesChanged:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (endKeyboardRect.origin.y < self.frame.size.height)
    {
        CGFloat temp = endKeyboardRect.size.height+self.contentView.frame.size.height+64;

        self.contentView.transform = CGAffineTransformMakeTranslation(0, -temp);
    }
}

- (void)createFrame
{
    [self.contentView addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.titileLbl];
    [self.titileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titileLbl.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    switch (self.status)
    {
        case kNextApprover:
        {
            [self.contentView addSubview:self.nextLbl];
            [self.nextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.commentView);
                make.bottom.equalTo(self.contentView).offset(-15);
                make.top.equalTo(self.commentView.mas_bottom).offset(15);
            }];
            [self.contentView addSubview:self.headerIcon];
            [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nextLbl.mas_right).offset(50);
                make.centerY.equalTo(self.nextLbl);
                make.width.height.equalTo(@30);
            }];
            [self.contentView addSubview:self.headerName];
            [self.headerName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headerIcon.mas_right).offset(10);
                make.centerY.equalTo(self.headerIcon);
            }];
            [self.nextBtn removeFromSuperview];
             break;
        }
        case kAddApprover:
        {   [self.contentView addSubview:self.nextBtn];
            [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.commentView.mas_bottom).offset(15);
                make.width.equalTo(self.contentView.mas_width).dividedBy(3);
                make.height.equalTo(@30);
            }];
            
            [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-50);
            }];
        }
        default:
            break;
    }
    
    [self showKeyBoard];
}

#pragma mark - eventReponse

- (void)checkActions
{
    if (![self.commentView.text isEqualToString:@""])
    {
        if ([self.delegate respondsToSelector:@selector(ApplyCommentViewDelegateCallBack_SendTheTxt:)])
        {
            [self.delegate ApplyCommentViewDelegateCallBack_SendTheTxt:self.commentView.text];
        }
        [self.commentView resignFirstResponder];
        [self removeFromSuperview];
    }
    else
    {
        if (self.status == 3)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(NEWMEETING_INPUTREASON) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
            [self.commentView becomeFirstResponder];
            [view show];
        }
        else
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_APPLY_SUGGEST) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
            [self.commentView becomeFirstResponder];
            [view show];
        }
    }
}

- (void)cancleActions
{
    if ([self.delegate respondsToSelector:@selector(ApplyCommentViewDelegateCallBack_CancleAction)]) {
        [self.delegate ApplyCommentViewDelegateCallBack_CancleAction];
    }
    
    [self.commentView resignFirstResponder];
    [self removeFromSuperview];
}

- (void)choseNextApprove
{
    if ([self.delegate respondsToSelector:@selector(ApplyCommentViewDelegateCallBack_PresentAnotherVC)])
    {
        [self.delegate ApplyCommentViewDelegateCallBack_PresentAnotherVC];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - initizier

- (UIButton *)checkBtn
{
    if (!_checkBtn)
    {
        _checkBtn = [[UIButton alloc] init];
        _checkBtn.expandSize = CGSizeMake(15, 15);
        [_checkBtn setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(checkActions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn)
    {
        _cancleBtn = [[UIButton alloc] init];
        _cancleBtn.expandSize = CGSizeMake(15, 15);
        [_cancleBtn setImage:[UIImage imageNamed:@"X_gray"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleActions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UITextView *)commentView
{
    if (!_commentView)
    {
        _commentView = [[UITextView alloc] init];
        _commentView.layer.cornerRadius = 3;
        _commentView.layer.masksToBounds = YES;
    }
    return _commentView;
}

- (UILabel *)titileLbl
{
    if (!_titileLbl)
    {
        _titileLbl = [[UILabel  alloc] init];
        _titileLbl.text =LOCAL(APPLY_APPLYCOMMENT);
        _titileLbl.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titileLbl;
}

- (UILabel *)nextLbl
{
    if (!_nextLbl)
    {
        _nextLbl = [[UILabel alloc] init];
        _nextLbl.text = LOCAL(APPLY_NEXTPERSON);
        _nextLbl.textColor = [UIColor mtc_colorWithHex:0x707070];
        _nextLbl.font = [UIFont systemFontOfSize:12.0f];
    }
    return _nextLbl;
}

- (UIImageView *)headerIcon
{
    if (!_headerIcon)
    {
        _headerIcon = [[UIImageView alloc] init];
         _headerIcon.image = [UIImage imageNamed:@"headeriocn"];
    }
    return _headerIcon;
}

- (UILabel *)headerName
{
    if (!_headerName)
    {
        _headerName = [[UILabel alloc] init];
        _headerName.font = [UIFont systemFontOfSize:15.0f];
    }
    return _headerName;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn)
    {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        [_nextBtn setTitle:LOCAL(APPLY_SELECTNEXTPERSON) forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [_nextBtn addTarget:self action:@selector(choseNextApprove) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    }
    return _contentView;
}
@end
