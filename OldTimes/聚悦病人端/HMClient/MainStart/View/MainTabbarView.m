//
//  MainTabbarView.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainTabbarView.h"
#import "InitializationHelper.h"
#import "UIView+Util.h"
#import "ClientHelper.h"

#define LOGOHEIGHT 40
@interface MainTabbarCell : UIControl
{
    UILabel* lbTitle;
    UIImageView* ivIcon;
    
    UIImage* imgNormal;
    UIImage* imgHighlight;
}


- (id) initWithFrame:(CGRect)frame
               Title:(NSString*) title
         NormalImage:(UIImage*) normalImage
      HighlightImage:(UIImage*) highlightImage;

@property (nonatomic, strong) UIImageView *LogoView;   // 集团用户标识

@end

@implementation MainTabbarCell

- (id) initWithFrame:(CGRect)frame
               Title:(NSString*) title
         NormalImage:(UIImage*) normalImage
      HighlightImage:(UIImage*) highlightImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 21, self.width, 17)];
        [self addSubview:lbTitle];
        [lbTitle setFont:[UIFont font_26]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setText:title];
        
        ivIcon = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 22)/2, 4, 22, 22)];
        [self addSubview:ivIcon];
        
        imgNormal = normalImage;
        imgHighlight = highlightImage;
        
        if ([title isEqualToString:@"首页"]) {
            UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
            if (info.blocId != 0) {
                // 集团用户
                NSString *urlStr = [NSString stringWithFormat:@"%@base.do?method=getOrgIcon&userId=%ld",kZJKBaseUrl,(long)info.userId];
                NSURL *url = [NSURL URLWithString:urlStr];
                [self.LogoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_logo"]];
                [self addSubview:self.LogoView];
                [lbTitle setHidden:YES];
                [ivIcon setHidden:YES];
                
            }
        }
        
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if ([self.subviews containsObject:self.LogoView]) {
        [self.LogoView setHidden:self.tag || !selected];
        [lbTitle setHidden:!self.tag && selected];
        [ivIcon setHidden:!self.tag && selected];
    }
    
    UIColor* clrTitle = [UIColor colorWithHexString:@"666666"];
    
    UIImage* imgIcon = imgNormal;
    if (selected)
    {
        clrTitle = [UIColor mainThemeColor];
        imgIcon = imgHighlight;
    }
    [lbTitle setTextColor:clrTitle];
    [ivIcon setImage:imgIcon];
    
}

- (UIImageView *)LogoView {
    if (!_LogoView) {
        _LogoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - LOGOHEIGHT) / 2, (self.height - LOGOHEIGHT) / 2, LOGOHEIGHT+1, LOGOHEIGHT+1)];
        [_LogoView.layer setCornerRadius:LOGOHEIGHT / 2];
        [_LogoView.layer setBorderColor:[[UIColor colorWithHexString:@"cccccc"] CGColor]];
        [_LogoView.layer setBorderWidth:0.5];
        [_LogoView setClipsToBounds:YES];
        [_LogoView setUserInteractionEnabled:YES];
        _LogoView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PKClick)];
        [_LogoView addGestureRecognizer:tap];
        
    }
    return _LogoView;
}
- (void)PKClick {
    [HMViewControllerManager createViewControllerWithControllerName:@"HMGroupPKMainViewController" ControllerObject:nil];
}
@end



#define kMainTabbarMessageButtonBadgeTag        0x87321
@implementation MainTabbarMessageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lbBadgeNumber];
        [self.lbBadgeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageView.mas_top).offset(3);
            make.centerX.equalTo(self.imageView.mas_right).offset(-3);
            make.height.width.equalTo(@18);
        }];

    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGRect newBadgeRect = self.lbBadgeNumber.frame;
//    if (newBadgeRect.size.width < newBadgeRect.size.height) {
//        newBadgeRect.size.width = newBadgeRect.size.height;
//    }
//    newBadgeRect.size.width += 3 * self.lbBadgeNumber.text.length;
//    newBadgeRect.size.height += 3;
//    self.lbBadgeNumber.frame = newBadgeRect;
//    self.lbBadgeNumber.layer.cornerRadius = CGRectGetHeight(self.lbBadgeNumber.frame) * 0.5;
//}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rtImage = CGRectMake((contentRect.size.width - (contentRect.size.height - 11))/2, 2, contentRect.size.height - 11, contentRect.size.height - 11);
    return rtImage;
}

- (void)showBadge:(NSUInteger)unreadMessageCount {
    if (unreadMessageCount > 0 && unreadMessageCount < 100) {
        self.lbBadgeNumber.text = [NSString stringWithFormat:@"%ld",unreadMessageCount];

    }
    else if (unreadMessageCount >= 100) {
        self.lbBadgeNumber.text = @"⋅⋅⋅";
    }
    self.lbBadgeNumber.hidden = unreadMessageCount == 0;
}

- (UILabel *)lbBadgeNumber {
    if (!_lbBadgeNumber) {
        _lbBadgeNumber = [[UILabel alloc]init];
        _lbBadgeNumber.font = [UIFont systemFontOfSize:10];
        _lbBadgeNumber.textColor = [UIColor whiteColor];
        [_lbBadgeNumber setTextAlignment:NSTextAlignmentCenter];
        [_lbBadgeNumber setTag:kMainTabbarMessageButtonBadgeTag];
        [_lbBadgeNumber setBackgroundColor:[UIColor commonRedColor]];
        _lbBadgeNumber.layer.cornerRadius = 9;
        _lbBadgeNumber.layer.masksToBounds = YES;
        _lbBadgeNumber.hidden = YES;
        [_lbBadgeNumber.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_lbBadgeNumber.layer setBorderWidth:0.5];
    }
    return _lbBadgeNumber;
}

@end

@interface MainTabbarView ()
{
    NSMutableArray* tabbarCells;
}
@end

@implementation MainTabbarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showBadge:(NSUInteger)unreadMessageCount
{
    [self.btnMessage showBadge:unreadMessageCount];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        //        [self showTopLine];
        UIImageView* ivBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, -11, 320 * kScreenScale, 60 * kScreenScale)];
        [self addSubview:ivBackground];
        [ivBackground setImage:[UIImage imageNamed:@"tabbar_bg"]];
        
        [self createTabbarItems];
    }
    return self;
}

- (void) createTabbarItems
{
    tabbarCells = [NSMutableArray array];
    
    NSArray* titles = @[@"首页", @"计划", @"服务", @"我的"];
    NSArray* normalImages = @[[UIImage imageNamed:@"SEMainStartic_home"],
                             [UIImage imageNamed:@"SEMainStartic_health"],
                             [UIImage imageNamed:@"SEMainStartic_shop"],
                             [UIImage imageNamed:@"SEMainStartic_me"]];
    NSArray* highlightImages = @[[UIImage imageNamed:@"SEMainStartic_home_down"],
                             [UIImage imageNamed:@"SEMainStartic_health_down"],
                             [UIImage imageNamed:@"SEMainStartic_shop_down"],
                             [UIImage imageNamed:@"SEMainStartic_me_down"]];
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        CGRect rtCell = [self tabbarCellFrame:index];
        MainTabbarCell* tabbarCell = [[MainTabbarCell alloc]initWithFrame:rtCell Title:titles[index] NormalImage:normalImages[index] HighlightImage:highlightImages[index]];
        
        [tabbarCell setTag:index];
        [self addSubview:tabbarCell];
        [tabbarCell setSelected:(_selectedIndex == index)];
        
        [tabbarCells addObject:tabbarCell];
        [tabbarCell addTarget:self action:@selector(tabbarCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarCell addTarget:self action:@selector(tabbarCellClickDown:) forControlEvents:UIControlEventTouchDown];
    }
    
    //IM消息按钮
    CGFloat cellWidth = self.width / 5;
    self.btnMessage = [[MainTabbarMessageButton alloc]initWithFrame:CGRectMake(cellWidth * 2, 0.5, cellWidth, self.height - 0.5)];
    [self addSubview:self.btnMessage];
    [self.btnMessage setImage:[UIImage imageNamed:@"tabbar_IMMessage"] forState:UIControlStateNormal];
    [self.btnMessage setImage:[UIImage imageNamed:@"tabbar_IMMessage_selected"] forState:UIControlStateHighlighted];
    [self addSubview:self.btnMessage];
    
    [self.btnMessage addTarget:self action:@selector(imcharbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    
    _selectedIndex = selectedIndex;
    
    if (!tabbarCells || 0 > _selectedIndex) {
        return;
    }
    if (_selectedIndex >= tabbarCells.count) {
        for (MainTabbarCell* cell in tabbarCells)
        {
            [cell setSelected:NO];
        }
        [self.btnMessage setImage:[UIImage imageNamed:@"tabbar_IMMessage_selected"] forState:UIControlStateNormal];
        return;
    }
    MainTabbarCell* selCell = tabbarCells[_selectedIndex];
    
    for (MainTabbarCell* cell in tabbarCells)
    {
        [self.btnMessage setImage:[UIImage imageNamed:@"tabbar_IMMessage"] forState:UIControlStateNormal];
        [cell setSelected:(cell == selCell)];
    }
}

- (CGRect) tabbarCellFrame:(NSInteger) index
{
    CGFloat cellWidth = self.width / 5;
    CGRect rtFrame = CGRectMake(0, 0.5, cellWidth, self.height - 0.5);
    rtFrame.origin.x = index * cellWidth;
    if (index > 1)
    {
        rtFrame.origin.x += cellWidth;
    }
    return rtFrame;
}

- (void) tabbarCellClickDown:(id) sender
{
    if (![sender isKindOfClass:[MainTabbarCell class]])
    {
        return;
    }
    MainTabbarCell* selCell = (MainTabbarCell*)sender;
    NSInteger selIndex = [tabbarCells indexOfObject:selCell];
    
    if (_selectedIndex == selIndex)
    {
        return;
    }
    
    for (MainTabbarCell* cell in tabbarCells)
    {
        [cell setSelected:(cell == selCell)];
    }

}

- (void) tabbarCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainTabbarCell class]])
    {
        return;
    }
    MainTabbarCell* selCell = (MainTabbarCell*)sender;
    NSInteger selIndex = [tabbarCells indexOfObject:selCell];
    
    if (_selectedIndex == selIndex)
    {
        return;
    }
    
    [tabbarCells enumerateObjectsUsingBlock:^(MainTabbarCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setSelected:(idx == _selectedIndex)];
    }];
    
    /*
    if (selIndex == 2) {
        //商城 单独跳转
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
        return;
    }
    */
    _selectedIndex = selIndex;
    
   
    
//    for (MainTabbarCell* cell in tabbarCells)
//    {
//        [cell setSelected:(cell == selCell)];
//    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabbarSelected:)])
    {
        [_delegate tabbarSelected:selIndex];
    }
}

- (void) imcharbuttonClicked:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(tabbarMainSelect)]) {
        [self.delegate tabbarMainSelect];
    }
}
@end
