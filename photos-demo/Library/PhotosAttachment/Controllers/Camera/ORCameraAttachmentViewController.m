//
//  ORCameraAttachmentViewController.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCameraAttachmentViewController.h"
#import "ORCameraView.h"
#import "ORSmallPreviewView.h"
#import "ORCameraToolView.h"
#import "ORCameraLayerView.h"
#import "ORChoosePhotoViewController.h"
#import "ORPreviewAttachmentViewController.h"

@interface ORCameraAttachmentViewController () <ORCameraToolDelegate, ORCameraPickerDelegate, ORSmallPreviewDelegate>

@property (strong, nonatomic) ORCameraView* cameraView;
@property (strong, nonatomic) ORCameraLayerView* cameraLayerView;
@property (strong, nonatomic) ORSmallPreviewView* smallPreviewView;
@property (strong, nonatomic) ORCameraToolView* cameraToolView;
@property (strong, nonatomic) UIButton* submissionButton;
@property (strong, nonatomic) UILabel* submissionLabel;
@property (strong, nonatomic) UIImageView* submissionImageView;

@property (nonatomic, assign) BOOL isEditMode;

@property (nonatomic) BOOL isDismissing;
@property (nonatomic) BOOL isStatusBarHidden;

@end

@implementation ORCameraAttachmentViewController

#pragma mark - UIViewController Overrides

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldDismissAutomatically = YES;
        self.countVisibleImages = 5;
        self.images = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray*)images
{
    self = [self init];
    if (self) {
        self.images = [[NSMutableArray alloc] initWithArray:images];
        self.isEditMode = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    self.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [self constructCameraView];
    [self constructCameraLayerView];
    [self constructSmallPreviewView];
    [self constructCameraToolView];
    [self constructSubmissionButton];

    [self setConstraints];
    if (self.isEditMode)
    {
        [self updateImages];
        [self selectImageWithIndex:0];
    }
    if (IS_IPHONE_4)
    {
        [self.submissionLabel removeFromSuperview];
        [self.submissionImageView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavigationBar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.isDismissing)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        });
    }
}

#pragma mark - construct methods

- (void)constructCameraView
{
    self.cameraView = [[ORCameraView alloc] init];
    self.cameraView.delegate = self;
    [self.view addSubview:self.cameraView];
}

- (void)constructCameraLayerView
{
    self.cameraLayerView = [[ORCameraLayerView alloc] init];
    [self.view addSubview:self.cameraLayerView];
}

- (void)constructSmallPreviewView
{
    self.smallPreviewView = [[ORSmallPreviewView alloc] init];
    [self.smallPreviewView setBackgroundColor:[UIColor colorWithRed:39/255.0f green:41/255.0f blue:43/255.0f alpha:1.0f]];
    self.smallPreviewView.delegate = self;
    [self.view addSubview:self.smallPreviewView];
}

- (void)constructCameraToolView
{
    self.cameraToolView = [[ORCameraToolView alloc] init];
    [self.cameraToolView setBackgroundColor:[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f]];
    self.cameraToolView.delegate = self;
    [self.view addSubview:self.cameraToolView];
}

- (void)constructSubmissionButton
{
    self.submissionButton = [[UIButton alloc] init];
    [self.submissionButton addTarget:self action:@selector(submissionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.submissionButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:150/255.0f blue:35/255.0f alpha:1.0f]];
    [self.view addSubview:self.submissionButton];
    [self constructSubmissionLabel];
    [self constructSubmissionImageView];
}

- (void)constructSubmissionLabel
{
    self.submissionLabel = [[UILabel alloc] init];
    self.submissionLabel.text = self.submissionText ? self.submissionText : @"SAVE";
    self.submissionLabel.textColor = [UIColor whiteColor];
    self.submissionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [self.submissionButton addSubview:self.submissionLabel];
}

- (void)constructSubmissionImageView
{
    self.submissionImageView = [[UIImageView alloc] init];
    self.submissionImageView.image = [UIImage imageNamed:@"photo_attachment_next.png"];
    [self.submissionButton addSubview:self.submissionImageView];
}

- (void)setConstraints
{
    NSDictionary *views = @{ @"cameraView": self.cameraView, @"cameraLayerView": self.cameraLayerView, @"smallPreviewView": self.smallPreviewView, @"cameraToolView" : self.cameraToolView, @"submissionButton": self.submissionButton, @"submissionLabel": self.submissionLabel, @"submissionImageView": self.submissionImageView};
    [self.cameraView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cameraLayerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.smallPreviewView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cameraToolView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[cameraLayerView][smallPreviewView][cameraToolView][submissionButton]|", self.navigationController.navigationBar.frame.size.height] options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[cameraView]", self.navigationController.navigationBar.frame.size.height] options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cameraView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cameraLayerView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[smallPreviewView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cameraToolView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[submissionButton]|" options: 0 metrics: nil views: views]];
    
    [self.cameraToolView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraToolView(==%f)]", IS_IPHONE_4 ? ORCameraToolViewHeightIphone4 : ORCameraToolViewHeight] options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[submissionButton(==%f)]", IS_IPHONE_4 ? 0.0 : 49.0] options: 0 metrics: nil views: views]];
    CGFloat cameraLayerViewHeight = self.view.frame.size.width;
    [self.cameraLayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraLayerView(==%f)]", cameraLayerViewHeight] options: 0 metrics: nil views: views]];
    [self.cameraView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraView(==%f)]", cameraLayerViewHeight] options: 0 metrics: nil views: views]];
    
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.submissionImageView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:[submissionImageView(==22)]" options: 0 metrics: nil views: views]];
    [self.submissionImageView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:[submissionImageView(==22)]" options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:[submissionImageView]-13-|" options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - actions

- (void)submissionButtonTapped:(id)sender
{
    if (self.images.count > 0)
    {
        [self submitImages:self.images];
    }
    else
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.06];
        [animation setRepeatCount:3];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([self.submissionButton center].x - 4.0f, [self.submissionButton center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([self.submissionButton center].x + 4.0f, [self.submissionButton center].y)]];
        [[self.submissionButton layer] addAnimation:animation forKey:@"position"];
    }
}

- (void)closeButtonTapped:(id)sender
{
    [self dismissWithCompletion:nil];
}

#pragma mark - ORCameraToolDelegate

- (void)cameraButtonTapped
{
    if (self.images.count < self.countVisibleImages)
    {
        [self.cameraView takePicture];
    }
    else
    {
        [self.cameraToolView shakeCameraButton];
    }
}

- (void)cameraRollButtonTapped
{
    ORChoosePhotoViewController *choosePhotoController = [[ORChoosePhotoViewController alloc] initWithCallback:^(NSArray *images) {
        for (ORPhotoAttachment* attachment in images) {
            UIImage* croppedImage = [self croppedImage:attachment.image];
            attachment.image = [croppedImage copy];
            [self.images addObject:attachment];
        }
        [self updateImages];
    }];
    choosePhotoController.maxCountSelectedPhotos = self.countVisibleImages - (int)self.images.count;

    ORNavigationController* navigationController = [[ORNavigationController alloc] initWithRootViewController:choosePhotoController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)gridStateChanged:(ORCameraGridState)gridState
{
    [self.cameraLayerView updateGridWithState:gridState];
}

- (void)flashStateChanged:(ORCameraFlashState)flashState
{
    [self.cameraView updateFlashWithState:flashState];
}

#pragma mark - ORCameraToolDelegate

- (void)imageTappedWithIndex:(NSUInteger)index
{
    [self selectImageWithIndex:index];
}

#pragma mark - ORCameraPickerDelegate

- (void)didFinishPickingImage:(UIImage *)image
{
    ORPhotoAttachment *photoAttachment = [ORPhotoAttachment new];
    photoAttachment.image = image;
    [self.images addObject:photoAttachment];
    [self updateImages];
}

#pragma mark - private methods

- (void)submitImages:(NSArray*)images
{
    [self dismissWithCompletion:^{
        if (self.submissionHandler)
        {
            self.submissionHandler(images);
        }
    }];
}

- (void)selectImageWithIndex:(NSUInteger)index
{
    if (index < self.images.count)
    {
        ORPreviewAttachmentViewController* previewViewController = [[ORPreviewAttachmentViewController alloc] initWithDismissHandler:^(NSArray *images, BOOL backToScreen) {
            self.images = [NSMutableArray arrayWithArray:images];
            [self updateImages];
            if (!backToScreen)
            {
                [self dismissWithCompletion:nil];
            }
        } andSubmissionHandler:^(NSArray *images) {
            [self submitImages:images];
        }];
        
        previewViewController.selectedIndex = index;
        previewViewController.images = [self.images mutableCopy];
        previewViewController.submissionText = self.submissionText;
        previewViewController.isEditMode = self.isEditMode;
        ORNavigationController* navigationController = [[ORNavigationController alloc] initWithRootViewController:previewViewController];
        
        
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)dismissWithCompletion:(void(^)())completion
{
    if (self.shouldDismissAutomatically)
    {
        self.isDismissing = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusBarHidden];
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusBarHidden withAnimation:UIStatusBarAnimationFade];
                if (completion)
                {
                    completion();
                }
            });
            self.isDismissing = NO;
        }];
    }

    if (self.dismissHandler)
    {
        self.dismissHandler();
    }
}

- (void)updateImages
{
    [self.smallPreviewView updateImagesToView:self.images];
}

- (void)initNavigationBar
{
    self.title = @"";
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo_attachment_close_white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    
    if (IS_IPHONE_4)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(submissionButtonTapped:)];
        doneButton.tintColor = [UIColor orangeColor];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}

- (UIImage*)croppedImage:(UIImage*)image
{
    CGRect rectForCrop;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if (width > height) {
        rectForCrop = CGRectMake(width / 2 - height / 2, 0, height, height);
    } else {
        rectForCrop = CGRectMake(0, height / 2 - width / 2, width, width);
    }
    UIImage *croppedImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rectForCrop) scale:1 orientation:UIImageOrientationUp];
    return croppedImage;
}

@end
