//
//  TaskWhiteBoardCollectionViewCell.m
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskWhiteBoardCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface TaskWhiteBoardCollectionViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *txfdTitle;
@property (nonatomic, strong) UIButton    *btnDelete;

@property (nonatomic, copy) TaskWhiteBoardCollectionCellDeleteBlock deleteBlock;
@property (nonatomic, copy) TaskWhiteBoardCollectionCellDidEditBlock editBlock;

@end

@implementation TaskWhiteBoardCollectionViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 6.0;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.txfdTitle];
        [self.contentView addSubview:self.btnDelete];
        [self.txfdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.left.right.equalTo(self.contentView);
        }];
        
        [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.contentView).offset(5);
        }];
    }
    return self;
}

- (void)clickDelete:(TaskWhiteBoardCollectionCellDeleteBlock)deleteBlock edit:(TaskWhiteBoardCollectionCellDidEditBlock)editBlock {
    self.deleteBlock = deleteBlock;
    self.editBlock = editBlock;
}

#pragma mark - Button Click
- (void)clickToDelete {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.editBlock) {
        self.editBlock(self, textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Method
- (void)shakeShake:(BOOL)canShake {
    if (!canShake) {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
        return;
    }
    
    if ([self.layer animationForKey:@"shakeAnimation"]) {
        return;
    }
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = @-0.1;
    shake.toValue = @0.1;
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = FLT_MAX;
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    self.txfdTitle.text = title;
}

- (void)setCanEdit:(BOOL)canEdit {
    self.txfdTitle.enabled = canEdit;
}

- (void)setCanDelete:(BOOL)canDelete {
    self.btnDelete.hidden = !canDelete;
    [self shakeShake:canDelete];
}

- (void)setNewWhite:(BOOL)newWhite {
    self.txfdTitle.textColor = newWhite ? [UIColor mtc_colorWithHex:0xcbcbcb] : [UIColor mtc_colorWithHex:0x0099ff];
}

#pragma mark - Initializer
- (UITextField *)txfdTitle {
    if (!_txfdTitle) {
        _txfdTitle = [[UITextField alloc] init];
        [_txfdTitle setFont:[UIFont systemFontOfSize:15]];
        [_txfdTitle setTextColor:[UIColor mtc_colorWithHex:0x0099ff]];
        [_txfdTitle setTextAlignment:NSTextAlignmentCenter];
        [_txfdTitle setReturnKeyType:UIReturnKeyDone];
        
        [_txfdTitle setDelegate:self];
    }
    return _txfdTitle;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        
        [_btnDelete setImage:[UIImage imageNamed:@"X_gray"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(clickToDelete) forControlEvents:UIControlEventTouchUpInside];

        _btnDelete.hidden = YES;
    }
    return _btnDelete;
}

@end
