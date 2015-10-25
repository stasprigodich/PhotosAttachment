//
//  ORCameraToolView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCameraAttachmentViewController.h"

typedef enum {
    ORCameraGridStateOn,
    ORCameraGridStateOff
}  ORCameraGridState;

typedef enum {
    ORCameraFlashStateOn,
    ORCameraFlashStateOff
}  ORCameraFlashState;

static const float ORCameraToolViewHeight =  90;
static const float ORCameraToolViewHeightIphone4 =  60;

@protocol ORCameraToolDelegate <NSObject>

@required
- (void)cameraButtonTapped;
- (void)cameraRollButtonTapped;

@optional
- (void)gridStateChanged:(ORCameraGridState)gridState;
- (void)flashStateChanged:(ORCameraFlashState)flashState;

@end

@interface ORCameraToolView : UIView

@property (weak, nonatomic) id<ORCameraToolDelegate> delegate;

- (void)shakeCameraButton;

@end
