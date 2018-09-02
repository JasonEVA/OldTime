//
//  LinkLabel.h
//  launcher
//
//  Created by Lars Chen on 15/12/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  url,phone,@

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface LinkLabel : TTTAttributedLabel

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *highlightBackgroundColor;

/**
 *  设置文字样式
 *
 *  @param richText   文字
 *  @param atUserList @人员数组（uid@name）
 */
- (void)setRichText:(NSString *)richText atUserList:(NSArray *)atUserList;

@end
