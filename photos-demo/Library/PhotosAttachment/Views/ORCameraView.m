//
//  ORCameraView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCameraView.h"

@interface ORCameraView() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController* pickerController;
@property (nonatomic) UIView* imagePickerView;
@property (nonatomic) UIView *pickerEffectView;

@end

@implementation ORCameraView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)takePicture
{
    [self.pickerController takePicture];
    self.pickerEffectView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerEffectView.alpha = 0;
    }];
}

- (void)updateFlashWithState:(ORCameraFlashState)flashState
{
    self.pickerController.cameraFlashMode = flashState == ORCameraFlashStateOn ? UIImagePickerControllerCameraFlashModeOn : UIImagePickerControllerCameraFlashModeOff;
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructImagePickerView];
    [self constructPickerEffectView];
    [self setConstraints];
}

- (void)constructImagePickerView
{
    self.pickerController = [[UIImagePickerController alloc] init];
    [self.pickerController setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];

        self.pickerController.showsCameraControls = NO;
        self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    
    self.imagePickerView = self.pickerController.view;
    [self.imagePickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.imagePickerView];
}

- (void)constructPickerEffectView
{
    self.pickerEffectView = [[UIView alloc] init];
    self.pickerEffectView.backgroundColor = [UIColor blackColor];
    [self.pickerEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pickerEffectView.alpha = 0.0f;
    [self addSubview:self.pickerEffectView];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"imagePickerView": self.imagePickerView, @"pickerEffectView": self.pickerEffectView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imagePickerView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imagePickerView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pickerEffectView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pickerEffectView]|" options:0 metrics:nil views:views]];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* croppedImage = [self croppedImage:originalImage];
    
    [self.delegate didFinishPickingImage:croppedImage];
}

- (UIImage *)croppedImage:(UIImage *)image
{
    CGSize originalImageSize = [image size];
    
    CGRect newImageRect = CGRectMake(0, 0, originalImageSize.width, originalImageSize.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], newImageRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImage *img = [UIImage
                    imageWithCGImage:[croppedImage CGImage]
                    scale:[croppedImage scale]
                    orientation:UIImageOrientationRight];
    return img;
}

@end
