//
//  unifiedUserInfoManager.m
//  VMarket
//
//  Created by Andrew Shen on 15/8/7.
//
//

#import "unifiedUserInfoManager.h"
#import "LoginResultModel.h"
#import "MeGetUserInfoModel.h"

static NSString *const kUserName = @"userName";
static NSString *const kToken = @"token";
static NSString *const kPhone = @"phone";

static NSString *const kheadIcon = @"headIcon";	//头像文件名	String
static NSString *const klocation = @"location";	//所在地	String
static NSString *const kbirthYear = @"birthYear";	//出生_年	Int
static NSString *const kbirthMonth = @"birthMonth";	//出生_月	Int
static NSString *const kheight = @"height";	//身高	Int	单位：CM
static NSString *const kweight = @"weight";	//体重	Double	单位：KG
static NSString *const kheadIconUrl = @"headIconUrl";   //头像文件Url
static NSString *const kuserName = @"userName";
static NSString *const kgender = @"gender";         //性别
@implementation unifiedUserInfoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
#pragma mark - Interface Method
+ (unifiedUserInfoManager *)share{
    static unifiedUserInfoManager *userInfoMgr  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoMgr = [[self alloc] init];
    });
    return userInfoMgr;
}

- (BOOL)loginStatus {
    if ([self getLoginResultData].token.length > 0) {
        return YES;
    }
    return NO;
}


- (void)saveLoginResultModel:(LoginResultModel *)model
{
    [_defaults setObject:model.token forKey:kToken];
    [_defaults setObject:model.userName forKey:kUserName];
    [_defaults setObject:model.phone forKey:kPhone];
    [_defaults synchronize];
}

- (LoginResultModel *)getLoginResultData
{
    LoginResultModel *model =[[LoginResultModel alloc] init];
    model.token = [_defaults objectForKey:kToken];
    model.userName = [_defaults objectForKey:kUserName];
    model.phone = [_defaults objectForKey:kPhone];
    return model;
}

/**
 *  保存用户信息
 *
 *  @param model 用户信息model
 */
- (void)saveUserInfoData:(MeGetUserInfoModel *)model {
    [_defaults setObject:model.headIconUrl forKey:kheadIcon];
    [_defaults setObject:model.location forKey:klocation];
    [_defaults setObject:[NSNumber numberWithInteger:model.birthYear] forKey:kbirthYear];
    [_defaults setObject:[NSNumber numberWithInteger:model.birthMonth] forKey:kbirthMonth];
    [_defaults setObject:[NSNumber numberWithInteger:model.height] forKey:kheight];
    [_defaults setObject:[NSNumber numberWithFloat:model.weight] forKey:kweight];
    [_defaults setObject:model.headIconUrl forKey:kheadIconUrl];
    [_defaults setObject:model.userName forKey:kuserName];
    [_defaults setObject:[NSNumber numberWithInteger:model.gender] forKey:kgender];
}

/**
 *  获取用户信息model
 *
 *  @return 用户信息model
 */
- (MeGetUserInfoModel *)getUserInfoModel {
    MeGetUserInfoModel *model = [[MeGetUserInfoModel alloc] init];
    model.headIcon = [_defaults objectForKey:kheadIcon];
    model.location = [_defaults objectForKey:klocation];
    model.birthYear = ((NSNumber *)[_defaults objectForKey:kbirthYear]).integerValue;
    model.birthMonth = ((NSNumber *)[_defaults objectForKey:kbirthMonth]).integerValue;
    model.height = ((NSNumber *)[_defaults objectForKey:kheight]).integerValue;
    model.weight = ((NSNumber *)[_defaults objectForKey:kweight]).floatValue;
    model.headIconUrl = [_defaults objectForKey:kheadIconUrl];
    model.userName = [_defaults objectForKey:kuserName];
    model.gender = ((NSNumber *)[_defaults objectForKey:kgender]).integerValue;
    return model;
}

// 删除用户信息
- (void)removeUserInfo
{
    [_defaults removeObjectForKey:kToken];
    [_defaults removeObjectForKey:kUserName];
    [_defaults removeObjectForKey:kPhone];
    
    [_defaults synchronize];
}

// 注册完成计算fatRange,只用一次
- (NSString *)calculateFatRange {
    NSInteger bornYear = ((NSNumber *)[_defaults objectForKey:kbirthYear]).integerValue;
    NSInteger gender = ((NSNumber *)[_defaults objectForKey:kgender]).integerValue;
    NSInteger height = ((NSNumber *)[_defaults objectForKey:kheight]).integerValue;
    NSInteger weight = ((NSNumber *)[_defaults objectForKey:kweight]).floatValue;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger age = dateComponents.year - bornYear;
    
    CGFloat fatPercentage = 1.2 * (weight / pow((height * 0.01), 2)) + 0.23 * age - 5.4 - 10.8 * gender;
    
    return [self fatRangeWithFatPercentage:fatPercentage];
}

- (NSString *)fatRangeWithFatPercentage:(CGFloat)percentage {
    CGFloat new = percentage * 100;
    NSString *fatRange = @"";
    if (new < 8) {
        fatRange = @"<8%";
    } else if (new >= 8 && new < 12) {
        fatRange = @"8%~12%";
        
    } else if (new >= 12 && new < 15) {
        fatRange = @"12%~15%";
        
    } else if (new >= 15 && new < 20) {
        fatRange = @"15%~20%";
        
    } else if (new >= 20 && new < 25) {
        fatRange = @"20%~25%";
        
    } else if (new >= 25 && new < 30) {
        fatRange = @"25%~30%";
        
    } else if (new >= 30 && new < 35) {
        fatRange = @"30%~35%";
        
    } else {
        fatRange = @">35%";
        
    }
    
    return fatRange;
}

@end
