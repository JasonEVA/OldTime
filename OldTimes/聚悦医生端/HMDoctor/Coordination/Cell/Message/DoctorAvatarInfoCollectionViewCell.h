//
//  DoctorAvatarInfoCollectionViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserProfileModel;
@interface DoctorAvatarInfoCollectionViewCell : UICollectionViewCell

- (void)configCellData:(UserProfileModel *)model;

- (void)configNativeImage:(UIImage *)nativeImage name:(NSString *)name position:(NSString *)position;
@end
