//
//  ORPreviewPhotosView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 17/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORPreviewPhotosView.h"

@interface ORPreviewPhotosView()

@property (nonatomic) UIImageView* imageView;

@end

@implementation ORPreviewPhotosView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructImageView];
    [self setConstraints];
}

- (void)constructImageView
{
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setBackgroundColor:[UIColor lightGrayColor]];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"imageView": self.imageView};
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
}

@end
