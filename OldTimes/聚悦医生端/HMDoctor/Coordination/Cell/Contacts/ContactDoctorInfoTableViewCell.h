//
//  ContactDoctorInfoTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//  加好友医生cell

#import <UIKit/UIKit.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ContactInfoModel.h"

@class DoctorCompletionInfoModel;

typedef void (^ContactDoctorInfoTableViewCellBlock)();
@interface ContactDoctorInfoTableViewCell : UITableViewCell

@property (nonatomic)  BOOL  acceptState; // <##>
@property (nonatomic, strong)  UIButton  *btnAccept; // <##>
//接受好友请求数据方法
- (void)setDataWithModel:(MessageRelationValidateModel *)model;
//发起好友请求数据方法
- (void)sendDateWithModel:(ContactInfoModel *)model;

- (void)clickBlock:(ContactDoctorInfoTableViewCellBlock)block;

- (void)configDoctorCompletionInfoModel:(DoctorCompletionInfoModel *)model;
//全局搜索聊天记录用
- (void)fillDataWithMessageBaseModel:(MessageBaseModel *)model searchText:(NSString *)searchText;
//联系人模糊搜索用
- (void)fillDataWithMessageRelationInfoModel:(MessageRelationInfoModel *)model searchText:(NSString *)searchText;
@end
