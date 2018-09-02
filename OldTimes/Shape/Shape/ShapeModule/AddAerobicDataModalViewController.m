//
//  AddAerobicDataModalViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/10/29.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AddAerobicDataModalViewController.h"
#import "AddAerobicDataView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DBUnifiedManager.h"

@interface AddAerobicDataModalViewController ()
@property (nonatomic, strong)  AddAerobicDataView  *alertView; // <##>
@property (nonatomic, strong)  MASConstraint  *centerY; // <##>

@end

@implementation AddAerobicDataModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
        baseView.backgroundColor = [UIColor blackColor];
        baseView.alpha = 0.7;
        [self.view addSubview:baseView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.view addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        self.centerY = make.centerY.equalTo(self.view);
        make.width.equalTo(@290);
        make.height.equalTo(@222);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.centerY.offset = 10;
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
//        [self.view layoutIfNeeded];
//    } completion:nil];
//}
- (void)setWeight:(CGFloat)weight fatRange:(NSString *)fatRange {
    __weak typeof (self) weakSelf = self;
    [self.alertView setWeight:weight fatRange:fatRange callBack:^(CGFloat weight, NSString *fatRange, BOOL confirm){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (confirm) {
            // 保存
            [[DBUnifiedManager share] saveWeight:weight];
            [[DBUnifiedManager share] saveFatRange:fatRange];
            [[NSNotificationCenter defaultCenter] postNotificationName:n_updateAerobicData object:nil];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            // 取消
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Private Method
- (void)keyboardChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue  *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardSize = value.CGRectValue;
    CGFloat insetsY = self.view.frame.size.height * 0.5 + 111 - keyboardSize.origin.y;
    NSLog(@"-------------->%f",insetsY);
    self.centerY.offset = insetsY > 0 ? - insetsY : 0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];

}


#pragma mark - Init
- (AddAerobicDataView *)alertView {
    if (!_alertView) {
        _alertView = [[AddAerobicDataView alloc] init];
    }
    return _alertView;
}

@end
