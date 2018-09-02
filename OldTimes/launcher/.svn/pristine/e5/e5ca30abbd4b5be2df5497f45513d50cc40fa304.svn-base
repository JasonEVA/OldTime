//
//  NewApplyAtttachmentTableviewCell.h
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewApplyAtttachmentTableviewCell : UITableViewCell


+ (NSString *)identifier;
+ (CGFloat)heightForCellWithImages:(NSArray *)images;
+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count accessoryMode:(BOOL)accessoryMode;

- (void)setImages:(NSArray *)images;

/** 点击查看大图 */
- (void)clickToSeeImage:(void(^)(NSUInteger clickedIndex))clickBlock;

@property (nonatomic, readonly) UILabel *titleLabel;

- (void)setTitleLabelText:(NSString *)text;

@end
