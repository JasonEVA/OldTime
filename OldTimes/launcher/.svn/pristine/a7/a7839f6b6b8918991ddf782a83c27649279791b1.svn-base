//
//  NewApplyDetailV2ViewController.h
//  launcher
//
//  Created by williamzhang on 16/4/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"

typedef void(^clickToRemoveItem)();
typedef void (^backblock)(NSInteger);

@interface NewApplyDetailV2ViewController : ApplicationCommentBaseViewController

@property (nonatomic, strong) NSMutableArray *arrattachments;
@property (nonatomic) BOOL disappearapprel;
@property (nonatomic, strong) backblock backblock;

- (instancetype)initWithShowID:(NSString *)ShowID;
- (void)clickToRemoveWithBlock:(clickToRemoveItem)removeBlock;
- (void)backblock:(backblock)backblock;
@end
