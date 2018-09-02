//
//  ApplyAcceptDetailViewController.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  点击cell进入的详情页面

#import "ApplicationCommentBaseViewController.h"

typedef void(^clickToRemoveItem)();
typedef void (^backblock)(NSInteger);

typedef enum
{
     FromReceiver = 0,  //审批人
     FromSender = 1,    //申请人
}VCfrom;

typedef enum
{
    Pass_nil = 0,
    Pass_From_Receiver = 1,
    Pass_From_CC = 2,
}Pass_ComesFrom;

@interface ApplyAcceptDetailViewController :ApplicationCommentBaseViewController

@property (nonatomic, strong) NSMutableArray *arrattachments;
@property (nonatomic) BOOL disappearapprel;
@property (nonatomic, strong) backblock backblock;

- (instancetype)initWithFrom:(VCfrom)VCfrom From:(Pass_ComesFrom)ComeFrom withShowID:(NSString *)ShowID;
- (void)clickToRemoveWithBlock:(clickToRemoveItem)removeBlock;
- (void)backblock:(backblock)backblock;

@end
