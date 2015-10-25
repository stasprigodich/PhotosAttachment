//
//  ORPhotoAttachment.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 31/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORPhotoAttachment.h"
#import "ORPhotosUtils.h"

@implementation ORPhotoAttachment

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

#pragma mark - public methods

- (void)reset
{
    self.rotateRightCount = 0;
    self.angle = 0;
    self.scale = 1;
    self.offsetPoint = CGPointZero;
}

#pragma mark - getters, setters

- (void)setImage:(UIImage *)image
{
    if (!self.originalImage) {
        _originalImage = image;
    }
    _image = image;
}

- (void)setRotateRightCount:(NSInteger)rotateRightCount
{
    _rotateRightCount = rotateRightCount % 4;
}

- (id)copyWithZone:(NSZone *)zone {
    ORPhotoAttachment *photoAttachment = [[[self class] allocWithZone:zone] init];
    if (photoAttachment) {
        [photoAttachment setImageId:[self imageId]];
        [photoAttachment setImage:[self image]];
        [photoAttachment setScale:[self scale]];
        [photoAttachment setAngle:[self angle]];
        [photoAttachment setRotateRightCount:[self rotateRightCount]];
        [photoAttachment setOffsetPoint:[self offsetPoint]];
        [photoAttachment setOriginalImage:[self originalImage]];
    }
    return photoAttachment;
}

@end
