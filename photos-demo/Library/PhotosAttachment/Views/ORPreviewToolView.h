//
//  ORPreviewToolView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

static const float ORPreviewToolViewHeight = 90;
static const float ORPreviewToolViewHeightIphone4 = 60;

@protocol ORPreviewToolDelegate <NSObject>

@required
- (void)deleteButtonTapped;
- (void)cropButtonTapped;

@end

@interface ORPreviewToolView : UIView

@property (weak, nonatomic) id<ORPreviewToolDelegate> delegate;

@end
