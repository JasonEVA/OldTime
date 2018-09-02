//
//  MeEditTextViewController.h
//  launcher
//
//  Created by Kyle He on 15/9/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  姓名和办公室电话显示并修改界面

#import "BaseViewController.h"
#import "ContactPersonDetailInformationModel.h"

typedef void(^getTextWithBlock)(NSString *text);

@interface MeEditTextViewController : BaseViewController

@property(nonatomic, copy) NSString  *cellTitle;
@property (nonatomic, strong) ContactPersonDetailInformationModel *myInfoModel;
- (void)getContextWithBlock:(getTextWithBlock)context;
- (void)setData:(NSString *)string;
@end
