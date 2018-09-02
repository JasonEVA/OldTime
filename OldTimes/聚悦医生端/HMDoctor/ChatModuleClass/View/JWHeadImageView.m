//
//  JWHeadImageView.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "JWHeadImageView.h"
#import <math.h>

#define IMAGEHEIGHT 45
@interface JWHeadImageView ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, copy) NSArray *colorArr;
@end

@implementation JWHeadImageView

- (instancetype)init {
    if (self = [super init]) {
        self.colorArr = @[@"17c295",@"b38979",@"f2725e",@"f7b55e",@"4da9eb",@"5f70a7",@"568aad"];
        
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@IMAGEHEIGHT);
            make.center.equalTo(self);        }];
        
    }
    return self;
}

// 有url图片就展示，没有就使用string展示（采用SDWebImage）
- (void)fillImageWithName:(NSString *)name url:(NSURL *)url{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:[self createNikeNameImageName:[self dealWithNikeName:name]]];
}

// 本地根据nikeName生成图片
- (void)fillImageWithName:(NSString *)name {
    [self.avatarImageView setImage:[self createNikeNameImageName:[self dealWithNikeName:name]]];
}

// 使用本地指定图片
- (void)fillImageWithImage:(UIImage *)image {
    [self.avatarImageView setImage:image];
}


// 按规则截取nikeName
- (NSString *)dealWithNikeName:(NSString *)nikeName {
    // 筛除部分特殊符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"【】"];
    nikeName = [nikeName stringByTrimmingCharactersInSet:set];
    NSString *showName = @"";
    NSString *tempName = @"";

    NSRange range1 = [nikeName rangeOfString:@"-"];

    if (range1.length) {
        // 含有“-”
        tempName = [nikeName substringToIndex:range1.location];
    }
    else {
        // 不含“-”
        tempName = nikeName;
    }
    
    NSRange range2 = [tempName rangeOfString:@"("];

    if (range2.length) {
        // 含有“(”
        tempName = [tempName substringToIndex:range2.location];
    }
    else {
        // 不含“(”
        tempName = tempName;
    }
    
    if ([self isStringContainLetterWith:tempName]) {
        // 含有字母取前两个
        showName = [tempName substringToIndex:2];
    }
    else {
        // 不含字母
        if (!tempName.length) {
            
        }
        else if (tempName.length == 1)
        {
            showName = [tempName substringToIndex:1];
        }
        else if (tempName.length == 2)
        {
            showName = [tempName substringToIndex:2];
        }
        else if (tempName.length == 3)
        {
            showName = [tempName substringFromIndex:1];
        }
        else if (tempName.length == 4)
        {
            showName = [tempName substringFromIndex:2];
        }
        else {
            showName = [tempName substringToIndex:2];
        }
    }
    return showName;
}
// 检查是否含有字母
- (BOOL)isStringContainLetterWith:(NSString *)str {
    if (!str) {
        return NO;
    }
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}
// 根据nikeName绘制图片
- (UIImage *)createNikeNameImageName:(NSString *)name {
    UIImage *image = [ UIImage imageColor:[UIColor colorWithHexString:self.colorArr[ABS(name.hash % self.colorArr.count)]] size:CGSizeMake(IMAGEHEIGHT, IMAGEHEIGHT) cornerRadius:IMAGEHEIGHT / 2];
    
    CGSize size= CGSizeMake (IMAGEHEIGHT , IMAGEHEIGHT); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画名字
    
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    
    [name drawAtPoint : CGPointMake ( (IMAGEHEIGHT  - nameSize.width) / 2 , (IMAGEHEIGHT  - nameSize.height) / 2 ) withAttributes : @{ NSFontAttributeName :[ UIFont systemFontOfSize:14], NSForegroundColorAttributeName :[ UIColor colorWithHexString:@"ffffff" ] } ];
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = IMAGEHEIGHT / 2;
        _avatarImageView.clipsToBounds = YES;
        [_avatarImageView setImage:[UIImage imageNamed:@"group_defalut_avatar"]];
    }
    return _avatarImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
