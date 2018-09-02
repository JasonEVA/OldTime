//
//  MeReviseMobileNoViewController.h
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactPersonDetailInformationModel.h"

typedef void(^GetbackDataBlock)(NSString *);
@interface MeReviseMobileNoViewController : BaseViewController
@property (nonatomic, strong) ContactPersonDetailInformationModel *myInfoModel;
- (void)setBlock:(GetbackDataBlock)block;
@end
