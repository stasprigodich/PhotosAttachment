//
//  ORPhotosUtils.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 21/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ORPhotoAttachment.h"

@interface ORPhotosUtils : NSObject

+ (void)getLastImageFromCameraRollWithCallback:(void(^)(UIImage *))callback;

+ (NSArray*)getImages;

@end
