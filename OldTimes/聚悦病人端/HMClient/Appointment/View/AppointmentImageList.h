//
//  AppointmentImageList.h
//  HMClient
//
//  Created by lkl on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AppointmentImageControlBlock)(id control);

@interface AppointmentImageClickControl : UIControl
{
    UIImageView* ivBackground;
    UIImageView* ivImage;
}
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, strong) AppointmentImageControlBlock clickBlock;
- (void) setimageUrl:(NSString *)imgUrl;

@end


@interface AppointmentImageListView : UIView
@property (nonatomic, retain) NSArray *imageControls;

- (id) initWithImageControlBlock:(AppointmentImageControlBlock) clickblock;

- (void) imageListChanged;

@end


