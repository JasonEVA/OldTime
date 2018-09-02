//
//  ApplyDetail_ReviewTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  处理工具条cell

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FROMTYPE)
{
    kFromReciver = 0,
    kFromSender
};

typedef NS_ENUM(NSInteger, CONTENTTYPE) {
    kContentText = 0,
    kContentImg
};

@protocol ApplyDetail_ReviewTableViewCellBtnDelegate <NSObject>
- (void)ApplyDetail_ReviewTableViewCellPassTheBtn:(UIButton *)btn;
@end

@interface ApplyDetail_ReviewTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ApplyDetail_ReviewTableViewCellBtnDelegate>delegate;

+ (NSString *)identifier;

- (void)setIconWithType:(FROMTYPE)fromType;

@end
