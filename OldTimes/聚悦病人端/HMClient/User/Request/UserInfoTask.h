//
//  UserInfoTask.h
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface UserInfoTask : SingleHttpRequestTask

@end

@interface UserPhotoUpdateTask : Task

@end

@interface UserResetPasswordTask : SingleHttpRequestTask

@end

@interface UpdateUserInfoTask : SingleHttpRequestTask

@end

@interface BindUserMobileTask : SingleHttpRequestTask

@end

@interface BindUserIdCardTask : SingleHttpRequestTask

@end
