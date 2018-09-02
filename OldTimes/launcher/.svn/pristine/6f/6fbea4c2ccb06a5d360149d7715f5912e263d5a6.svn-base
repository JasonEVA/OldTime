//
//  ChatRelationLeftTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatRelationLeftTableViewCell.h"
#import "Images.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "Category.h"
#import "NSDate+MsgManager.h"
#import <Masonry.h>
#import "AvatarUtil.h"
#import "UIFont+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LeftTriangle.h"
#import <DateTools/DateTools.h>
#import <MintcodeIM/MintcodeIM.h>
#import "TiptiltedView.h"
#define pass_color [UIColor colorWithRed:0 green:172/255.0 blue:26/255.0 alpha:1]
#define refused_color [UIColor colorWithRed:251/255.0 green:0 blue:32/255.0 alpha:1]
#define title_bg_color [UIColor colorWithRed:205/255.0 green:232/255.0 blue:240/255.0 alpha:1]
#define line_color [UIColor colorWithRed:177/255.0 green:211/255.0 blue:222/255.0 alpha:1]

@interface ChatRelationLeftTableViewCell()

@property (nonatomic, strong) UIImageView *imgViewHead;   //头像
@property (nonatomic, strong) UILabel *lblName;           //昵称
@property (nonatomic, strong) UIView *viewContent;        //bgview
@property (nonatomic, strong) UIView *viewTitle;          //title背景色
@property (nonatomic, strong) UILabel *lblTitle;          //title
@property (nonatomic, strong) UILabel *lblTime;             // 时间
@property (nonatomic, strong) LeftTriangle *leftTri;        // 三角

@property (nonatomic,strong) UIImageView * contentInfoImg; // 验证信息图标
@property (nonatomic,strong) UILabel * contentInfoLabel;   // 验证信息
@property (nonatomic,strong) UIButton * passButton;        // 通过
@property (nonatomic,strong) UIButton * refusedButton;     // 拒绝
@property(nonatomic, strong) TiptiltedView  *tipView;      //印章

@property(nonatomic, copy) headViewClick  myBlock;

@end

@implementation ChatRelationLeftTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        
        self.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
        [self.imgViewHead addGestureRecognizer:recognizer];
        self.imgViewHead.userInteractionEnabled = YES;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setCellDate:(MessageRelationValidateModel *)model
{
    //头像
    NSURL *urlHead = avatarIMURL(avatarType_80, model.fromAvatar);
    [self.imgViewHead sd_setImageWithURL:urlHead placeholderImage:IMG_PLACEHOLDER_HEAD];
    // 昵称
    self.lblName.text = model.fromNickName;
    // 内容
    self.contentInfoLabel.text = model.content;
    // title
    self.lblTitle.text = LOCAL(FRIEND_VERIFY_PLEASE);
    // 创建时间
    [self.lblTime setText:[NSDate im_dateFormaterWithTimeInterval:model.createDate appendMinute:YES]];
    
    switch (model.validateState) {
        case mt_relation_validateState_reject: //拒绝
        {
            self.tipView.hidden = NO;
            [self.tipView setdataWithType:viewKind_disAgree];
            [self hideBtns];
        }
            break;
        case mt_relation_validateState_agree: //同意
        {
            self.tipView.hidden = NO;
            [self.tipView setdataWithType:viewKind_agree];
            [self hideBtns];
        }
            break;
        default:
        {
            self.tipView.hidden = YES;
            self.passButton.hidden = NO;
            self.refusedButton.hidden = NO;
        }
            break;
    }

}

- (void)hideBtns
{
    self.passButton.hidden = YES;
    self.refusedButton.hidden = YES;
}

- (void)passButtonSelect
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(ChatRelationLeftTableViewCell_SelectPassButtonWithCellPath:)]) {
        [self.deleagte ChatRelationLeftTableViewCell_SelectPassButtonWithCellPath:self.indexPath];
    }
}
- (void)refusedButtonSelect
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(ChatRelationLeftTableViewCell_SelectRefusedButtonWithCellPath:)]) {
        [self.deleagte ChatRelationLeftTableViewCell_SelectRefusedButtonWithCellPath:self.indexPath];
    }
}

#pragma makr - privateMethod
- (void)clickAction
{
    self.myBlock();
}

#pragma mark - interfaceMethod 
- (void)headViewClickBloc:(headViewClick)block
{
    self.myBlock = block;
}

#pragma mark - updateConstraints

- (void)updateConstraints
{
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(12);
        make.top.equalTo(self.imgViewHead);
        make.height.equalTo(@20);
    }];
    
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(60);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(40);
        make.bottom.equalTo(self.contentView).offset(-43);
    }];
    
    [self.viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.viewContent);
        make.height.equalTo(@40);
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTitle).offset(12);
        make.centerY.equalTo(self.viewTitle);
        make.height.equalTo(@40);
    }];
    

    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewTitle);
        make.right.equalTo(self.viewTitle.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@40);
    }];
    [self.contentInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewContent).offset(12);
        make.width.equalTo(@15);
        make.top.equalTo(self.viewTitle.mas_bottom).offset(15);
    }];
    [self.contentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentInfoImg.mas_right).offset(15);
         make.right.equalTo(self.contentView).offset(-25);
        make.centerY.equalTo(self.contentInfoImg.mas_centerY);
    }];
    
    
    [self.passButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewContent).offset(12);
        make.bottom.equalTo(self.viewContent).offset(-15);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.refusedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passButton.mas_right).offset(10);
        make.bottom.equalTo(self.viewContent).offset(-15);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewContent).offset(12);
        make.bottom.equalTo(self.viewContent).offset(2);
        make.width.equalTo(@102);
        make.height.equalTo(@50.5);
    }];
    
    [super updateConstraints];
}

#pragma mark - setData

#pragma mark - initComponent

- (void)initComponent
{
    [self.viewContent addSubview:self.tipView];
    [self.contentView addSubview:self.imgViewHead];
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.viewContent];
    [self.viewContent addSubview:self.viewTitle];
    [self.viewTitle addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.leftTri];
    [self.viewContent addSubview:self.contentInfoImg];
    [self.viewContent addSubview:self.contentInfoLabel];
    [self.viewContent addSubview:self.passButton];
    [self.viewContent addSubview:self.refusedButton];
}

#pragma mark - InIt UI

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:title_bg_color colorBorderColor:line_color];
    }
    return _leftTri;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 5;
        _imgViewHead.layer.masksToBounds = YES;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
        [_lblName setTextColor:[UIColor blackColor]];
        [_lblName setFont:[UIFont mtc_font_26]];
    }
    return _lblName;
}

- (UIView *)viewContent
{
    if (!_viewContent)
    {
        _viewContent = [[UIView alloc] init];
        [_viewContent setBackgroundColor:[UIColor whiteColor]];
        _viewContent.layer.cornerRadius = 10;
        _viewContent.layer.borderColor = line_color.CGColor;
        _viewContent.layer.borderWidth = 1.0;
        _viewContent.clipsToBounds = YES;
    }
    return _viewContent;
}

- (UIView *)viewTitle
{
    if (!_viewTitle)
    {
        _viewTitle = [[UIView alloc] init];
        [_viewTitle setBackgroundColor:title_bg_color];
        [_viewTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _viewTitle.clipsToBounds = YES;
    }
    return _viewTitle;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setFont:[UIFont mtc_font_30]];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblTitle;
}


- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setTextAlignment:NSTextAlignmentCenter];
        [_lblTime setFont:[UIFont mtc_font_26]];
        [_lblTime setTextColor:[UIColor blackColor]];
    }
    return _lblTime;
}

- (UIImageView *)contentInfoImg
{
    if (!_contentInfoImg) {
        _contentInfoImg = [[UIImageView alloc] init];
        _contentInfoImg.userInteractionEnabled = YES;
        _contentInfoImg.image = [UIImage imageNamed:@"speach"];
    }
    return _contentInfoImg;
}

- (UILabel *)contentInfoLabel
{
    if (!_contentInfoLabel) {
        _contentInfoLabel = [[UILabel alloc] init];
        _contentInfoLabel.font = [UIFont mtc_font_26];
        _contentInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentInfoLabel;
}

- (UIButton *)passButton
{
    if (!_passButton) {
        _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passButton setBackgroundColor:[UIColor whiteColor]];
        _passButton.layer.cornerRadius = 5;
        _passButton.layer.borderColor = pass_color.CGColor;
        _passButton.layer.borderWidth = 1.0;
        _passButton.clipsToBounds = YES;
        [_passButton setTitleColor:pass_color forState:UIControlStateNormal];
        [_passButton setTitle:LOCAL(APPLY_ACCEPT) forState:UIControlStateNormal];
        [_passButton addTarget:self action:@selector(passButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passButton;
}
- (UIButton *)refusedButton
{
    if (!_refusedButton) {
        _refusedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refusedButton setBackgroundColor:[UIColor whiteColor]];
        _refusedButton.layer.cornerRadius = 5;
        _refusedButton.layer.borderColor = refused_color.CGColor;
        _refusedButton.layer.borderWidth = 1.0;
        _refusedButton.clipsToBounds = YES;
        [_refusedButton setTitleColor:refused_color forState:UIControlStateNormal];
        [_refusedButton setTitle:LOCAL(FRIEND_DISAGREE) forState:UIControlStateNormal];
        [_refusedButton addTarget:self action:@selector(refusedButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refusedButton;
}

- (TiptiltedView *)tipView
{
    if (!_tipView)
    {
        _tipView = [[TiptiltedView alloc] init];
    }
    return _tipView;
}

@end

