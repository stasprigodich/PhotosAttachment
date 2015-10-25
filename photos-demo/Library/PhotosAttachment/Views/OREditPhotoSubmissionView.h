//
//  OREditPhotoSubmissionView.h
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OREditPhotoSubmissionDelegate <NSObject>

@required
- (void)resetButtonTapped;
- (void)submissionButtonTapped;

@end

@interface OREditPhotoSubmissionView : UIView

@property (weak, nonatomic) id<OREditPhotoSubmissionDelegate> delegate;

@end
