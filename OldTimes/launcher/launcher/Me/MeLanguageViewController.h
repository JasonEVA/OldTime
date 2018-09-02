//
//  MeLanguageViewController.h
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "UnifiedUserInfoManager.h"

@interface MeLanguageViewController : BaseViewController
{
    LanguageEnum _currLanguageSetting;      // 当前用户设置语言
}
@property(nonatomic, copy) NSString  *selectedLanguage;


@end
