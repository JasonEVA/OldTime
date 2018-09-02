//
//  MainStartTaskSwichView.m
//  HMDoctor
//
//  Created by yinquan on 16/4/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartTaskSwichView.h"


#define kTaskSwitchBadgeTag         0x6540

@interface MainStartTaskSwichCell : UIControl
{
    UIView* lableview;
    UILabel* lbSwitch;
    UIImageView* ivIcon;
    UIView* bottomLine;
}

@property (nonatomic, retain) UIImage* normalImage;
@property (nonatomic, retain) UIImage* hightlightImage;

- (void) setTitle:(NSString*) title;

- (void) showBadge:(BOOL) show;
@end

@implementation MainStartTaskSwichCell

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        lableview = [[UIView alloc]init];
        [self addSubview:lableview];
        [lableview setUserInteractionEnabled:NO];
        
        ivIcon = [[UIImageView alloc]init];
        [lableview addSubview:ivIcon];
        
        lbSwitch = [[UILabel alloc]init];
        [lableview addSubview:lbSwitch];
        
        [lbSwitch setTextAlignment:NSTextAlignmentCenter];
        [lbSwitch setBackgroundColor:[UIColor whiteColor]];
        [lbSwitch setTextColor:[UIColor colorWithHexString:@"8C8C8C"]];
        [lbSwitch setFont:[UIFont systemFontOfSize:15]];
        
        bottomLine = [[UIView alloc]init];
        [self addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewLayout];
    }
    return self;
}



- (void) setTitle:(NSString*) title
{
    if (lbSwitch)
    {
        [lbSwitch setText:title];
    }
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIColor* txtColor = [UIColor commonDarkGrayTextColor];
    if (selected)
    {
        txtColor = [UIColor colorWithHexString:kHMHeaderBackgroundColor];
        [ivIcon setImage:_hightlightImage];
        [bottomLine setBackgroundColor:[UIColor mainThemeColor]];
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@2.5);
        }];
    }
    else
    {
        [ivIcon setImage:_normalImage];
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
    }
    [lbSwitch setTextColor:txtColor];
}

- (void) subviewLayout
{
    [lableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(lableview);
        make.left.equalTo(lableview);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [lbSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(self.size);
        make.right.equalTo(lableview);
        make.centerY.equalTo(lableview);
        make.left.equalTo(ivIcon.mas_right).with.offset(5);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void) showBadge:(BOOL) show
{
    UIView* badgeview = [self viewWithTag:kTaskSwitchBadgeTag];
    if (show)
    {
        if (!badgeview)
        {
            badgeview = [[UIView alloc]init];
            [self addSubview:badgeview];
            badgeview.layer.cornerRadius = 3;
            badgeview.layer.masksToBounds = YES;
            [badgeview setBackgroundColor:[UIColor commonRedColor]];
            
            [badgeview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lableview.mas_right).with.offset(5);
                make.top.equalTo(lableview.mas_top);
                make.size.mas_equalTo(CGSizeMake(6, 6));
            }];
        }
        [badgeview setHidden:!show];
    }
    else
    {
        if (badgeview)
        {
            [badgeview setHidden:!show];
        }
    }
}

@end

@interface MainStartTaskSwichView ()
{
    NSMutableArray* switchcells;
    NSInteger selectedIndex;
}


@end

@implementation MainStartTaskSwichView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        switchcells = [NSMutableArray array];
        [self createSwitchCells];
        

        [self subviewLayout];
        
    }
    return self;
}

- (void) createSwitchCells
{
    NSArray* titles = @[@"任务", @"预警"];
    NSArray* norImages = @[[UIImage imageNamed:@"ic_main_task_nor"] , [UIImage imageNamed:@"ic_main_alert_nor"]] ;
    NSArray* highImages = @[[UIImage imageNamed:@"ic_main_task_high"] , [UIImage imageNamed:@"ic_main_alert_high"]] ;
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        MainStartTaskSwichCell* cell = [[MainStartTaskSwichCell alloc]init];
        
        [self addSubview:cell];
        [cell addTarget:self action:@selector(switchCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell setTitle:titles[index]];
        [cell setNormalImage:norImages[index]];
        [cell setHightlightImage:highImages[index]];
        
        [switchcells addObject:cell];
        [cell setSelected:index == selectedIndex];
    }
}

- (void) switchCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainStartTaskSwichCell class]])
    {
        return;
    }
    
    for (MainStartTaskSwichCell* cell in switchcells)
    {
        [cell setSelected:(cell == sender)];
    }
    
    NSInteger selIndex = [switchcells indexOfObject:sender];
    if (NSNotFound != selIndex)
    {
        selectedIndex = selIndex;
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchview:SelectedIndex:)])
        {
            [self.delegate switchview:self SelectedIndex:selectedIndex];
        }
    }
}

- (void) subviewLayout
{
    
    for (NSInteger index = 0; index < switchcells.count; ++index)
    {
        MainStartTaskSwichCell* cell = switchcells[index];
        MainStartTaskSwichCell* perCell = nil;
        if (0 < index)
        {
            perCell = switchcells[index - 1];
        }
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.size.mas_equalTo(perCell.size);
            make.top.and.bottom.equalTo(self);
            
            if (!perCell)
            {
                make.left.equalTo(self.mas_left);
            }
            else
            {
                make.width.equalTo(perCell);
                make.left.equalTo(perCell.mas_right);
            }
            
            if (cell == [switchcells lastObject])
            {
                make.right.equalTo(self);
            }
        }];
    }
}

- (void) setAlertMessionCount:(NSInteger) count
{
    if (!switchcells || 2 > switchcells.count) {
        return;
    }
    
    MainStartTaskSwichCell* cell = switchcells[1];
    [cell showBadge:(count > 0)];
}


@end
