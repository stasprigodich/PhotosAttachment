//
//  ORCameraToolView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCameraToolView.h"
#import "ORPhotosUtils.h"

@interface ORCameraToolView()

@property (nonatomic) UIButton* cameraButton;
@property (nonatomic) UIButton* gridButton;
@property (nonatomic) UIButton* flashButton;
@property (nonatomic) UIButton* cameraRollButton;
@property (nonatomic, assign) ORCameraGridState gridState;
@property (nonatomic, assign) ORCameraFlashState flashState;

@end

@implementation ORCameraToolView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)shakeCameraButton
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.06];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.cameraButton center].x - 4.0f, [self.cameraButton center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.cameraButton center].x + 4.0f, [self.cameraButton center].y)]];
    [[self.cameraButton layer] addAnimation:animation forKey:@"position"];
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructCameraButton];
    [self constructGridButton];
    [self constructFlashButton];
    [self constructCameraRollButton];
    [self setConstraints];
}

- (void)constructCameraButton
{
    self.cameraButton = [[UIButton alloc] init];
    [self.cameraButton setImage:[UIImage imageNamed:@"photo_attachment_capture_off.png"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"photo_attachment_capture_on.png"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(cameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.cameraButton];
}

- (void)constructGridButton
{
    self.gridButton = [[UIButton alloc] init];
    [self.gridButton addTarget:self action:@selector(gridButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.gridButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.gridButton];
    self.gridState = ORCameraGridStateOn;
}

- (void)constructFlashButton
{
    self.flashButton = [[UIButton alloc] init];
    [self.flashButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.flashButton];
    self.flashState = ORCameraFlashStateOff;
}

- (void)constructCameraRollButton
{
    self.cameraRollButton = [[UIButton alloc] init];
    [self.cameraRollButton addTarget:self action:@selector(cameraRollButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [ORPhotosUtils getLastImageFromCameraRollWithCallback:^(UIImage *image) {
        [self.cameraRollButton setImage:image forState:UIControlStateNormal];
    }];
    [self.cameraRollButton setBackgroundColor:[UIColor colorWithRed:35/255.0f green:35/255.0f blue:35/255.0f alpha:0.3f]];
    [self.cameraRollButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.cameraRollButton];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"cameraButton": self.cameraButton, @"gridButton": self.gridButton, @"flashButton": self.flashButton, @"cameraRollButton": self.cameraRollButton};
    [self.cameraButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraButton(==%f)]", IS_IPHONE_4 ? 50.0 : 63.0] options:0 metrics:nil views:views]];
    [self.cameraButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[cameraButton(==%f)]", IS_IPHONE_4 ? 50.0 : 63.0]  options:0 metrics:nil views:views]];
 
    [self.cameraRollButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraRollButton(==%f)]", IS_IPHONE_4 ? 46.0 : 56.0] options:0 metrics:nil views:views]];
    [self.cameraRollButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[cameraRollButton(==%f)]", IS_IPHONE_4 ? 46.0 : 56.0] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[cameraRollButton]" options:0 metrics:nil views:views]];
    
    [self.gridButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gridButton(==26)]" options:0 metrics:nil views:views]];
    [self.gridButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[gridButton(==26)]" options:0 metrics:nil views:views]];
    
    [self.flashButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[flashButton(==26)]" options:0 metrics:nil views:views]];
    [self.flashButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[flashButton(==26)]" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[flashButton]-22-[gridButton]-15-|" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.gridButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.flashButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraRollButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - getters, setters

- (void)setGridState:(ORCameraGridState)gridState
{
    _gridState = gridState;
    UIImage* gridButtonImage = gridState == ORCameraGridStateOff ? [UIImage imageNamed:@"photo_attachment_grid_off.png"] : [UIImage imageNamed:@"photo_attachment_grid_on.png"];
    [self.gridButton setImage:gridButtonImage forState:UIControlStateNormal];
}

- (void)setFlashState:(ORCameraFlashState)flashState
{
    _flashState = flashState;
    UIImage* flashButtonImage = flashState == ORCameraFlashStateOff ? [UIImage imageNamed:@"photo_attachment_flash_off.png"] : [UIImage imageNamed:@"photo_attachment_flash_on.png"];
    [self.flashButton setImage:flashButtonImage forState:UIControlStateNormal];
}

#pragma mark - actions

- (void)cameraButtonTapped:(id)sender
{
    [self.delegate cameraButtonTapped];
}

- (void)gridButtonTapped:(id)sender
{
    if (self.gridState == ORCameraGridStateOff)
    {
        self.gridState = ORCameraGridStateOn;
    }
    else
    {
        self.gridState = ORCameraGridStateOff;
    }
    if ([self.delegate respondsToSelector:@selector(gridStateChanged:)])
    {
        [self.delegate gridStateChanged:self.gridState];
    }
}

- (void)flashButtonTapped:(id)sender
{
    if (self.flashState == ORCameraFlashStateOff)
    {
        self.flashState = ORCameraFlashStateOn;
    }
    else
    {
        self.flashState = ORCameraFlashStateOff;
    }
    if ([self.delegate respondsToSelector:@selector(flashStateChanged:)])
    {
        [self.delegate flashStateChanged:self.flashState];
    }
}

- (void)cameraRollButtonTapped:(id)sender
{
    [self.delegate cameraRollButtonTapped];
}

@end
