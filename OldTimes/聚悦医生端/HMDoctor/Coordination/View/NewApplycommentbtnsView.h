//
//  NewApplycommentbtnsView.h
//  launcher
//
//  Created by 马晓波 on 16/1/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^passvalueblock)(TaskCommentType type);
typedef void(^WriteCommentButtonClicked)();
@interface NewApplycommentbtnsView : UIView
@property (nonatomic,strong) passvalueblock myblock;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame WithBtnTitleArray:(NSArray *)array;
- (void)setblock:(passvalueblock)block;
- (void)addNotiWriteCommentButtonClicked:(WriteCommentButtonClicked)block;
@end
