//
//  ApplyUserDefinedDetailViewController.h
//  launcher
//
//  Created by conanma on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"

typedef void(^clickToRemoveItem)();
typedef void (^backblock)(NSInteger);
typedef enum
{
    new_FromReceiver = 0,  //审批人
    new_FromSender = 1,    //申请人
}new_VCfrom;

typedef enum
{
    new_Pass_nil = 0,
    new_Pass_From_Receiver = 1,
    new_Pass_From_CC = 2,
}new_Pass_ComesFrom;

@interface ApplyUserDefinedDetailViewController : ApplicationCommentBaseViewController

@property (nonatomic, strong) NSMutableArray *arrattachments;
@property (nonatomic) BOOL disappearapprel;
@property (nonatomic, strong) backblock backblock;

- (instancetype)initWithFrom:(new_VCfrom)VCfrom From:(new_Pass_ComesFrom)ComeFrom withShowID:(NSString *)ShowID;
- (void)clickToRemoveWithBlock:(clickToRemoveItem)removeBlock;
- (void)backblock:(backblock)backblock;

@end
