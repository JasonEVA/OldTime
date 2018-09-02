//
//  DoctorAvatarInfoCollectionViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorAvatarInfoCollectionViewCell.h"
#import "DoctorAvatarInfoView.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface DoctorAvatarInfoCollectionViewCell()
@property (nonatomic, strong)  DoctorAvatarInfoView  *avatarInfoView; // <##>
@end

@implementation DoctorAvatarInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarInfoView];
        [self.avatarInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configCellData:(UserProfileModel *)model {
    [self.avatarInfoView configMemberInfo:model];
}

- (void)configNativeImage:(UIImage *)nativeImage name:(NSString *)name position:(NSString *)position {
    [self.avatarInfoView configImage:nativeImage name:name position:position];

}

- (DoctorAvatarInfoView *)avatarInfoView {
    if (!_avatarInfoView) {
        _avatarInfoView = [DoctorAvatarInfoView new];
    }
    return _avatarInfoView;
}
@end
