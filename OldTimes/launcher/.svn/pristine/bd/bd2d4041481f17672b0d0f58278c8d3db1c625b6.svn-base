//
//  QRCodeReaderViewController+CameraAvaibleCheck.m
//  launcher
//
//  Created by Simon on 16/6/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "QRCodeReaderViewController+CameraAvaibleCheck.h"
#import "MyDefine.h"

@implementation QRCodeReaderViewController (CameraAvaibleCheck)

+ (BOOL)mtc_isCameraAvaible {
	NSString *mediaType = AVMediaTypeVideo;
	
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
	
	if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
		
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:LOCAL(PROMPT) message:LOCAL(QR_CAMERA_UNVAIABLE_INFO) delegate:self cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles: nil];
		
		[alert show];
		
		return NO;
		
	} else {
		return YES;
	}
}

@end
