//
//  ServiceTeamMemberInfoView.h
//  HMClient
//
//  Created by Andrew Shen on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//  团队成员基本信息View

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^MemberClickedCompletion)(StaffInfo *staffInfo);

@protocol ServiceTeamMemberInfoViewDelegate <NSObject>

- (void)serviceTeamMemberInfoViewDelegateCallBack_memberClickedWithData:(id)memberData indexPath:(NSIndexPath *)indexPath;

@end

@interface ServiceTeamMemberInfoView : UIView

@property (nonatomic, weak)  id<ServiceTeamMemberInfoViewDelegate>  delegate; // <##>

/**
 *  指定初始化
 *
 *  @param layout   布局模式，nil时为默认样式
 *  @param itemSize cell大小
 *
 *  @return self
 */
- (instancetype)initWithFlowLayout:(nullable UICollectionViewFlowLayout *)layout itemSize:(CGSize)itemSize;


/**
 配置团队信息

 @param doctors                 成员信息
 @param memberClickedCompletion 成员点击回调
 */
- (void)configDoctorsInfo:(NSArray<StaffInfo *> *)doctors leaderID:(NSInteger)leaderID memberClickedCompletion:(MemberClickedCompletion)memberClickedCompletion;
@end
NS_ASSUME_NONNULL_END
