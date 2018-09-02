//
//  LinkLabel.m
//  launcher
//
//  Created by Lars Chen on 15/12/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "LinkLabel.h"
#import "RichTextConstant.h"
#import "MyDefine.h"
#import "Category.h"

static NSString *mailRegex  = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
static NSString *phoneRegex = @"\\d{11}|\\d{10}|\\d{9}|\\d{8}|\\d{7}|\\d{6}|\\d{5}|\\d{4}|\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}";
static NSString *urlRegex   = @"((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?((?:(?:[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}\\.)+(?:(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])|(?:biz|b[abdefghijmnorstvwyz])|(?:cat|com|coop|c[acdfghiklmnoruvxyz])|d[ejkmoz]|(?:edu|e[cegrstu])|f[ijkmor]|(?:gov|g[abdefghilmnpqrstuwy])|h[kmnrtu]|(?:info|int|i[delmnoqrst])|(?:jobs|j[emop])|k[eghimnrwyz]|l[abcikrstuvy]|(?:mil|mobi|museum|m[acdghklmnopqrstuvwxyz])|(?:name|net|n[acefgilopruz])|(?:org|om)|(?:pro|p[aefghklmnrstwy])|qa|r[eouw]|s[abcdeghijklmnortuvyz]|(?:tel|travel|t[cdfghjklmnoprtvwz])|u[agkmsyz]|v[aceginu]|w[fs]|y[etu]|z[amw]))|(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)";

@interface LinkLabel ()

@property (nonatomic, strong) dispatch_queue_t messageRenderQueue;

@end

@implementation LinkLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
    }
    return self;
}

- (NSAttributedString *)setRichText:(NSString *)richText atUserList:(NSArray *)atUserList {
    
    richText = richText ?: @"";
    
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
    
    UIFont  *font                        = [self font];
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
            if([urlString rangeOfString:@"http"].location == NSNotFound) {
                urlString = [@"http://" stringByAppendingString:urlString];
            }
            NSURL *url = [NSURL URLWithString:urlString];
            if (canAddLink)
            {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     @try {
                        [weakSelf addLinkToURL:url withRange:per.range];
                     } @catch (NSException *exception) {
                         PRINT_STRING(exception.reason);
                     } @finally {}
                 });
            }
        }
        
        // 电话手机号码
        NSArray *phoneMatch = [self checkPhone:richText];
        for (NSTextCheckingResult *per in phoneMatch)
        {
            NSString *phone = [richText substringWithRange:per.range];
			if ([self isVaildRichContentWithText:phone NotContainAtUserList:atUserList]) {
				NSString *linkName = [NSString stringWithFormat:@"%@%@%@",PHONE_SPLIT,LINK_SPLIT,phone];
				
				if (canAddLink)
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						@try {
							[weakSelf addLinkToPhoneNumber:linkName withRange:per.range];
						} @catch (NSException *exception) {
							PRINT_STRING(exception.reason);
						} @finally {}
						
					});
					
					if (per.range.length == 11) {
						return;
					}
				}
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
                    @try {
                        [weakSelf addLinkToPhoneNumber:linkName withRange:per.range];
                    } @catch (NSException *exception) {
                        PRINT_STRING(exception.reason);
                    } @finally {}


                });
            }
        }
    });
    
    return self.attributedText;
}

- (void)setRichText:(NSString *)richText {

	richText = richText ?: @"";
	[self setExtendsLinkTouchArea:NO];
	UIFont  *font                        = [self font];
	UIColor *highlightedColor            = [self highlightColor];
	
	NSArray *phoneMatches = [self checkPhone:richText];


	// link字符样式
	NSDictionary *linkAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
									 NSForegroundColorAttributeName:highlightedColor};
	self.linkAttributes = linkAttributes;
	
	// 点击link样式
	NSDictionary *activeLinkAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
										   NSForegroundColorAttributeName:highlightedColor};
	self.activeLinkAttributes = activeLinkAttributes;
	
	NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:richText attributes:@{NSFontAttributeName:[self font],NSForegroundColorAttributeName:[self textColor]}];
	
    [self setText:attributeString];
    
	[phoneMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
		if (result.range.location != NSNotFound) {
			[self setText:attributeString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {

				[mutableAttributedString setAttributes:@{NSFontAttributeName:font,
														 NSForegroundColorAttributeName:(__bridge id)highlightedColor.CGColor,
														 (NSString *)kTTTBackgroundCornerRadiusAttributeName:@2} range:result.range];
				
				return mutableAttributedString;
			}];
			
		}
		
	}];
	
	__weak typeof(self) weakSelf = self;
	dispatch_async(self.messageRenderQueue, ^{
		BOOL canAddLink = NO;
		// 防止复用的时候出错
		if ([richText isEqualToString:[self.attributedText string]])
		{
			canAddLink = YES;
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
						@try {
							[weakSelf addLinkToPhoneNumber:linkName withRange:per.range];
							
						} @catch (NSException *exception) {
							PRINT_STRING(exception.reason);
						} @finally {}
						
					});
					
					if (per.range.length == 11) {
						return;
					}
				}
		}
	});
    
}

- (BOOL)isVaildRichContentWithText:(NSString *)text NotContainAtUserList:(NSArray *)list {
	__block BOOL isVaild = YES;
	[list enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj rangeOfString:text].location != NSNotFound) {
			isVaild = NO;
			*stop = YES;
		}
	}];
	
	return isVaild;
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

@end
