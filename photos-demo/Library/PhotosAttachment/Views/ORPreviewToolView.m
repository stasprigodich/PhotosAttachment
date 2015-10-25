//
//  ORPreviewToolView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORPreviewToolView.h"

@interface ORPreviewToolView()

@property (nonatomic) UIButton* deleteButton;
@property (nonatomic) UIButton* cropButton;

@end

@implementation ORPreviewToolView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructDeleteButton];
    [self constructCropButton];
    [self setConstraints];
}

- (void)constructDeleteButton
{
    self.deleteButton = [[UIButton alloc] init];
    [self.deleteButton setImage:[UIImage imageNamed:@"photo_attachment_bin.png"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.deleteButton];
}

- (void)constructCropButton
{
    self.cropButton = [[UIButton alloc] init];
    [self.cropButton setImage:[UIImage imageNamed:@"photo_attachment_crop.png"] forState:UIControlStateNormal];
    [self.cropButton addTarget:self action:@selector(cropButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.cropButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.cropButton];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"deleteButton": self.deleteButton, @"cropButton": self.cropButton};
    [self.deleteButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[deleteButton(==48)]" options:0 metrics:nil views:views]];
    [self.deleteButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[deleteButton(==48)]" options:0 metrics:nil views:views]];
    
    [self.cropButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cropButton(==48)]" options:0 metrics:nil views:views]];
    [self.cropButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cropButton(==48)]" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - actions

- (void)deleteButtonTapped:(id)sender
{
    [self.delegate deleteButtonTapped];
}

- (void)cropButtonTapped:(id)sender
{
    [self.delegate cropButtonTapped];
}

@end
