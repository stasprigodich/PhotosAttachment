//
//  ORCameraView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCameraToolView.h"

@protocol ORCameraPickerDelegate <NSObject>

@required
- (void)didFinishPickingImage:(UIImage*)image;

@end

@interface ORCameraView : UIView

@property (weak, nonatomic) id<ORCameraPickerDelegate> delegate;
- (void)takePicture;
- (void)updateFlashWithState:(ORCameraFlashState)flashState;

@end
