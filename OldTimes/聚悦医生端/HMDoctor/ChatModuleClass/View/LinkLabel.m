//
//  LinkLabel.m
//  launcher
//
//  Created by Lars Chen on 15/12/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "LinkLabel.h"
#import "RichTextConstant.h"
//#import "Category.h"

static NSString *mailRegex  = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
static NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
static NSString *urlRegex   = @"((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?((?:(?:[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}\\.)+(?:(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])|(?:biz|b[abdefghijmnorstvwyz])|(?:cat|com|coop|c[acdfghiklmnoruvxyz])|d[ejkmoz]|(?:edu|e[cegrstu])|f[ijkmor]|(?:gov|g[abdefghilmnpqrstuwy])|h[kmnrtu]|(?:info|int|i[delmnoqrst])|(?:jobs|j[emop])|k[eghimnrwyz]|l[abcikrstuvy]|(?:mil|mobi|museum|m[acdghklmnopqrstuvwxyz])|(?:name|net|n[acefgilopruz])|(?:org|om)|(?:pro|p[aefghklmnrstwy])|qa|r[eouw]|s[abcdeghijklmnortuvyz]|(?:tel|travel|t[cdfghjklmnoprtvwz])|u[agkmsyz]|v[aceginu]|w[fs]|y[etu]|z[amw]))|(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)";

@interface LinkLabel ()

@property (nonatomic, strong) dispatch_queue_t messageRenderQueue;

@end

@implementation LinkLabel

- (void)setRichText:(NSString *)richText atUserList:(NSArray *)atUserList {
    // link字符样式
    NSDictionary *linkAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                     NSForegroundColorAttributeName:[self textColor]};
    self.linkAttributes = linkAttributes;
    
    // 点击link样式
    NSDictionary *activeLinkAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                           NSForegroundColorAttributeName:[self textColor]};
    self.activeLinkAttributes = activeLinkAttributes;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:richText attributes:@{NSFontAttributeName:[self font],
                                                                                                                         NSForegroundColorAttributeName:[self textColor]}];
    
    UIFont *font                         = [self font];
    UIColor *highlightedColor            = [self highlightColor];
    UIColor * highlightedBackgroundColor = [self highlightBackgroundColor];
    [self setExtendsLinkTouchArea:NO];
    [self setText:attributeString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        // @人员高亮
        // 记录是第几个@
        NSInteger atIndex = 0;
        for (NSInteger i = 0; i < [richText length]; i ++) {
            NSString *tmpText = [richText substringWithRange:NSMakeRange(i, 1)];
            if (![tmpText isEqualToString:@"@"]) {
                continue;
            }
            
            if (atIndex >= [atUserList count]) {
                // atUserlist中无数据，直接舍弃
                break;
            }
            NSString *atUser = [atUserList objectAtIndex:atIndex];
            atIndex ++;
            
            if (![atUser length]) {
                // 字段为空时跳过
                continue;
            }
            
            NSInteger atLocation = [atUser rangeOfString:@"@"].location;
            if (atLocation == NSNotFound) {
                continue;
            }
            
            NSRange trashRange = [atUser rangeOfString:@"●⁠"];
            if (trashRange.location != NSNotFound) {
                // 删除服务器遗留垃圾信息
                atUser = [atUser substringToIndex:trashRange.location];
            }
            NSInteger length = atUser.length - atLocation;
            // @"aEEEBQypXZck9yx6@Mintcode娘●⁠ \n"
            // 服务器历史遗留有上述片段，需删除● \n
            @try {
                [mutableAttributedString setAttributes:@{NSFontAttributeName:font,
                                                         NSForegroundColorAttributeName:(__bridge id)highlightedColor.CGColor,
                                                         (NSString *)kTTTBackgroundFillColorAttributeName:(__bridge id)highlightedBackgroundColor.CGColor,
                                                         (NSString *)kTTTBackgroundCornerRadiusAttributeName:@2} range:NSMakeRange(i, length)];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            @finally {
            }
            
        }
        
        return mutableAttributedString;
    }];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.messageRenderQueue, ^{
        BOOL canAddLink = NO;
        // 防止复用的时候出错
        if ([richText isEqualToString:[self.attributedText string]])
        {
            canAddLink = YES;
        }
        //url识别
        NSArray *urlMatch = [self checkUrl:richText];
        for (NSTextCheckingResult *per in urlMatch) {
            NSString *urlString = [richText substringWithRange:per.range];
            if([urlString rangeOfString:@"http"].location == NSNotFound){
                urlString = [@"http://" stringByAppendingString:urlString];
            }
            NSURL *url = [NSURL URLWithString:urlString];
            if (canAddLink)
            {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf addLinkToURL:url withRange:per.range];
                 });
            }
        }
        
        // 电话手机号码
        NSArray *phoneMatch = [self checkPhone:richText];
        for (NSTextCheckingResult *per in phoneMatch)
        {
            NSString *phone = [richText substringWithRange:per.range];
            NSString *linkName = [NSString stringWithFormat:@"%@%@%@",PHONE_SPLIT,LINK_SPLIT,phone];
            if (canAddLink)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addLinkToPhoneNumber:linkName withRange:per.range];
                });
            }
        }
        
        //邮箱识别
        NSArray *emailMatch = [self checkEmail:richText];
        for (NSTextCheckingResult *per in emailMatch)
        {
            NSString *email = [richText substringWithRange:per.range];
            NSString *linkName = [NSString stringWithFormat:@"%@%@%@",EMAIL_SPLIT,LINK_SPLIT,email];
            if (canAddLink)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addLinkToPhoneNumber:linkName withRange:per.range];
                });
            }
        }
    });
}

- (NSArray *)checkUrl:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray *)checkPhone:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:phoneRegex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray *)checkEmail:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:mailRegex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (dispatch_queue_t)messageRenderQueue
{
    if (!_messageRenderQueue)
    {
        _messageRenderQueue = dispatch_queue_create("IM.renderMessage", DISPATCH_QUEUE_SERIAL);
    }
    
    return _messageRenderQueue;
}

//重写了TTTAttributedLabel中的背景色方法
- (void)drawBackground:(CTFrameRef)frame
                  inRect:(CGRect)rect
                 context:(CGContextRef)c
{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CFIndex lineIndex = 0;
    for (id line in lines) {
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds((__bridge CTLineRef)line, &ascent, &descent, &leading) ;
        
        /**
         *  解决中英文数字字符混输状态下，高亮背景高度不同意问题
         *  因为TTT是一个字符一个字符画的背景，所以先将所有字符遍历，取出最大的高度和最小的Y，再交给TTT进行处理。
         *  这样画出来的高亮背景高度就会一致
         */
        CGFloat  myHeight = 0.0f;
        CGFloat  myY = 1000.0f;
        for (id glyphRun in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) glyphRun);
            UIEdgeInsets fillPadding = [[attributes objectForKey:kTTTBackgroundFillPaddingAttributeName] UIEdgeInsetsValue];
            CGRect runBounds = CGRectZero;
            CGFloat runAscent = 0.0f;
            CGFloat runDescent = 0.0f;
            runBounds.size.width = (CGFloat)CTRunGetTypographicBounds((__bridge CTRunRef)glyphRun, CFRangeMake(0, 0), &runAscent, &runDescent, NULL) + fillPadding.left + fillPadding.right;
            
            runBounds.origin.y = origins[lineIndex].y + rect.origin.y - fillPadding.bottom - rect.origin.y;
            runBounds.origin.y -= runDescent;
            
            //取较大高的作为整体高度
            myHeight = MAX((runAscent + runDescent + fillPadding.top + fillPadding.bottom), myHeight);
            
            //取较小的作为整体的Y
            myY = MIN(runBounds.origin.y, myY);
        }
        
        for (id glyphRun in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) glyphRun);
            CGColorRef strokeColor = (__bridge CGColorRef)[attributes objectForKey:kTTTBackgroundStrokeColorAttributeName];
            CGColorRef fillColor = (__bridge CGColorRef)[attributes objectForKey:kTTTBackgroundFillColorAttributeName];
            UIEdgeInsets fillPadding = [[attributes objectForKey:kTTTBackgroundFillPaddingAttributeName] UIEdgeInsetsValue];
            CGFloat cornerRadius = [[attributes objectForKey:kTTTBackgroundCornerRadiusAttributeName] floatValue];
            CGFloat lineWidth = [[attributes objectForKey:kTTTBackgroundLineWidthAttributeName] floatValue];
            
            if (strokeColor || fillColor) {
                CGRect runBounds = CGRectZero;
                CGFloat runAscent = 0.0f;
                CGFloat runDescent = 0.0f;
                
                runBounds.size.width = (CGFloat)CTRunGetTypographicBounds((__bridge CTRunRef)glyphRun, CFRangeMake(0, 0), &runAscent, &runDescent, NULL) + fillPadding.left + fillPadding.right;
                runBounds.size.height = myHeight;
                
                CGFloat xOffset = 0.0f;
                CFRange glyphRange = CTRunGetStringRange((__bridge CTRunRef)glyphRun);
                switch (CTRunGetStatus((__bridge CTRunRef)glyphRun)) {
                    case kCTRunStatusRightToLeft:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location + glyphRange.length, NULL);
                        break;
                    default:
                        xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, glyphRange.location, NULL);
                        break;
                }
                
                runBounds.origin.x = origins[lineIndex].x + rect.origin.x + xOffset - fillPadding.left - rect.origin.x;
                runBounds.origin.y = myY;
                
                // Don't draw higlightedLinkBackground too far to the right
                if (CGRectGetWidth(runBounds) > width) {
                    runBounds.size.width = width;
                }
                
                CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(UIEdgeInsetsInsetRect(runBounds, self.linkBackgroundEdgeInset), lineWidth, lineWidth) cornerRadius:cornerRadius] CGPath];
                
                CGContextSetLineJoin(c, kCGLineJoinRound);
                
                if (fillColor) {
                    CGContextSetFillColorWithColor(c, fillColor);
                    CGContextAddPath(c, path);
                    CGContextFillPath(c);
                }
                
                if (strokeColor) {
                    CGContextSetStrokeColorWithColor(c, strokeColor);
                    CGContextAddPath(c, path);
                    CGContextStrokePath(c);
                }
            }
        }
        
        lineIndex++;
    }
}

@end
