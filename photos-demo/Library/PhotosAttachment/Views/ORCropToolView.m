//
//  ORCropToolView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 10/09/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCropToolView.h"
#import <QuartzCore/QuartzCore.h>

@interface ORCropToolView() <UIScrollViewDelegate>

@property (strong, nonatomic) UIButton* rotateRightAngleButton;
@property (strong, nonatomic) UIButton* gridButton;
@property (nonatomic, assign) ORCameraGridState gridState;
@property (strong, nonatomic) UIView* sliderView;
@property (strong, nonatomic) UIScrollView* sliderScrollView;
@property (strong, nonatomic) UIView* sliderCenterSeparator;

@end

@implementation ORCropToolView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)reset
{
    self.angle = 0;
    [self initScrollView];
}

#pragma mark - construct methods

- (void)constructView
{
    [self setBackgroundColor:[UIColor colorWithRed:40/255.0f green:42/255.0f blue:43/255.0f alpha:0.92f]];
    [self constructRotateRightAngleButton];
    [self constructGridButton];
    [self constructSliderView];
    [self setConstraints];
}

- (void)constructRotateRightAngleButton
{
    self.rotateRightAngleButton = [[UIButton alloc] init];
    [self.rotateRightAngleButton addTarget:self action:@selector(rotateRightAngleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image = [UIImage imageNamed:@"photo_attachment_rotate.png"];
    [self.rotateRightAngleButton setImage:image forState:UIControlStateNormal];
    [self addSubview:self.rotateRightAngleButton];
}

- (void)constructGridButton
{
    self.gridButton = [[UIButton alloc] init];
    [self.gridButton addTarget:self action:@selector(gridButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.gridButton];
    self.gridState = ORCameraGridStateOn;
}

- (void)constructSliderView
{
    self.sliderView = [[UIView alloc] init];
    [self.sliderView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.sliderView];
    [self constructSliderScrollView];
    [self constructSliderCenterSeparator];
}

- (void)constructSliderScrollView
{
    self.sliderScrollView = [[UIScrollView alloc] init];
    [self.sliderScrollView setBackgroundColor:[UIColor clearColor]];

    CGSize contentSize = CGSizeMake(1000, 60);
    [self.sliderScrollView setContentSize:contentSize];
  
    self.sliderScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.sliderScrollView.showsHorizontalScrollIndicator = NO;
    
    self.sliderScrollView.delegate = self;

    [self.sliderView addSubview:self.sliderScrollView];
    [self constructSliderSeparators];
}

- (void)constructSliderCenterSeparator
{
    self.sliderCenterSeparator = [[UIView alloc] init];
    [self.sliderCenterSeparator setBackgroundColor:[UIColor orangeColor]];
    [self.sliderView addSubview:self.sliderCenterSeparator];
}

- (void)constructSliderSeparators
{
    CGSize contentSize = self.sliderScrollView.contentSize;
    float perWidth = contentSize.width / 20.0f;
    for (int i = 0; i < 19; i++) {
        UIView* separatorView = [[UIView alloc] init];
        [separatorView setBackgroundColor:[UIColor lightGrayColor]];
        if (i % 2 == 0)
        {
            [separatorView setFrame:CGRectMake((i+1)*perWidth, 15, 1, 30)];
        }
        else
        {
            [separatorView setFrame:CGRectMake((i+1)*perWidth, 10, 1, 40)];
        }

        [self.sliderScrollView addSubview:separatorView];
    }
    UIView* horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30.0f, contentSize.width, 1.0)];
    [horizontalLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.sliderScrollView addSubview:horizontalLine];
}

- (void)setConstraints
{
    NSDictionary *views = @{@"rotateRightAngleButton": self.rotateRightAngleButton, @"gridButton": self.gridButton, @"sliderView": self.sliderView, @"sliderScrollView": self.sliderScrollView, @"sliderCenterSeparator": self.sliderCenterSeparator};
    [self.rotateRightAngleButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.gridButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sliderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sliderScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sliderCenterSeparator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.rotateRightAngleButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rotateRightAngleButton(==30)]" options:0 metrics:nil views:views]];
    [self.rotateRightAngleButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rotateRightAngleButton(==30)]" options:0 metrics:nil views:views]];
    
    [self.gridButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gridButton(==26)]" options:0 metrics:nil views:views]];
    [self.gridButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[gridButton(==26)]" options:0 metrics:nil views:views]];

    [self.sliderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sliderView(==60)]" options:0 metrics:nil views:views]];
    [self.sliderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sliderScrollView]|" options:0 metrics:nil views:views]];
    [self.sliderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sliderScrollView]|" options:0 metrics:nil views:views]];
  
    [self.sliderCenterSeparator addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sliderCenterSeparator(==1)]" options:0 metrics:nil views:views]];
    [self.sliderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[sliderCenterSeparator]-8-|" options:0 metrics:nil views:views]];
    [self.sliderView addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderCenterSeparator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.sliderView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[rotateRightAngleButton]-20-[sliderView]-20-[gridButton]-18-|" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rotateRightAngleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.gridButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initScrollView];

    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.sliderView.bounds;
    l.startPoint = CGPointMake(0.0f, 0.5f);
    l.endPoint = CGPointMake(1.0f, 0.5f);
    
    id startColor = (id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0] CGColor];
    id endColor = (id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] CGColor];
    l.colors = [NSArray arrayWithObjects:startColor, endColor, startColor, nil];
    l.locations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f]];

    self.sliderView.layer.mask = l;
}

#pragma mark - actions

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

- (void)rotateRightAngleButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rotateRight)])
    {
        [self.delegate rotateRight];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.x;
    CGFloat middleOffset = (scrollView.contentSize.width / 2.0) - (self.sliderView.frame.size.width / 2.0);
    CGFloat diff = (currentOffset - middleOffset);
    CGFloat percentageDiff = diff / middleOffset;
    CGFloat angle = percentageDiff * 45;
    self.angle = angle;
    [self.delegate rotateWithAngle:angle];
    NSLog(@"%f", angle);
}

#pragma mark - getters, setters

- (void)setGridState:(ORCameraGridState)gridState
{
    _gridState = gridState;
    UIImage* gridButtonImage = gridState == ORCameraGridStateOff ? [UIImage imageNamed:@"photo_attachment_grid_off.png"] : [UIImage imageNamed:@"photo_attachment_grid_on.png"];
    [self.gridButton setImage:gridButtonImage forState:UIControlStateNormal];
}

#pragma mark - private methods

- (void)initScrollView
{
    CGSize contentSize = CGSizeMake(1000, 60);
    CGFloat middleOffsetX = (contentSize.width / 2.0) - (self.sliderView.frame.size.width / 2.0);
    CGFloat offsetX = [self getOffsetXByAngle:self.angle middleOffsetX:middleOffsetX];
    self.sliderScrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (CGFloat)getOffsetXByAngle:(CGFloat)angle middleOffsetX:(CGFloat)middleOffsetX
{
    CGFloat proport = angle / 45.0;
    CGFloat diffX = middleOffsetX * proport;
    CGFloat offsetX = middleOffsetX + diffX;
    return offsetX;
}

@end
