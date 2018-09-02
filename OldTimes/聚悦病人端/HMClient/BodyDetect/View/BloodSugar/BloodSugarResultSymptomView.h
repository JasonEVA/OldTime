//
//  BloodSugarResultSymptomView.h
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceholderTextView.h"

typedef void(^BloodSugarImageControlBlock)(id control);


@interface BloodSugarResultSymptomImageControl : UIControl
{
    UIImageView* ivBackground;
    UIImageView* ivImage;

}
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, strong) BloodSugarImageControlBlock clickBlock;
- (void) setimageUrl:(NSString *)imgUrl;
@end

@interface BloodSugarResultSymptomView : UIView
{
    
}
@property (nonatomic, retain) NSArray *imageControls;
@property (nonatomic, readonly) UIButton* commitButton;
@property (nonatomic, readonly) UITextView* tvSymptom;
@property (nonatomic, readonly) PlaceholderTextView* tv;
- (id) initWithImageControlBlock:(BloodSugarImageControlBlock) clickblock;

- (void) imageListChanged;
@end
