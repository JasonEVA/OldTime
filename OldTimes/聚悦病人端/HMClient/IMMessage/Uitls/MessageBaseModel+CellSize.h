//
//  MessageBaseModel+CellSize.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <MintcodeIMKit/MintcodeIMKit.h>

@interface MessageBaseModel (CellSize)

- (CGFloat) bubbleWidth;
- (CGFloat) bubbleHeight;

- (CGFloat) cellHeight;
@end

@interface MessageBaseModelContent : NSObject
{
    
}

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* msg;
@end

@interface MessageBaseModelDetectResultAlertContent : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* testResultId;

@end

@interface MessageBaseModelRecipePageContent  : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* userRecipeId;
@end

@interface MessageBaseModelServiceCommentsContent : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* userServiceId;

@end

@interface MessageBaseModelSurveyContent : MessageBaseModelContent
{
    
}


@property (nonatomic, assign) NSInteger moudleId;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, assign) NSInteger staffUserId;
@property (nonatomic, assign) NSInteger userId;

@end

@interface MessageBaseModelHealthReportContent : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* healthyReportId;

@end

@interface MessageBaseModelAppointmentContent : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, assign) NSInteger appointId;
@property (nonatomic, assign) NSInteger staffId;

@end

@interface MessageBaseModelHealthPlanContent : MessageBaseModelContent
{
    
}


@property (nonatomic, retain) NSString* healthPlanId;
@property (nonatomic, retain) NSString* userId;

@end

@interface MessageBaseModelHospitalizationContent : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* docuRegId;
@property (nonatomic, retain) NSString* storageId;
@property (nonatomic, retain) NSString* visitOrgTitle;
@property (nonatomic, retain) NSString* docuType;

@end

@interface MessageBaseModelAlertDealedContent : MessageBaseModelContent
{
    
}
//@property (nonatomic, retain) NSString* msg;
@end

