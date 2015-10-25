//
//  ORPreviewAttachmentViewController.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORPhotoAttachment.h"
#import "ORCameraAttachmentViewController.h"

@interface ORPreviewAttachmentViewController : ORViewController

@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) BOOL isEditMode;

@property (nonatomic, strong) NSString* submissionText;

@property (nonatomic, copy) void (^submissionHandler)(NSArray* images);

- (instancetype)initWithDismissHandler:(void(^)(NSArray*, BOOL))dismissHandler andSubmissionHandler:(void(^)(NSArray*))submissionHandler;

@end
