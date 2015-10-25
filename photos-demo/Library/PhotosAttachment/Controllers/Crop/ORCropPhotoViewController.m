//
//  ORCropPhotoViewController.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 09/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCropPhotoViewController.h"
#import "ORCameraLayerView.h"
#import "ORCropToolView.h"
#import "OREditPhotoView.h"
#import "OREditPhotoSubmissionView.h"

@interface ORCropPhotoViewController () <OREditPhotoSubmissionDelegate, ORCropToolDelegate, OREditPhotoDelegate>

@property (strong, nonatomic) ORCameraLayerView* cameraLayerView;
@property (strong, nonatomic) ORCropToolView* cropToolView;
@property (strong, nonatomic) OREditPhotoView *editPhotoView;
@property (strong, nonatomic) OREditPhotoSubmissionView* editPhotoSubmissionView;

@property (nonatomic, copy) void (^submissionHandler)(ORPhotoAttachment* photoAttachment);
@property (nonatomic, strong) ORPhotoAttachment* photoAttachment;

@end

@implementation ORCropPhotoViewController

- (instancetype)initWithPhotoAttachment:(ORPhotoAttachment*)photoAttachment submissionHandler:(void(^)(ORPhotoAttachment*))submissionHandler
{
    self = [super init];
    if (self) {
        self.submissionHandler = submissionHandler;
        self.photoAttachment = [photoAttachment copy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationBar];
  
    [self constructEditPhotoView];
    [self constructEditPhotoSubmissionView];
    [self constructCameraLayerView];
    [self constructCropToolView];
    [self setConstraints];
}

#pragma mark - construct methods

- (void)constructEditPhotoView
{
    self.editPhotoView = [[OREditPhotoView alloc] initWithPhotoAttachment:self.photoAttachment];
    self.editPhotoView.delegate = self;
    [self.view addSubview:self.editPhotoView];
}

- (void)constructEditPhotoSubmissionView
{
    self.editPhotoSubmissionView = [[OREditPhotoSubmissionView alloc] init];
    self.editPhotoSubmissionView.delegate = self;
    [self.view addSubview:self.editPhotoSubmissionView];
}

- (void)constructCameraLayerView
{
    self.cameraLayerView = [[ORCameraLayerView alloc] init];
    self.cameraLayerView.isBorderHidden = YES;
    [self.view addSubview:self.cameraLayerView];
}

- (void)constructCropToolView
{
    self.cropToolView = [[ORCropToolView alloc] init];
    self.cropToolView.angle = self.photoAttachment.angle;
    self.cropToolView.delegate = self;
    [self.view addSubview:self.cropToolView];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"editPhotoView": self.editPhotoView, @"cameraLayerView": self.cameraLayerView, @"cropToolView": self.cropToolView, @"editPhotoSubmissionView": self.editPhotoSubmissionView};
    [self.cameraLayerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cropToolView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.editPhotoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.editPhotoSubmissionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[cameraLayerView][cropToolView][editPhotoSubmissionView]|", self.navigationController.navigationBar.frame.size.height] options: 0 metrics: nil views: views]];
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[editPhotoView]", self.navigationController.navigationBar.frame.size.height] options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[editPhotoView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cameraLayerView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cropToolView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[editPhotoSubmissionView]|" options: 0 metrics: nil views: views]];

    [self.cropToolView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cropToolView(==%f)]", IS_IPHONE_4 ? ORCropToolViewHeightIphone4 : ORCropToolViewHeight] options: 0 metrics: nil views: views]];
    
    CGFloat cameraLayerViewHeight = self.view.frame.size.width;
    [self.cameraLayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraLayerView(==%f)]", cameraLayerViewHeight] options: 0 metrics: nil views: views]];
    [self.editPhotoView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[editPhotoView(==%f)]", cameraLayerViewHeight] options: 0 metrics: nil views: views]];
}

#pragma mark - actions

- (void)submissionButtonTapped:(id)sender
{
    [self dismiss];
    if (self.submissionHandler)
    {
        self.submissionHandler(self.photoAttachment);
    }
}

- (void)closeButtonTapped:(id)sender
{
    [self dismiss];
}

#pragma mark - OREditPhotoDelegate

- (void)zoomScaleChanged:(CGFloat)zoomScale
{
    self.photoAttachment.scale = zoomScale;
}

- (void)offsetPointChanged:(CGPoint)offsetPoint
{
    self.photoAttachment.offsetPoint = offsetPoint;
}

#pragma mark - OREditPhotoSubmissionDelegate

- (void)resetButtonTapped
{
    [self.photoAttachment reset];
    [self.cropToolView reset];
    [self.editPhotoView reset];
}

- (void)submissionButtonTapped
{
    if (self.submissionHandler)
    {
        UIImage* image = [self.editPhotoView cropVisiblePortionOfImageView];
        self.photoAttachment.imageId = nil;
        self.photoAttachment.image = image;
        self.submissionHandler(self.photoAttachment);
    }
    [self dismiss];
}

#pragma mark - ORCropToolDelegate

- (void)gridStateChanged:(ORCameraGridState)gridState
{
    [self.cameraLayerView updateGridWithState:gridState];
}

- (void)rotateRight
{
    self.photoAttachment.rotateRightCount = self.photoAttachment.rotateRightCount + 1;
    [self.editPhotoView rotateRightWithCount:self.photoAttachment.rotateRightCount];
}

- (void)rotateWithAngle:(CGFloat)angle
{
    [self.editPhotoView rotateWithAngle:angle];
    self.photoAttachment.angle = angle;
}

#pragma mark - private methods

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNavigationBar
{
    self.title = @"Cropping";
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
}


@end
