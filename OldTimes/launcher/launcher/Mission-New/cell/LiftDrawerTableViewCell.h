//
//  LiftDrawerTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SWTableViewCell.h"

@interface LiftDrawerTableViewCell : SWTableViewCell

- (void)setIconImageName:(NSString *)imgName;
- (void)setCellTitle:(NSString *)title;
- (void)setNumberWithUnRead:(NSInteger)unreadNum allNumber:(NSInteger)allNumber isShow:(BOOL)isShow;
- (void)setNumberWithallNumber:(NSInteger)allNumber;

- (void)setCellIsSelect:(BOOL)isSelect;

@end
