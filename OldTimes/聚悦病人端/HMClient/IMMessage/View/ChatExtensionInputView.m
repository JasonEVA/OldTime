//
//  ChatExtensionInputView.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ChatExtensionInputView.h"

@interface ChatExtensionInputCell : UIControl
{
    UIImageView* ivIcon;
    UILabel* lbTitle;
}
- (void) setImage:(UIImage*) iconImage
            Title:(NSString*) title;
@end

@implementation ChatExtensionInputCell

- (id) init
{
    self = [super init];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(59, 54));
            make.top.equalTo(self).with.offset(10);
        }];
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setFont:[UIFont font_26]];
        [lbTitle setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(ivIcon.mas_bottom).with.offset(5);
        }];
    }
    return self;
}

- (void) setImage:(UIImage*) iconImage
            Title:(NSString*) title
{
    [ivIcon setImage:iconImage];
    [lbTitle setText:title];
}

@end

@interface ChatExtensionInputView ()
{
    NSMutableArray* cells;
}
@end

@implementation ChatExtensionInputView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        [self showTopLine];
        [self createCells];
        [self subviewLayout];
    }
    return self;
}

- (void) createCells
{
    if (cells)
    {
        for (UIView* cell in cells)
        {
            [cell removeFromSuperview];
        }
    }
    
    cells = [NSMutableArray array];
    
    NSArray* cellImages = @[[UIImage imageNamed:@"img_imappend_camera"], [UIImage imageNamed:@"img_imappend_picture"]];
    NSArray* celltitles = @[@"拍摄", @"照片"];
    for (NSInteger index = 0; index < 4; ++index)
    {
        ChatExtensionInputCell* cell = [[ChatExtensionInputCell alloc]init];
        [self addSubview:cell];
        [cells addObject:cell];
        if (index < cellImages.count)
        {
            [cell setImage:cellImages[index] Title:celltitles[index]];
        }
        [cell addTarget:self action:@selector(extentCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) subviewLayout
{
    for (ChatExtensionInputCell* cell in cells)
    {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            if (cell == [cells firstObject])
            {
                make.left.equalTo(self);
            }
            else
            {
                NSInteger perIndex = [cells indexOfObject:cell] - 1;
                ChatExtensionInputCell* perCell = cells[perIndex];
                make.width.equalTo(perCell);
                make.left.equalTo(perCell.mas_right);
                if (cell == cells.lastObject)
                {
                    make.right.equalTo(self);
                }
            }
            
        }];
    }
}

- (void) extentCellClicked:(id) sender
{
    NSInteger clickedIndex = [cells indexOfObject:sender];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    switch (clickedIndex)
    {
        case 0:
        {
            //拍摄
            if (_delegate && [_delegate respondsToSelector:@selector(caremaButtonClicked)])
            {
                [_delegate caremaButtonClicked];
            }
        }
            break;
        case 1:
        {
            //相册图片
            if (_delegate && [_delegate respondsToSelector:@selector(pictureButtonClicked)])
            {
                [_delegate pictureButtonClicked];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
