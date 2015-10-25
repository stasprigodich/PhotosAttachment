//
//  ORCameraLayerView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 20/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCameraToolView.h"

@interface ORCameraLayerView : UIView

- (void)updateGridWithState:(ORCameraGridState)gridState;

@property (nonatomic, assign) BOOL isBorderHidden;

@end
