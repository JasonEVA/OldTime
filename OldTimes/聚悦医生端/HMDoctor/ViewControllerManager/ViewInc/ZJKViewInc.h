//
//  ZJKViewInc.h
//  HealthMgrDoctor
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#ifndef ZJKViewInc_h
#define ZJKViewInc_h

#define kHMHeaderBackgroundColor           @"48A2FB"
//#define kHMHeaderBackgroundColor           @"2FAC63"
#define kHMContentViewBackgroundColor      @"F0F0F0"

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kScreenScale    (kScreenWidth/320)
#define kScreenWidthScale    ((kScreenWidth/375.0)<1.0?1.0:(kScreenWidth/375.0))

#define KWIDTH(width) width/375.0*kScreenWidth

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)


#import "UIColor+HexExtension.h"
#import "UIImage+SizeExtension.h"
#import "UIView+Progress.h"
#import "UIView+SizeExtension.h"
#import "UIView+TopBottom.h"
#import "UIViewController+ShowAlert.h"
#import "NSString+SizeExtension.h"
//#import "UIBarButtonItem+Extension.h"

#import "UIImageView+WebCache.h"
#import "UITableViewController+Blank.h"
//#import "UITableView+BlankList.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"

#endif /* ZJKViewInc_h */
