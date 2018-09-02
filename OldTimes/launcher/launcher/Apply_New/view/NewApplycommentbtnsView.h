//
//  NewApplycommentbtnsView.h
//  launcher
//
//  Created by 马晓波 on 16/1/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passvalueblock)(NSInteger);
@interface NewApplycommentbtnsView : UIView
@property (nonatomic,copy) passvalueblock myblock;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame WithBtnTitleArray:(NSArray *)array;
- (void)setblock:(passvalueblock)block;

@end
