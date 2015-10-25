//
//  OREditPhotoView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "OREditPhotoView.h"
#import "ORPhotosUtils.h"

@interface OREditPhotoView() <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView* contentView;
@property (strong, nonatomic) UIImageView* imageView;

@property (strong, nonatomic) ORPhotoAttachment* photoAttachment;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation OREditPhotoView

- (instancetype)initWithPhotoAttachment:(ORPhotoAttachment*)photoAttachment
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.scale = photoAttachment.scale;
        self.angle = photoAttachment.angle;
        self.photoAttachment = photoAttachment;
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (UIImage *)cropVisiblePortionOfImageView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)reset
{
    self.angle = self.photoAttachment.angle;
    self.scale = self.photoAttachment.scale;
    [self initPhoto];
}

- (void)rotateRightWithCount:(NSInteger)rotateRightCount;
{
    [self applyRotation];
}

- (void)rotateWithAngle:(CGFloat)angle
{
    if (self.imageView.image)
    {
        CGFloat angleInRadians = angle * (M_PI / 180);
        self.angle = angleInRadians;
        [self applyRotation];
    }
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructScrollView];
}

- (void)constructScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    [self constructContentView];
}

- (void)constructContentView
{
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self constructImageView];
}

- (void)constructImageView
{
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"scrollView": self.scrollView, @"imageView": self.imageView, @"contentView": self.contentView};
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
 
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView(width)]" options:0 metrics:@{@"width": @(self.frame.size.width)} views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(height)]" options:0 metrics:@{@"height": @(self.frame.size.height)} views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.scale = scale;
    [self.delegate zoomScaleChanged:scale];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate offsetPointChanged:self.scrollView.contentOffset];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [self.scrollView setMinimumZoomScale:1];
    [self.scrollView setMaximumZoomScale:5.0];
    [self.scrollView setZoomScale:1];
    [self.imageView setImage:self.photoAttachment.originalImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self setConstraints];
    [super layoutSubviews];
    [self initPhoto];
}

#pragma mark - private methods

- (void)applyRotation
{
    CGFloat rightAngle = -90 * self.photoAttachment.rotateRightCount * (M_PI / 180.0);
    CGFloat angle = self.angle + rightAngle;
    CGAffineTransform transformRotate = CGAffineTransformMakeRotation(angle);
    self.imageView.transform = transformRotate;
}

- (void)initPhoto
{
    [self.scrollView setZoomScale:self.scale];
    [self.scrollView setContentOffset:self.photoAttachment.offsetPoint];
    CGFloat angleInRadians = -90 * self.photoAttachment.rotateRightCount * (M_PI / 180.0) + self.angle * (M_PI / 180.0);
    CGAffineTransform transformRotate = CGAffineTransformMakeRotation(angleInRadians);
    self.imageView.transform = transformRotate;
}

- (CGFloat)maxAngle
{
    return 45 * (M_PI / 180);
}

- (CGFloat)minScale
{
    return (1 + ABS(self.angle) / [self maxAngle]);
}

@end
