//
//  SelectContactCollectionViewCell.h
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  选人tabbar的头像cell

#import <UIKit/UIKit.h>

@interface SelectContactCollectionViewCell : UICollectionViewCell

+ (NSString *)identifier;

- (void)configCellImageViewWithImagePath:(NSString *)imagePath;
@end
