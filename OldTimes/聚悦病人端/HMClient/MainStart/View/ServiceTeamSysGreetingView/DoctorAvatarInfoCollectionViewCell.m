//
//  DoctorAvatarInfoCollectionViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorAvatarInfoCollectionViewCell.h"
#import "DoctorAvatarInfoView.h"

@interface DoctorAvatarInfoCollectionViewCell()
@property (nonatomic, strong)  DoctorAvatarInfoView  *avatarInfoView; // <##>
@end

@implementation DoctorAvatarInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.avatarInfoView];
        [self.avatarInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configNativeImageName:(NSString *)nativeImageName name:(NSString *)name teamLeader:(BOOL)teamLeader {
    [self.avatarInfoView configImageName:nativeImageName name:name teamLeader:teamLeader];

}

- (DoctorAvatarInfoView *)avatarInfoView {
    if (!_avatarInfoView) {
        _avatarInfoView = [DoctorAvatarInfoView new];
    }
    return _avatarInfoView;
}
@end
