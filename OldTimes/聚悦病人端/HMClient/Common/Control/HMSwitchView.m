//
//  HMSwitchView.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSwitchView.h"

@interface HMSwitchCell: UIControl
{
    UILabel* lbTitle;
    UIView* bottomLine;
}


- (void) setTitle:(NSString*) title;
@end

@implementation HMSwitchCell

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview: lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont font_30]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        
        bottomLine = [[UIView alloc]init];
        [self addSubview:bottomLine];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) setTitle:(NSString*) title
{
    [lbTitle setText:title];
}

- (void) subviewsLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIColor* txtColor = [UIColor commonLightGrayTextColor];
    UIColor* lineColor = [UIColor commonLightGrayTextColor];
    
    if (selected)
    {
        txtColor = [UIColor mainThemeColor];
        lineColor = [UIColor mainThemeColor];
       
    }

    [lbTitle setTextColor:txtColor];
    [bottomLine setBackgroundColor:lineColor];
    [self subviewUpdateLayout];
}

- (void) subviewUpdateLayout
{
    CGFloat lineHeight = 0.5;
    if (self.selected)
    {
        lineHeight = 2.5;
    }

    
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end

@interface HMSwitchView ()
{
    NSMutableArray* switchcells;
}
@end

@implementation HMSwitchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


- (void) createCells:(NSArray*) titles
{
    //CGFloat cellwidth = self.width / titles.count;
    switchcells = [NSMutableArray array];
    
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        
        HMSwitchCell* cell = [[HMSwitchCell alloc]init];
        [self addSubview:cell];
        [cell setSelected:(index == _selectedIndex)];
        [cell setTitle:titles[index]];
        [switchcells addObject:cell];
        [cell addTarget:self action:@selector(switchCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    for (HMSwitchCell* cell in switchcells)
    {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            if (cell == switchcells.firstObject)
            {
                make.left.equalTo(self);
            }
            else
            {
                HMSwitchCell* perCell = nil;
                NSInteger perIndex = [switchcells indexOfObject:cell] - 1;
                if (perIndex >= 0)
                {
                    perCell = switchcells[perIndex];
                }
                if (perCell)
                {
                    make.left.equalTo(perCell.mas_right);
                    make.width.equalTo(perCell);
                }
            }
            
            if (cell == switchcells.lastObject)
            {
                make.right.equalTo(self);
            }
        }];
    }
}

- (void) setTitle:(NSString*) title forIndex:(NSInteger) index
{
    if (!switchcells)
    {
        return;
    }
    if (switchcells.count <= index)
    {
        return;
    }
    
    HMSwitchCell* cell = switchcells[index];
    [cell setTitle:title];
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (!switchcells)
    {
        return;
    }
    for (NSInteger index = 0 ; index < switchcells.count; ++index)
    {
        HMSwitchCell* cell = switchcells[index];
        [cell setSelected:(_selectedIndex == index)];
    }
}

- (void) switchCellClicked:(id) sender
{
    if (![sender isKindOfClass:[HMSwitchCell class]]) {
        return;
    }
    
    HMSwitchCell* selCell = (HMSwitchCell*) sender;
    NSInteger selIndex = [switchcells indexOfObject:selCell];
    if (NSNotFound == selIndex)
    {
        return;
    }
    
    if (_selectedIndex == selIndex)
    {
        return;
    }
    
    for (HMSwitchCell* cell in switchcells)
    {
        [cell setSelected:(cell == selCell)];
    }
    _selectedIndex = selIndex;
    //回调
    if (_delegate && [_delegate respondsToSelector:@selector(switchview:SelectedIndex:)])
    {
        [_delegate switchview:self SelectedIndex:_selectedIndex];
    }
}



@end
