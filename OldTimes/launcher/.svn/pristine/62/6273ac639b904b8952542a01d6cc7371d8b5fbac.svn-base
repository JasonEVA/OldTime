//
//  MJRefreshUtil.m
//  launcher
//
//  Created by williamzhang on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MJRefreshUtil.h"
#import "MyDefine.h"
#import "NewMJRefreshGifHeader.h"
#import "NewMJRefreshGifFooter.h"

#if defined(JAPANMODE) || defined(JAPANTESTMODE)
#define WZ_REFRESH_TIME 2.5
#else
#define WZ_REFRESH_TIME 0.77
#endif

@interface WZ_MJRefreshUtil : NSObject

@end

@implementation WZ_MJRefreshUtil

+ (void)exchangeClass:(Class)class OriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector; {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    //    BOOL success = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //
    //    if (success) {
    //        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    //
    //    } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
    //    }
}

+ (NSArray *)loadingImages {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
    return @[[UIImage imageNamed:@"loading_japan_1"],
             [UIImage imageNamed:@"loading_japan_2"],
             [UIImage imageNamed:@"loading_japan_3"],
             [UIImage imageNamed:@"loading_japan_4"],
             [UIImage imageNamed:@"loading_japan_5"],
             [UIImage imageNamed:@"loading_japan_6"],
             [UIImage imageNamed:@"loading_japan_7"],
             [UIImage imageNamed:@"loading_japan_8"],
             [UIImage imageNamed:@"loading_japan_9"],
             [UIImage imageNamed:@"loading_japan_10"],
             [UIImage imageNamed:@"loading_japan_11"],
             [UIImage imageNamed:@"loading_japan_12"],
             [UIImage imageNamed:@"loading_japan_13"],
             [UIImage imageNamed:@"loading_japan_14"],
             [UIImage imageNamed:@"loading_japan_15"],
             [UIImage imageNamed:@"loading_japan_16"],
             [UIImage imageNamed:@"loading_japan_17"],
             [UIImage imageNamed:@"loading_japan_16"],
             [UIImage imageNamed:@"loading_japan_15"],
             [UIImage imageNamed:@"loading_japan_14"],
             [UIImage imageNamed:@"loading_japan_13"],
             [UIImage imageNamed:@"loading_japan_12"],
             [UIImage imageNamed:@"loading_japan_11"],
             [UIImage imageNamed:@"loading_japan_10"],
             [UIImage imageNamed:@"loading_japan_9"],
             [UIImage imageNamed:@"loading_japan_8"],
             [UIImage imageNamed:@"loading_japan_7"],
             [UIImage imageNamed:@"loading_japan_6"],
             [UIImage imageNamed:@"loading_japan_5"],
             [UIImage imageNamed:@"loading_japan_4"],
             [UIImage imageNamed:@"loading_japan_3"],
             [UIImage imageNamed:@"loading_japan_2"],
             [UIImage imageNamed:@"loading_japan_1"]
             ];
#else
    return @[[UIImage imageNamed:@"loading_1"],
             [UIImage imageNamed:@"loading_2"],
             [UIImage imageNamed:@"loading_3"],
             [UIImage imageNamed:@"loading_4"],
             [UIImage imageNamed:@"loading_5"],
             [UIImage imageNamed:@"loading_6"],
             [UIImage imageNamed:@"loading_7"],
             [UIImage imageNamed:@"loading_8"],
             [UIImage imageNamed:@"loading_9"],
             [UIImage imageNamed:@"loading_10"],
             [UIImage imageNamed:@"loading_11"]
             ];
#endif
}

@end

@implementation MJRefreshHeader (Util)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WZ_MJRefreshUtil exchangeClass:self
                       OriginalSelector:@selector(headerWithRefreshingTarget:refreshingAction:)
                       swizzledSelector:@selector(wz_headerWithRefreshingTarget:refreshingAction:)];
        
        [WZ_MJRefreshUtil exchangeClass:self
                       OriginalSelector:@selector(headerWithRefreshingBlock:)
                       swizzledSelector:@selector(wz_headerWithRefreshingBlock:)];
    });
}

+ (instancetype)wz_headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshHeader *header = [NewMJRefreshGifHeader wz_headerWithRefreshingTarget:target refreshingAction:action];
    return [self headerStateNormal:header];
}

+ (instancetype)wz_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    MJRefreshHeader *header = [NewMJRefreshGifHeader wz_headerWithRefreshingBlock:refreshingBlock];
    return [self headerStateNormal:header];
}

+ (MJRefreshHeader *)headerStateNormal:(MJRefreshHeader *)header {
    
    NewMJRefreshGifHeader *gifHeader = (NewMJRefreshGifHeader *)header;
    [gifHeader setImages:[WZ_MJRefreshUtil loadingImages] duration:WZ_REFRESH_TIME forState:MJRefreshStateIdle];
    [gifHeader setImages:[WZ_MJRefreshUtil loadingImages] duration:WZ_REFRESH_TIME forState:MJRefreshStatePulling];
    [gifHeader setImages:[WZ_MJRefreshUtil loadingImages] duration:WZ_REFRESH_TIME forState:MJRefreshStateRefreshing];
    
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    return gifHeader;
    // 不需要了之后的，已经做成gif
//    if ([header class] == [MJRefreshHeader class]) {
//        return header;
//    }
//    
//    MJRefreshStateHeader *stateHeader = (MJRefreshStateHeader *)header;
//    
//    [stateHeader lastUpdatedTimeLabel].text = @"";
//    [stateHeader setLastUpdatedTimeText:^NSString *(NSDate *date) {
//        return @"";
//    }];
//    
//    [stateHeader setTitle:LOCAL(PUSH_LOADING) forState:MJRefreshStateIdle];
//    [stateHeader setTitle:LOCAL(LOOSE_LOADING) forState:MJRefreshStatePulling];
//    [stateHeader setTitle:LOCAL(LOADING) forState:MJRefreshStateRefreshing];
//    
//    return stateHeader;
}

@end

@implementation MJRefreshFooter (Util)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WZ_MJRefreshUtil exchangeClass:self
                       OriginalSelector:@selector(footerWithRefreshingTarget:refreshingAction:)
                       swizzledSelector:@selector(wz_footerWithRefreshingTarget:refreshingAction:)];
        
        [WZ_MJRefreshUtil exchangeClass:self
                       OriginalSelector:@selector(footerWithRefreshingBlock:)
                       swizzledSelector:@selector(wz_footerWithRefreshingBlock:)];
    });
}

+ (instancetype)wz_footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshFooter *footer = [NewMJRefreshGifFooter wz_footerWithRefreshingTarget:target refreshingAction:action];
    return [self footerStateNormal:footer];
}

+ (instancetype)wz_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    MJRefreshFooter *footer = [NewMJRefreshGifFooter wz_footerWithRefreshingBlock:refreshingBlock];
    return [self footerStateNormal:footer];
}

+ (MJRefreshFooter *)footerStateNormal:(MJRefreshFooter *)footer {
    
    NewMJRefreshGifFooter *gifFooter = (NewMJRefreshGifFooter *)footer;
    [gifFooter setImages:[WZ_MJRefreshUtil loadingImages] duration:WZ_REFRESH_TIME forState:MJRefreshStateIdle];
    [gifFooter setImages:[WZ_MJRefreshUtil loadingImages] duration:WZ_REFRESH_TIME forState:MJRefreshStateRefreshing];

//    gifFooter.refreshingTitleHidden = YES;
    gifFooter.stateLabel.hidden = YES;

    return gifFooter;
    // 不需要了之后的，已经做成gif
//    if (![footer isKindOfClass:[MJRefreshBackStateFooter class]] && ![footer isKindOfClass:[MJRefreshAutoStateFooter class]]) {
//        return footer;
//    }
//    
//    if ([footer isKindOfClass:[MJRefreshAutoStateFooter class]]) {
//        [(MJRefreshAutoStateFooter *)footer setTitle:LOCAL(CLICK_MORE) forState:MJRefreshStateIdle];
//        [(MJRefreshAutoStateFooter *)footer setTitle:LOCAL(CLICK_LOADING) forState:MJRefreshStateRefreshing];
//        [(MJRefreshAutoStateFooter *)footer setTitle:LOCAL(CLICK_NULL) forState:MJRefreshStateNoMoreData];
//    }
//    
//    else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]) {
//        [(MJRefreshBackStateFooter *)footer setTitle:LOCAL(CLICK_MORE) forState:MJRefreshStateIdle];
//        [(MJRefreshBackStateFooter *)footer setTitle:LOCAL(CLICK_LOADING) forState:MJRefreshStateRefreshing];
//        [(MJRefreshBackStateFooter *)footer setTitle:LOCAL(CLICK_NULL) forState:MJRefreshStateNoMoreData];
//    }
//    
//    return footer;
}

@end
