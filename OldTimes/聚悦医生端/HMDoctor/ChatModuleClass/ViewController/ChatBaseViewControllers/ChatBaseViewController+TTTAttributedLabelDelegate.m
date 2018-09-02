//
//  ChatBaseViewController+TTTAttributedLabelDelegate.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatBaseViewController+TTTAttributedLabelDelegate.h"
#import <SVWebViewController/SVWebViewController.h>
#import "RichTextConstant.h"

@implementation ChatBaseViewController (TTTAttributedLabelDelegate)

#pragma mark - TTTAttributeLabel Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSArray *res = [phoneNumber componentsSeparatedByString:LINK_SPLIT];
    if([res count] == 2){
        UIAlertController *actionSheet;
        if([res[0] isEqualToString:PHONE_SPLIT]){
            NSString *phone = [res[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *title = [NSString stringWithFormat:@"%@可能是一个电话号码，你可以", phone];
            actionSheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 呼叫
                if(!phone.length){
                    return;
                }
                NSString *phoneCall =[NSString stringWithFormat:@"tel:%@",phone];
                NSURL *url = [NSURL URLWithString:phoneCall];
                [[UIApplication sharedApplication] openURL:url];
                
            }];
            UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 复制
                if(!phone.length){
                    return;
                }
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                pboard.string = phone;
                
            }];
            [actionSheet addAction:cancelAction];
            [actionSheet addAction:callAction];
            [actionSheet addAction:copyAction];
            
        }
        if([res[0] isEqualToString:EMAIL_SPLIT]){
            NSString *email = res[1];
            NSString *title = [NSString stringWithFormat:@"向%@发送邮件",email];
            
            actionSheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *useAction = [UIAlertAction actionWithTitle:@"使用默认邮件账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 发邮件
                if(!email.length){
                    return;
                }
                NSString *emailString =[NSString stringWithFormat:@"mailto:%@",email];
                NSURL *url = [NSURL URLWithString:emailString];
                [[UIApplication sharedApplication] openURL:url];
                
                
            }];
            UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 复制
                if(!email.length){
                    return;
                }
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                pboard.string = email;
                
            }];
            [actionSheet addAction:cancelAction];
            [actionSheet addAction:useAction];
            [actionSheet addAction:copyAction];
        }
        if (!actionSheet) {
            return;
        }
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

@end
