//
//  NewestApplyAddUserDefinedViewController.h
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^takebackImgArray)(NSMutableArray *);

typedef enum
{
    newapply_type_edit,
    newapply_type_new,
}newapplyuserdefined_type;

typedef enum{
    cellStyle_SingleLineText,
    cellStyle_MultiLineText,
    cellStyle_Time,
    cellStyle_SeletedPeople,
    cellStyle_SingleSelected,
    cellStyle_MultiSelected,
    cellStyle_Attachment,
    cellStyle_BackMark
}cellStyle;

@interface NewestApplyAddUserDefinedViewController : BaseViewController
@property (nonatomic) newapplyuserdefined_type applytype;
@property (nonatomic, strong) NSString *strNavTitle;
@property (nonatomic, strong) NSString *strworkflowID;
- (void)takebackarray:(takebackImgArray)takebackImgblock;
- (instancetype)initWithApplyStyle:(newapplyuserdefined_type)type WithApplyShowID:(NSString *)strID WithFormId:(NSString *)formid;
@end
