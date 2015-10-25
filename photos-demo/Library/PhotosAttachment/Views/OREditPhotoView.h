//
//  OREditPhotoView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORPhotoAttachment.h"

@protocol OREditPhotoDelegate <NSObject>

@required
- (void)zoomScaleChanged:(CGFloat)zoomScale;
- (void)offsetPointChanged:(CGPoint)offsetPoint;

@end

@interface OREditPhotoView : UIView

- (instancetype)initWithPhotoAttachment:(ORPhotoAttachment*)photoAttachment;

- (void)rotateWithAngle:(CGFloat)angle;

- (void)rotateRightWithCount:(NSInteger)rotateRightCount;

@property (nonatomic, weak) id<OREditPhotoDelegate> delegate;

- (void)reset;

- (UIImage *)cropVisiblePortionOfImageView;

@end
