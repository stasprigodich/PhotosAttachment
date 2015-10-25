//
//  ORPhotoAttachment.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 31/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ORPhotoAttachment : NSObject<NSCopying>

@property (nonatomic, strong) NSString* imageId;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) NSInteger rotateRightCount;
@property (nonatomic, assign) CGPoint offsetPoint;

@property (nonatomic, strong) UIImage* originalImage;

- (void)reset;

@end
