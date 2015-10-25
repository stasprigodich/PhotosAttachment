//
//  OREditPhotoSubmissionView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "OREditPhotoSubmissionView.h"

@interface OREditPhotoSubmissionView()

@property (nonatomic, strong) UIButton* resetButton;
@property (nonatomic, strong) UIButton* submissionButton;

@end

@implementation OREditPhotoSubmissionView

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
    [self setBackgroundColor:[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f]];
    [self constructResetButton];
    [self constructSubmissionButton];
    [self setConstraints];
}

- (void)constructResetButton
{
    self.resetButton = [[UIButton alloc] init];
    [self.resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTitle: @"Reset" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resetButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    [self.resetButton setBackgroundColor:[UIColor colorWithRed:97/255.0f green:97/255.0f blue:97/255.0f alpha:1.0f]];
    self.resetButton.layer.cornerRadius = 20;
    [self addSubview:self.resetButton];
}

- (void)constructSubmissionButton
{
    self.submissionButton = [[UIButton alloc] init];
    [self.submissionButton addTarget:self action:@selector(submissionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.submissionButton setTitle: @"Apply" forState:UIControlStateNormal];
    [self.submissionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submissionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    [self.submissionButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:150/255.0f blue:35/255.0f alpha:1.0f]];
    self.submissionButton.layer.cornerRadius = 20;
    [self addSubview:self.submissionButton];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"resetButton": self.resetButton, @"submissionButton": self.submissionButton};
    [self.resetButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.resetButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[resetButton(==%f)]", 40.0] options:0 metrics:nil views:views]];
    [self.submissionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[submissionButton(==%f)]", 40.0] options:0 metrics:nil views:views]];

    [self.resetButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[resetButton(==%f)]", 130.0] options:0 metrics:nil views:views]];
    [self.submissionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[submissionButton(==%f)]", 130.0] options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-75]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:75]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - actions

- (void)resetButtonTapped:(id)sender
{
    [self.delegate resetButtonTapped];
}

- (void)submissionButtonTapped:(id)sender
{
    [self.delegate submissionButtonTapped];
}

@end
