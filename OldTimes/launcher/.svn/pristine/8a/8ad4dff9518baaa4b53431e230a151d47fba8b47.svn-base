//
//  NewCalenadarMapTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick)(BOOL);

@class PlaceModel;

@interface NewCalenadarMapTableViewCell : UITableViewCell
+ (NSString *)identifier;
+ (CGFloat)height;

/** 设置地图位置 */
- (void)mapWithPlaceModel:(PlaceModel *)placeModel;

/** 设置箭头，不设置则是定位图片 */
- (void)setAccessoryDisclosureIndicator;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needMap:(BOOL)needmap;
- (void)setBlock:(btnClick)block;
- (void)setbtnselectd:(BOOL)selected;
@end
