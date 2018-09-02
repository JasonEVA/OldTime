//
//  UITextView+AtUser.m
//  launcher
//
//  Created by williamzhang on 15/12/4.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UITextView+AtUser.h"
#import "ContactPersonDetailInformationModel.h"
#import <objc/runtime.h>
#import "UIFont+Util.h"
#import "MyDefine.h"

@implementation NSAttributedString (Identifier)

- (NSString *)identifier {
    NSDictionary *dict = [self attributesAtIndex:0 effectiveRange:nil];
    return [dict objectForKey:NSLinkAttributeName];
}

@end

@implementation UITextView (AtUser)

+ (NSDictionary *)dictionaryWithAt:(NSString *)at {
    if (at) {
        return @{NSFontAttributeName:[UIFont mtc_font_30],
                 NSForegroundColorAttributeName:[UIColor blackColor],
                 NSLinkAttributeName:at};
    }
    
    return @{NSForegroundColorAttributeName:[UIColor blackColor],
             NSFontAttributeName:[UIFont mtc_font_30]};
}

- (BOOL)wz_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL lastDelete = NO;
    BOOL isBetween = [self isBetweenAtStringInRange:range lastDelete:&lastDelete];
    NSMutableAttributedString *finalAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // range.length = 1 && text.length = 0 为删除
    if (range.length != 1 || [text length] != 0) {
        
        self.typingAttributes = @{NSFontAttributeName:[UIFont mtc_font_30],
                                  NSForegroundColorAttributeName:[UIColor blackColor]};
        return YES;
    }
    
    // 删除文字
    if (isBetween || !lastDelete) {
        
        self.typingAttributes = @{NSFontAttributeName:[UIFont mtc_font_30],
                                  NSForegroundColorAttributeName:[UIColor blackColor]};
        return YES;
    }
    
    // 在atUser最后删除
    NSInteger deleteLength = 0;
    for (NSInteger i = range.location; i >= 0; i--) {
        NSAttributedString *deletedString = [finalAttributeString attributedSubstringFromRange:NSMakeRange(i, 1)];
        if (deletedString.identifier) {
            deleteLength ++;
            if ([deletedString.string isEqualToString:@"@"]) {
                break;
            }
            continue;
        }
        break;
    }
    
    // 获取完@xxxx
    NSAttributedString *deleteString = [[NSAttributedString alloc] initWithString:@"" attributes:[UITextView dictionaryWithAt:nil]];
    [finalAttributeString replaceCharactersInRange:NSMakeRange(range.location + 1 - deleteLength, deleteLength) withAttributedString:deleteString];
    self.attributedText = finalAttributeString;
    [self setSelectedRange:NSMakeRange(range.location + 1 - deleteLength, 0)];
    return NO;
}

- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt {
    NSString *atUserString = [NSString stringWithFormat:@"@%@ ",atUser.u_true_name];
    
    NSRange selectedRange = [self selectedRange];
    
    if (!deleteFrontAt) {
        // 没有输入@，直接拼接@user，手动清除 周边的@信息
        [self wz_shouldChangeTextInRange:[self selectedRange] replacementText:@""];
    }
    
    // 待删除的文字个数
    NSInteger deleteCount = deleteFrontAt ? 1 : 0;
    
    NSString *identifier = [NSString stringWithFormat:@"%@@%@", atUser.show_id, atUser.u_true_name];
    if ([atUser.show_id isEqualToString:@"ALL"]) {
        identifier = [NSString stringWithFormat:@"ALL@%@", LOCAL(CHAT_ATALL)];
    }
    
    NSAttributedString *atUserAttributeString = [[NSAttributedString alloc] initWithString:atUserString attributes:[UITextView dictionaryWithAt:identifier]];
    
    // 获取@位置，即光标位置
    NSInteger cursorPosition = selectedRange.location;
    NSMutableAttributedString *finalAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // 替换@
    [finalAttributeString replaceCharactersInRange:NSMakeRange((cursorPosition >= deleteCount) ? (cursorPosition - deleteCount) : 0, deleteCount) withAttributedString:atUserAttributeString];
    
    self.attributedText = finalAttributeString;
    [self setSelectedRange:NSMakeRange(cursorPosition + atUserString.length - deleteCount, selectedRange.length)];
}

#pragma mark - Private Method
/**
 *  判断是否是在atUser中间处理
 *
 *  @param range      处理的文字range
 *  @param lastDelete 是否整段删除atUser
 *
 *  @return 是否在atUser中间处理
 */
- (BOOL)isBetweenAtStringInRange:(NSRange)range lastDelete:(BOOL *)lastDelete {
    NSString *frontIsAt = nil;
    NSRange selectedRange = [self selectedRange];
    NSInteger cursorPosition = selectedRange.location;
    cursorPosition --;
    if (self.text.length > cursorPosition) {
        NSAttributedString *attriString = [self.attributedText attributedSubstringFromRange:NSMakeRange(cursorPosition, 1)];
        if ([attriString.identifier length]) {
            frontIsAt = attriString.identifier;
        }
    }
    
    NSString *backIsAt = nil;
    if (cursorPosition + 1 < [self.attributedText.string length]) {
        NSAttributedString *attriString = [self.attributedText attributedSubstringFromRange:NSMakeRange(cursorPosition + 1, 1)];
        if ([attriString.identifier length]) {
            backIsAt = attriString.identifier;
        }
    }
    
    if ([frontIsAt length] && ![backIsAt isEqualToString:frontIsAt]) {
        *lastDelete = YES;
    }
    
    if ([backIsAt length] && [backIsAt isEqualToString:frontIsAt]) {
        // 是在atUser中间，将此字段变为普通字段
        
        NSMutableAttributedString *finalAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        for (NSInteger i = cursorPosition + 1; i < finalAttributeString.string.length; i ++) {
            
            NSAttributedString *atUserString = [self.attributedText attributedSubstringFromRange:NSMakeRange(i, 1)];
            
            if ([atUserString.identifier length] && ![atUserString.string isEqualToString:@"@"]) {
                [finalAttributeString removeAttribute:NSLinkAttributeName range:NSMakeRange(i, 1)];
                continue;
            }
            
            // 直到搜到没有identifer
            break;
        }
        
        for (NSInteger i = cursorPosition; i >= 0 ; i --) {
            
            NSAttributedString *atUserString = [self.attributedText attributedSubstringFromRange:NSMakeRange(i, 1)];
            
            if ([atUserString.identifier length]) {
                [finalAttributeString removeAttribute:NSLinkAttributeName range:NSMakeRange(i, 1)];
                if ([atUserString.string isEqualToString:@"@"]) {
                    // 搜到@退出
                    break;
                }
                
                continue;
            }
            
            // 没有identifer结束
            break;
        }
        
        self.attributedText = finalAttributeString;
        [self setSelectedRange:selectedRange];
    }
    
    return [backIsAt length] && [backIsAt isEqualToString:frontIsAt];
}

@end
