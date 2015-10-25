//
//  ORChoosePhotoViewController.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 21/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORPhotoAttachment.h"
#import "ORViewController.h"

@interface ORChoosePhotoViewController : ORViewController

- (instancetype)initWithCallback:(void(^)(NSArray*))callback;

@property (nonatomic, assign) int maxCountSelectedPhotos;

@end
