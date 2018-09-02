//
//  NewApplyDetailViewController.h
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"

typedef void(^clickToRemoveItem)();
typedef void (^backblock)(NSInteger);


@interface NewApplyDetailViewController :ApplicationCommentBaseViewController

@property (nonatomic, strong) NSMutableArray *arrattachments;
@property (nonatomic) BOOL disappearapprel;
@property (nonatomic, strong) backblock backblock;

- (instancetype)initWithShowID:(NSString *)ShowID;
- (void)clickToRemoveWithBlock:(clickToRemoveItem)removeBlock;
- (void)backblock:(backblock)backblock;
@end
