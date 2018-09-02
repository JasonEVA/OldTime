//
//  BloodSugarResultSymptomView.h
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^BloodSugarImageControlBlock)(id control);


@interface BloodSugarResultSymptomImageControl : UIControl
{
    UIImageView* ivBackground;
    UIImageView* ivImage;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, strong) BloodSugarImageControlBlock clickBlock;

@end

@interface BloodSugarResultSymptomView : UIView
{
    
}

@property (nonatomic, readonly) UITextView* tvSymptom;
- (id) initWithImageControlBlock:(BloodSugarImageControlBlock) clickblock;

- (void) imageListChanged;
@end
