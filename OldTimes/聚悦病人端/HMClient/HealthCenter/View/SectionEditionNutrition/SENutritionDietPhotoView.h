//
//  SENutritionDietPhotoView.h
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SENutritionDietPhotoViewDelegate <NSObject>

// 添加图片
- (void)hm_addImage;

// 删除图片
- (void)hm_deleteImage:(NSInteger)flag;

@end

@interface SENutritionDietPhotoView : UIView

@property (nonatomic, strong) UIButton *btnAddPhoto;          //添加照片按钮
@property (nonatomic, strong) NSMutableArray *phonelist;      //图片数组
@property (nonatomic, weak) id<SENutritionDietPhotoViewDelegate> delegate;

//删除照片
- (void)delAllPhotos;
-(void)resetLayout;

- (void)reloadPhotos:(NSArray *)photos;

@end
