//
//  CoordinationFilterView.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^removeFromSuperViewBlock)();

@protocol CoordinationFilterViewDelegate <NSObject>

- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag;

@end

@interface CoordinationFilterView : UIView
@property (nonatomic, weak) id <CoordinationFilterViewDelegate> delegate;
@property (nonatomic,copy) NSNumber *selectedRow;      //选中行
- (instancetype)initWithImageNames:(NSArray *)imageNames titles:(NSArray *)titles tags:(NSArray *)tags;

- (instancetype)initWithImageNames:(NSArray *)imageNames titles:(NSArray *)titles tags:(NSArray *)tags topOffset:(CGFloat)topOffset;

- (void)removeAction:(removeFromSuperViewBlock)block;

@end
