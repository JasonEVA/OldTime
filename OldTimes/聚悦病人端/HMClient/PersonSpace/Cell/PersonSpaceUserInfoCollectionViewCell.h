//
//  PersonSpaceUserInfoCollectionViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSpaceCollectionViewCell : UICollectionViewCell

@end

@interface PersonSpaceUserInfoCollectionViewCell : PersonSpaceCollectionViewCell
{
    
}
- (void) setUserInfo;
@end

@interface PersonSpaceManageCollectionViewCell : PersonSpaceCollectionViewCell
{
    
}

- (void) setGirdImage:(UIImage*) icon
             GirdName:(NSString*) name;

- (void) setNoOpenImage:(BOOL)isopen;
@end
