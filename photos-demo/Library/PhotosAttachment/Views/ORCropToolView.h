//
//  ORCropToolView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCameraToolView.h"

static const float ORCropToolViewHeight = 90;
static const float ORCropToolViewHeightIphone4 = 60;

@protocol ORCropToolDelegate <NSObject>

@required
- (void)gridStateChanged:(ORCameraGridState)gridState;
- (void)rotateRight;
- (void)rotateWithAngle:(CGFloat)angle;

@end

@interface ORCropToolView : UIView

@property (nonatomic, assign) CGFloat angle;

@property (weak, nonatomic) id<ORCropToolDelegate> delegate;

- (void)reset;

@end
