//
//  ORSmallPreviewView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORSmallPreviewView.h"
#import "ORPhotoAttachment.h"

@interface ORSmallPreviewView()

@property (nonatomic) NSMutableArray* previewImageViews;
@property (nonatomic) NSArray* previewImages;

@end

@implementation ORSmallPreviewView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countVisibleImages = 5;
        self.previewImageViews = [NSMutableArray new];
        self.previewImages = [NSArray new];
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)updateImagesToView:(NSArray*)images
{
    self.previewImages = [NSArray arrayWithArray:images];
    [self fillPreviewsWithImages];
}

- (void)selectImageWithIndex:(NSUInteger)index
{
    for (UIImageView* imageView in self.previewImageViews) {
        imageView.layer.borderWidth = 0;
    }
    UIImageView* selectedImageView = (UIImageView*)self.previewImageViews[index];
    selectedImageView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:150/255.0f blue:35/255.0f alpha:1.0f].CGColor;
    selectedImageView.layer.borderWidth = 2;
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructPreviewImageViews];
    [self setConstraints];
}

- (void)constructPreviewImageViews
{
    for (int i = 0; i < self.countVisibleImages; i++) {
        UIImageView* previewImageView = [[UIImageView alloc] init];
        previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        [previewImageView setBackgroundColor:[UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:0.06f]];
        [previewImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        previewImageView.layer.masksToBounds = YES;
        previewImageView.layer.cornerRadius = 2;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        singleTap.numberOfTapsRequired = 1;
        [previewImageView setUserInteractionEnabled:YES];
        [previewImageView addGestureRecognizer:singleTap];
        
        [self addSubview:previewImageView];
        [self.previewImageViews addObject:previewImageView];
    }
}

- (void)setConstraints
{
    for (int i = 0; i < self.countVisibleImages - 1; i++) {
        NSDictionary *views = @{@"currentView": self.previewImageViews[i], @"nextView": self.previewImageViews[i+1]};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentView]-15-[nextView]" options:0 metrics:nil views:views]];
        
        [self addConstraint:[NSLayoutConstraint
                                             constraintWithItem:self.previewImageViews[i]
                                             attribute:NSLayoutAttributeWidth
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.previewImageViews[i+1]
                                             attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                             constant:0.0f]];
    }
    NSDictionary *views = @{@"firstView": self.previewImageViews[0], @"lastView": self.previewImageViews[self.countVisibleImages - 1]};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[firstView]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-15-|" options:0 metrics:nil views:views]];
    
    for (int i = 0; i < self.countVisibleImages; i++) {
        [self.previewImageViews[i] addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.previewImageViews[i]
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.previewImageViews[i]
                                                  attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                  constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageViews[i] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
}

#pragma mark - actions

- (void)imageTapped:(UITapGestureRecognizer*)gr
{
    UIImageView* imageView = (UIImageView*)gr.view;
    NSUInteger index = [self.previewImageViews indexOfObject:imageView];
    if (index != NSNotFound)
    {
        [self.delegate imageTappedWithIndex:index];
        if (self.isPreviewMode && index == self.previewImages.count)
        {
            if ([self.delegate respondsToSelector:@selector(backToCameraScreen)])
            {
                [self.delegate backToCameraScreen];                
            }
        }
    }
}

#pragma mark - private methods

- (void)fillPreviewsWithImages
{
    for (int i = 0; i < self.countVisibleImages; i++) {
        UIImageView* previewImageView = self.previewImageViews[i];
        [previewImageView setImage:[UIImage new]];
    }
    for (int i = 0; i < self.previewImages.count; i++) {
        UIImageView* previewImageView = self.previewImageViews[i];
        [previewImageView setImage:((ORPhotoAttachment*)self.previewImages[i]).image];
    }
    if (self.isPreviewMode)
    {
        if (self.previewImages.count < self.countVisibleImages) {
            UIImageView* previewImageView = self.previewImageViews[self.previewImages.count];
            previewImageView.contentMode = UIViewContentModeCenter;
            [previewImageView setImage:[UIImage imageNamed:@"photo_attachment_camera.png"]];
        }
    }
}

@end
