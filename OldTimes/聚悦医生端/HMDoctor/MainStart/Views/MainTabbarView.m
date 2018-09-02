//
//  MainTabbarView.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainTabbarView.h"
#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]
static const CGFloat unReadCountLbSize = 19; //带数字红点尺寸

@interface MainTabbarCell ()
{
    UIImageView* ivIcon;
    UILabel* lbName;
    UIImageView *redPoint; // 红点

    UIImage* normalImage;
    UIImage* hightlightImage;
}



@end

@implementation MainTabbarCell

- (id) initWithFrame:(CGRect)frame
          NormalIcon:(UIImage*) icon
       HighlightIcon:(UIImage*) highIcon
                Name:(NSString*) name;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        [ivIcon setImage:icon];
        
        
        normalImage = icon;
        hightlightImage = highIcon;
        
        lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextAlignment:NSTextAlignmentCenter];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        [lbName setText:name];
        [self addSubview:lbName];
        
        // 红点
//        redPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_redPoint"]];
//        redPoint.hidden = YES;
//        [self addSubview:redPoint];
        [self addSubview:self.allUnReadCountLb];
        [self.allUnReadCountLb setHidden:YES];

        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(5.5);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(ivIcon.mas_bottom).with.offset(2);
    }];
    
//    [redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ivIcon.mas_right);
//        make.centerY.equalTo(ivIcon.mas_top);
//    }];
    
    [self.allUnReadCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivIcon).offset(-4);
//        make.centerX.equalTo(ivIcon.mas_right).offset(-5);
        make.height.equalTo(@(unReadCountLbSize));
        make.left.lessThanOrEqualTo(ivIcon.mas_right).offset(-3);
        make.right.greaterThanOrEqualTo(ivIcon.mas_right).offset(15);
    }];

}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        [ivIcon setImage:hightlightImage];
        [lbName setTextColor:[UIColor mainThemeColor]];
    }
    else
    {
        [ivIcon setImage:normalImage];
        [lbName setTextColor:[UIColor colorWithHexString:@"666666"]];
    }
}

- (void)configRedPointShow:(BOOL)show {
    redPoint.hidden = !show;
}

- (void)configRedPointAllCount:(NSInteger)count {
    [self.allUnReadCountLb setHidden:!count];
    [self.allUnReadCountLb setText:count > 99 ? [NSString stringWithFormat:@"⋅⋅⋅  "] : [NSString stringWithFormat:@"%ld  ",count]];
}

- (UILabel *)allUnReadCountLb {
    if (!_allUnReadCountLb) {
        _allUnReadCountLb = [UILabel new];
        [_allUnReadCountLb.layer setBackgroundColor:[COLOR_BG CGColor]];
        [_allUnReadCountLb.layer setCornerRadius:unReadCountLbSize / 2];
        [_allUnReadCountLb setClipsToBounds:YES];
        [_allUnReadCountLb setTextColor:[UIColor whiteColor]];
        [_allUnReadCountLb setFont:[UIFont systemFontOfSize:12]];
        [_allUnReadCountLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _allUnReadCountLb;
}

@end

@interface MainTabbarView ()
{
}
@end

@implementation MainTabbarView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self createTabbarItems];
        [self showTopLine];
    }
    return self;
}

- (void)showRedPointAtIndex:(NSInteger)index show:(BOOL)show {
    MainTabbarCell *cell = self.tabbarCells[index];
    [cell configRedPointShow:show];
}

- (void)showRedPointAtIndex:(NSInteger)index withCount:(NSInteger)count {
    MainTabbarCell *cell = self.tabbarCells[index];
    [cell configRedPointAllCount:count];
}

- (void) createTabbarItems
{
    self.tabbarCells = [NSMutableArray array];
    
    NSArray* titles = @[@"工作台", @"消息", @"工作组", @"工具", @"我的"];
    NSArray* normalImages = @[[UIImage imageNamed:@"tabbar_main"],
                              [UIImage imageNamed:@"tabbar_patient"],
                              [UIImage imageNamed:@"tabbar_coodination"],
                              [UIImage imageNamed:@"tabbar_tools"],
                              [UIImage imageNamed:@"tabbar_user"]];
    
    NSArray* highlightImages = @[[UIImage imageNamed:@"tabbar_main_selected"],
                                 [UIImage imageNamed:@"tabbar_patient_selected"],
                                 [UIImage imageNamed:@"tabbar_coodination_selected"],
                                 [UIImage imageNamed:@"tabbar_tools_selected"],
                                 [UIImage imageNamed:@"tabbar_user_selected"]];
    
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        CGRect rtCell = [self tabbarCellFrame:index];
        MainTabbarCell* tabbarCell = [[MainTabbarCell alloc]initWithFrame:rtCell NormalIcon:normalImages[index] HighlightIcon:highlightImages[index] Name:titles[index]];
        [self addSubview:tabbarCell];
        [tabbarCell setSelected:(_selectedIndex == index)];
        
        [self.tabbarCells addObject:tabbarCell];
        [tabbarCell addTarget:self action:@selector(tabbarCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (CGRect) tabbarCellFrame:(NSInteger) index
{
    CGFloat cellWidth = self.width / 5;
    CGRect rtFrame = CGRectMake(0, 0.5, cellWidth, self.height - 0.5);
    rtFrame.origin.x = index * cellWidth;
   
    return rtFrame;
}

- (void) tabbarCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainTabbarCell class]])
    {
        return;
    }
    MainTabbarCell* selCell = (MainTabbarCell*)sender;
    NSInteger selIndex = [self.tabbarCells indexOfObject:selCell];
    if (_selectedIndex == selIndex)
    {
        return;
    }
    
    _selectedIndex = selIndex;
    for (MainTabbarCell* cell in self.tabbarCells)
    {
        [cell setSelected:(cell == selCell)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabbarSelected:)])
    {
        [_delegate tabbarSelected:selIndex];
    }
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    
    _selectedIndex = selectedIndex;
    
    if (!self.tabbarCells || 0 > _selectedIndex || _selectedIndex >= self.tabbarCells.count) {
        return;
    }
    MainTabbarCell* selCell = self.tabbarCells[_selectedIndex];
    
    for (MainTabbarCell* cell in self.tabbarCells)
    {
        [cell setSelected:(cell == selCell)];
    }
}


@end
