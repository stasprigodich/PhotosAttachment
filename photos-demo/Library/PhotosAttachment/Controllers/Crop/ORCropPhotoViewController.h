//
//  ORCropPhotoViewController.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 09/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORPhotoAttachment.h"
#import "ORViewController.h"

@interface ORCropPhotoViewController : ORViewController

- (instancetype)initWithPhotoAttachment:(ORPhotoAttachment*)photoAttachment submissionHandler:(void(^)(ORPhotoAttachment*))submissionHandler;

@end
