//
//  HMSelectImageCollectionViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSelectImageCollectionViewCell.h"

@interface HMSelectImageCollectionViewCell ()
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *JWImageView;
@property (nonatomic, copy) deleteImageBlock block;
@end

@implementation HMSelectImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.JWImageView];
        [self.contentView addSubview:self.deleteBtn];
        
        [self.JWImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.JWImageView.mas_top);
            make.centerX.equalTo(self.JWImageView.mas_right);
        }];
    }
    return self;
}

- (void)deleteImageClick:(deleteImageBlock)block {
    self.block = block;
}

- (void)btnClick {
    if (self.block) {
        self.block();
    }
}
- (void)fillDataWithImage:(UIImage *)image showDeleteBtn:(BOOL)show {
    [self.deleteBtn setHidden:!show];
    [self.JWImageView setImage:image];
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setImage:[UIImage imageNamed:@"im_delet"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)JWImageView {
    if (!_JWImageView) {
        _JWImageView = [UIImageView new];
    }
    return _JWImageView;
}

@end
