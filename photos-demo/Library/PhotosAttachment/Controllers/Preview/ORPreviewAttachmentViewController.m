//
//  ORPreviewAttachmentViewController.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORPreviewAttachmentViewController.h"
#import "ORPreviewPhotosView.h"
#import "ORSmallPreviewView.h"
#import "ORPreviewToolView.h"
#import "ORCropPhotoViewController.h"

@interface ORPreviewAttachmentViewController () <ORPreviewToolDelegate, ORSmallPreviewDelegate>

@property (strong, nonatomic) ORPreviewPhotosView *previewPhotosView;
@property (strong, nonatomic) ORSmallPreviewView* smallPreviewView;
@property (strong, nonatomic) ORPreviewToolView* previewToolView;
@property (strong, nonatomic) UIButton* submissionButton;
@property (strong, nonatomic) UILabel* submissionLabel;
@property (strong, nonatomic) UIImageView* submissionImageView;

@property (nonatomic, copy) void (^dismissHandler)(NSArray* images, BOOL backToScreen);

@end

@implementation ORPreviewAttachmentViewController

- (instancetype)initWithDismissHandler:(void(^)(NSArray*, BOOL))dismissHandler andSubmissionHandler:(void(^)(NSArray*))submissionHandler
{
    self = [super init];
    if (self) {
        self.dismissHandler = dismissHandler;
        self.submissionHandler = submissionHandler;
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self initNavigationBar];
    
    [self constructPreviewPhotosView];
    [self constructSmallPreviewView];
    [self constructPreviewToolView];
    [self constructSubmissionButton];
    [self setConstraints];
    if (IS_IPHONE_4)
    {
        [self.submissionLabel removeFromSuperview];
        [self.submissionImageView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateImages];
    [self selectImageWithIndex:self.selectedIndex];
}

#pragma mark - construct methods

- (void)constructPreviewPhotosView
{
    self.previewPhotosView = [[ORPreviewPhotosView alloc] init];
    [self.view addSubview:self.previewPhotosView];
}

- (void)constructSmallPreviewView
{
    self.smallPreviewView = [[ORSmallPreviewView alloc] init];
    self.smallPreviewView.isPreviewMode = YES;
    [self.smallPreviewView setBackgroundColor:[UIColor colorWithRed:39/255.0f green:41/255.0f blue:43/255.0f alpha:1.0f]];
    self.smallPreviewView.delegate = self;
    [self.view addSubview:self.smallPreviewView];
}

- (void)constructPreviewToolView
{
    self.previewToolView = [[ORPreviewToolView alloc] init];
    [self.previewToolView setBackgroundColor:[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f]];
    self.previewToolView.delegate = self;
    [self.view addSubview:self.previewToolView];
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
    NSDictionary *views = @{ @"previewPhotosView": self.previewPhotosView, @"smallPreviewView": self.smallPreviewView, @"previewToolView" : self.previewToolView, @"submissionButton": self.submissionButton, @"submissionLabel": self.submissionLabel, @"submissionImageView": self.submissionImageView};
    [self.previewPhotosView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.smallPreviewView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.previewToolView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[previewPhotosView][smallPreviewView][previewToolView][submissionButton]|", self.navigationController.navigationBar.frame.size.height] options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[previewPhotosView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[smallPreviewView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[previewToolView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[submissionButton]|" options: 0 metrics: nil views: views]];
    
    [self.previewToolView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[previewToolView(==%f)]", IS_IPHONE_4 ? ORPreviewToolViewHeightIphone4 : ORPreviewToolViewHeight] options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[submissionButton(==%f)]", IS_IPHONE_4 ? 0.0 : 49.0] options: 0 metrics: nil views: views]];
    CGFloat previewPhotosViewHeight = self.view.frame.size.width;
    [self.previewPhotosView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[previewPhotosView(==%f)]", previewPhotosViewHeight] options: 0 metrics: nil views: views]];

    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    [self.submissionImageView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:[submissionImageView(==22)]" options: 0 metrics: nil views: views]];
    [self.submissionImageView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:[submissionImageView(==22)]" options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:[submissionImageView]-13-|" options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - ORPreviewToolDelegate

- (void)deleteButtonTapped
{
    [self.images removeObjectAtIndex:self.selectedIndex];
    [self updateImages];
    if (self.images.count > 0)
    {
        NSUInteger indexNew = self.selectedIndex < self.images.count ? self.selectedIndex : self.images.count - 1;
        [self selectImageWithIndex:indexNew];
    }
    else
    {
        [self dismiss:YES];
    }
}

- (void)cropButtonTapped
{
    ORCropPhotoViewController* cropPhotoViewController = [[ORCropPhotoViewController alloc] initWithPhotoAttachment:self.images[self.selectedIndex] submissionHandler:^(ORPhotoAttachment *photoAttachment) {
        self.images[self.selectedIndex] = [photoAttachment copy];
        [self selectImageWithIndex:self.selectedIndex];
    }];
    ORNavigationController *cropNavigationController = [[ORNavigationController alloc] initWithRootViewController:cropPhotoViewController];
    cropNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cropNavigationController animated:YES completion:nil];
}

#pragma mark - ORSmallPreviewDelegate

- (void)imageTappedWithIndex:(NSUInteger)index
{
    if (index < self.images.count)
    {
        [self selectImageWithIndex:index];
    }
}

- (void)backToCameraScreen
{
    [self dismiss:YES];
}

#pragma mark - actions

- (void)submissionButtonTapped:(id)sender
{
    [self dismiss:YES];
    if (self.submissionHandler)
    {
        self.submissionHandler(self.images);
    }
}

- (void)closeButtonTapped:(id)sender
{
    [self dismiss:NO];
}

#pragma mark - private methods

- (void)dismiss:(BOOL)backToScreen
{
    if (backToScreen)
    {
        if (self.dismissHandler)
        {
            self.dismissHandler(self.images, backToScreen);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.dismissHandler)
            {
                self.dismissHandler(self.images, backToScreen);
            }
        }];
    }
}

- (void)selectImageWithIndex:(NSUInteger)index
{
    if (index < self.images.count)
    {
        self.selectedIndex = index;
        ORPhotoAttachment* photoAttachment = self.images[index];
        [self.previewPhotosView setImage:photoAttachment.image];
        [self.smallPreviewView selectImageWithIndex:index];
        self.title = [NSString stringWithFormat:@"%@ %lu", @"Photo", (unsigned long)(index + 1)];
    }
}

- (void)updateImages
{
    [self.smallPreviewView updateImagesToView:self.images];
}

- (void)initNavigationBar
{
    self.title = [NSString stringWithFormat:@"%@ %d", @"Photo", 1];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo_attachment_close_white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];

    if (IS_IPHONE_4)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(submissionButtonTapped:)];
        doneButton.tintColor = [UIColor orangeColor];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}


@end
