//
//  SingleChartViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SingleChartViewController.h"

@interface SingleChartViewController ()
<UITextViewDelegate>
{
    CGFloat keyboardhight;
}
@end

@implementation SingleChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    keyboardhight = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [chatview setHeight:self.view.height - keyboardhight];
    if ([messageInputView isKindOfClass:[IMTextMessageInputView class]])
    {
        IMTextMessageInputView* txtInputView = (IMTextMessageInputView*) messageInputView;
        [txtInputView.tvMessage setDelegate:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    keyboardhight = kbSize.height;
    //输入框位置动画加载
    //[self begainMoveUpAnimation:keyboardhight];
    [self keyboardHeightChange:keyboardhight];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //do something
    keyboardhight = 0;
    [self keyboardHeightChange:keyboardhight];
}

- (void) keyboardHeightChange:(CGFloat) aKeyboardhight
{
    keyboardhight = aKeyboardhight;
    [chatview setHeight:(self.view.height - aKeyboardhight)];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text && 0 < text.length) {
        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat txtHeight = textView.contentSize.height;
    
    CGFloat height = txtHeight + 9;
    if (height > 69) {
        height = 69;
    }
    
    //[messageInputView setHeight:height];
    [messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(height);
    }];
}
@end
