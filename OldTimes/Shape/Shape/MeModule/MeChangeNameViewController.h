//
//  MeChangeNameViewController.h
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//



#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,keyboardType){
    nameType,
    sexType,
    localionType,
    birthdarType
};

@protocol MeChangNameDelegate <NSObject>

- (void)MeChangeNameDelegateCallBack_update:(NSString *)content;

@end

@interface MeChangeNameViewController : BaseViewController

@property (nonatomic, assign)  id <MeChangNameDelegate>  delegate; // 委托

@property (nonatomic, copy) NSString *nameStr;
@end
