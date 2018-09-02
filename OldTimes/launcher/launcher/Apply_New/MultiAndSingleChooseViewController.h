//
//  MultiAndSingleChooseViewController.h
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "NewApplyFormChooseModel.h"

typedef void(^multiAndSingleChooseCompletion)();

@interface MultiAndSingleChooseViewController : BaseViewController

- (instancetype)initWithModel:(NewApplyFormChooseModel *)model;


- (void)chooseCompltion:(multiAndSingleChooseCompletion)completion;

@end
