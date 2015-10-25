//
//  ORCameraAttachmentViewController.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORPhotoAttachment.h"
#import "ORNavigationController.h"
#import "ORViewController.h"

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height) < ( double )568 )


@interface ORCameraAttachmentViewController : ORViewController

@property (nonatomic, assign) int countVisibleImages;
@property (nonatomic, strong) NSMutableArray* images;

//Default - YES
@property (nonatomic, assign) BOOL shouldDismissAutomatically;

@property (nonatomic, strong) NSString* submissionText;

@property (nonatomic, copy) void (^submissionHandler)(NSArray* images);
@property (nonatomic, copy) void (^dismissHandler)();

//call this method in case of edit mode
- (instancetype)initWithImages:(NSArray*)images;

@end
