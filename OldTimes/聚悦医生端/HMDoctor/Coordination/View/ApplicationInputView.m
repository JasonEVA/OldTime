//
//  ApplicationInputView.m
//  launcher
//
//  Created by William Zhang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationInputView.h"
//#import "WZPhotoPickerController.h"
#import "HMBaseViewController.h"
#import <Masonry/Masonry.h>
//#import "UIView+Util.h"
//#import "Category.h"
//#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "UIImage+EX.h"

@interface ApplicationInputView () <UIActionSheetDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) HMBaseViewController *parentVC;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView     *contentView;
@property (nonatomic, strong) UIButton   *sendButton;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) MASConstraint *textViewHeightConstraint;

@property (nonatomic, copy) void (^sendTextBlock)(NSString *);
@property (nonatomic, copy) void (^selectImageBlock)(UIImage *);

@end

@implementation ApplicationInputView

- (instancetype)initWithViewController:(HMBaseViewController *)viewController {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _parentVC = viewController;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithW:234];
        [self addSubview:self.addButton];
        [self addSubview:self.contentView];
        [self addSubview:self.placeholderLabel];
        [self initConstraints];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [self.textView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

- (void)initConstraints {
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.height.equalTo(@44);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addButton.mas_right);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addButton.mas_right).offset(5);
        make.centerY.equalTo(self.addButton);
    }];
}

#pragma mark - Button Click
//按钮暴力点击防御
- (void)defenseClick {
    [self.addButton setEnabled:YES];
    [self.sendButton setEnabled:YES];
}

- (void)clickToAddAttach {
    //按钮暴力点击防御
    [self.addButton setEnabled:NO];
    [self performSelector:@selector(defenseClick) withObject:nil afterDelay:0.5];

    [self.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
    !self.parentVC ?: [actionSheet showInView:self.parentVC.view];
}

- (void)clickToSend {
    //按钮暴力点击防御
    [self.sendButton setEnabled:NO];
    [self performSelector:@selector(defenseClick) withObject:nil afterDelay:0.5];

    if (![self.textView text].length) {
        return;
    }
    
    if (self.sendTextBlock) {
        self.sendTextBlock(self.textView.text);
//        [self.textView resignFirstResponder];
    }
}

#pragma mark - Interface Method
- (void)sendText:(void (^)(NSString *))textBlock {
    self.sendTextBlock = textBlock;
}

- (void)selectImage:(void (^)(UIImage *))selectImageBlock {
    self.selectImageBlock = selectImageBlock;
}

- (void)clearText {
    self.textView.text = @"";
    [self textViewDidChange];
}

- (NSString *)inputText
{
    return [self.textView text];
}

- (void)resignfirstResponder
{
    [self.textView resignFirstResponder];
}
- (void)inputViewBecomeFirstResponder {
    [self.textView becomeFirstResponder];
}

#pragma mark - Private Method
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *keyboardInfo = notification.userInfo;
    
    double animateDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    BOOL heightRefresh = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(endFrame) > 0;
    
    if (!self.superview) {
        return;
    }
    
    if (!self.bottomConstraint) {
        for (NSLayoutConstraint *constraint in [self.superview constraints]) {
            if (constraint.firstAttribute == NSLayoutAttributeBottom && constraint.firstItem == self) {
                self.bottomConstraint = constraint;
                break;
            }
        }
    }
    
    if (!self.bottomConstraint) {
        return;
    }
    
    CGFloat heightOffset = 0;
    if (heightRefresh) {
        heightOffset = -CGRectGetHeight(endFrame);
    }
    
    self.bottomConstraint.constant = heightOffset;
    [UIView animateWithDuration:animateDuration animations:^{
        [self.superview layoutIfNeeded];
        [self layoutIfNeeded];
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat height = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height;
    if (height > 120) {
        height = 120;
    }
    
    self.textViewHeightConstraint.offset = height;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.parentVC) {
        return;
    }
    
    if (buttonIndex == 0) {
        // 照相
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self.parentVC at_postError:@"没有发现摄像头"];
            return;
        }
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        [self.parentVC presentViewController:pickerController animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        // 相册
//        WZPhotoPickerController *pickerController = [[WZPhotoPickerController alloc] init];
//        pickerController.delegate = self;
//        pickerController.maximumNumberOfSelection = 1;
//        [self.parentVC presentViewController:pickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    !self.selectImageBlock ?: self.selectImageBlock(image);
    
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WZImagePickerController Delegate
//- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
//    ALAsset *firstAsset = [assets firstObject];
//    ALAssetRepresentation *representation = [firstAsset defaultRepresentation];
//    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
//    
//    !self.selectImageBlock ?: self.selectImageBlock(image);
//    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - UITextView Delegate
- (void)textViewDidChange {
    self.placeholderLabel.hidden = [self.textView text].length;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.dalegate respondsToSelector:@selector(ApplicationInputViewDelegateCallBack_didStartEdit)]) {
        [self.dalegate ApplicationInputViewDelegateCallBack_didStartEdit];
    }
}

#pragma mark - Initializer
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton new];
        [_addButton setImage:[UIImage imageNamed:@"message_chat_btnAdd"] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor clearColor]];
        [_addButton addTarget:self action:@selector(clickToAddAttach) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithW:234];
        _contentView.layer.cornerRadius = 5;
        _contentView.clipsToBounds = YES;
        
        [_contentView addSubview:self.textView];
        [_contentView addSubview:self.sendButton];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_contentView);
            self.textViewHeightConstraint = make.height.equalTo(@30).priorityHigh();
            make.right.equalTo(self.sendButton.mas_left).offset(-10);
        }];
        
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentView);
            make.top.bottom.equalTo(self.textView);
            make.width.equalTo(@50);
        }];
    }
    return _contentView;
}

- (UITextView *)textView {
    if (!_textView) {
        NSTextStorage *storage = [NSTextStorage new];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [storage addLayoutManager:layoutManager];
        NSTextContainer *container = [NSTextContainer new];
        container.widthTracksTextView = YES;
        container.heightTracksTextView = YES;
        [layoutManager addTextContainer:container];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:container];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        [_textView setDelegate:self];
        [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        [_textView.layer setCornerRadius:5];
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton titleLabel].font = [UIFont systemFontOfSize:15];
        [_sendButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor colorWithHex:0x0099ff] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(clickToSend) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton.layer setCornerRadius:5];
        [_sendButton setClipsToBounds:YES];
        //_sendButton.expandSize = CGSizeMake(10, 0);
    }
    return _sendButton;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = @"评论";
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
    }
    return _placeholderLabel;
}

@end
