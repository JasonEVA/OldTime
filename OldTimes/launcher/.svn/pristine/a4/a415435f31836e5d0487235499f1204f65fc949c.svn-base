//
//  SelectContactCollectionViewCell.m
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactCollectionViewCell.h"
#import "ContactPersonDetailInformationModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"

@interface SelectContactCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SelectContactCollectionViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setData:(ContactPersonDetailInformationModel *)model {
    if ([model isKindOfClass:[UserProfileModel class]]) {
        [self.imageView setImage:[UIImage imageNamed:@"group_defalut_avatar"]];
        return;
    }
    
    NSString *showId;
    
    if ([model isKindOfClass:[MessageRelationInfoModel class]]) {
        showId = [(id)model relationName];
    } else {
        showId = model.show_id;
    }
    
    [self.imageView sd_setImageWithURL:avatarURL(avatarType_60, showId) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
}

#pragma mark - Initializer
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = 3;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
