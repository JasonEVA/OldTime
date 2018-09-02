//
//  DoctorAvatarInfoCollectionViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生基本信息collectionViewCell

#import <UIKit/UIKit.h>

@interface DoctorAvatarInfoCollectionViewCell : UICollectionViewCell

- (void)configNativeImageName:(NSString *)nativeImageName name:(NSString *)name teamLeader:(BOOL)teamLeader;
@end
