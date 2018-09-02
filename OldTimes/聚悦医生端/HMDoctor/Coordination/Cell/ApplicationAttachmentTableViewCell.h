//
//  ApplicationAttachmentTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  application 统一附件cell

#import <UIKit/UIKit.h>

@interface ApplicationAttachmentTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count;
+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count accessoryMode:(BOOL)accessoryMode;

// 设置图片
- (void)configOriImages:(NSArray<UIImage *> *)images;

// 设置图片路径
- (void)configImagePath:(NSArray<NSString *> *)arrayPaths;

/** 点击查看大图 */
- (void)clickToSeeImage:(void(^)(NSUInteger clickedIndex))clickBlock;

@property (nonatomic, readonly) UILabel *titleLabel;

@end
