//
//  ApplicationCommentModel.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentModel.h"
#import "NSDictionary+SafeManager.h"
#import <MJExtension.h>
#import "MyDefine.h"

static NSString * const d_showID        = @"showID";
static NSString * const d_content       = @"content";
static NSString * const d_filePath      = @"filePath";
static NSString * const d_isComment     = @"isComment";
static NSString * const d_isDeleted     = @"isDeleted";
static NSString * const d_appShowID     = @"appShowID";
static NSString * const d_rm_ShowID     = @"rm_ShowID";
static NSString * const d_c_ShowID      = @"c_ShowID";
static NSString * const d_creatUser     = @"creatUser";
static NSString * const d_creatUserName = @"creatUserName";
static NSString * const d_createTime    = @"createTime";
static NSString * const d_transType     = @"transType";
static NSString * const d_rmData        = @"rmData";
static NSString * const d_atWho			= @"atWho";

@implementation ApplicationCommentModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _showID = [dict valueStringForKey:d_showID];
        _content = [dict valueStringForKey:d_content];
		
        _filePath = [dict valueStringForKey:d_filePath];
        if ([_filePath rangeOfString:la_imgURLAddress].location == NSNotFound && [_filePath length]) {
            _filePath = [la_imgURLAddress stringByAppendingPathComponent:_filePath];
        }
        
        _isComment = [dict valueBoolForKey:d_isComment];
        _isDelete  = [dict valueBoolForKey:d_isDeleted];
        
        _appShowID      = [dict valueStringForKey:d_appShowID];
        _rmShowID       = [dict valueStringForKey:d_rm_ShowID];
        _cShowID        = [dict valueStringForKey:d_c_ShowID];
        _createUser     = [dict valueStringForKey:d_creatUser];
        _createUserName = [dict valueStringForKey:d_creatUserName];
        _createTime     = [dict valueDateForKey:d_createTime];
        _transType      = [dict valueStringForKey:d_transType];
        _rmData         = [dict valueStringForKey:d_rmData];
		_atWho 			= [[dict valueStringForKey:d_atWho] mj_JSONObject];
		
    }
    return self;
}

@end
