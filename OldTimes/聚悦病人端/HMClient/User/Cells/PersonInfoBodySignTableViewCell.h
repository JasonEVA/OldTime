//
//  PersonInfoBodySignTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoBodySignTableViewCell : UITableViewCell
{
    
}

- (void) setTitle:(NSString*) title;
- (void) setSignValue:(NSString*) sign;

@end

@interface PersonInfoDiseaseTableViewCell : UITableViewCell
{
    
}

- (void) setUserInfo:(UserInfo*) userInfo;
@end
