//
//  ORSmallPreviewView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ORSmallPreviewDelegate <NSObject>

@required
- (void)imageTappedWithIndex:(NSUInteger)index;

@optional
- (void)backToCameraScreen;

@end

@interface ORSmallPreviewView : UIView

@property (nonatomic, assign) BOOL isPreviewMode;
@property (nonatomic, assign) int countVisibleImages;

@property (weak, nonatomic) id<ORSmallPreviewDelegate> delegate;
- (void)updateImagesToView:(NSArray*)images;
- (void)selectImageWithIndex:(NSUInteger)index;

@end
