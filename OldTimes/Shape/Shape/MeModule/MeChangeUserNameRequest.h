//
//  MeChangeUserNameRequest.h
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"

@interface MeChangeUserNameRequest : BaseRequest
@property (nonatomic, copy) NSString *userName;
@end
