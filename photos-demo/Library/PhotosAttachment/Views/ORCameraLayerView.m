//
//  ORCameraLayerView.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 20/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORCameraLayerView.h"

@interface ORCameraLayerView()

@property (nonatomic) UIView* imageBorderView;
@property (nonatomic) UIView* gridView;

@end


@implementation ORCameraLayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructView];
    }
    return self;
}

#pragma mark - public methods

- (void)updateGridWithState:(ORCameraGridState)gridState
{
    [self.gridView setHidden:gridState == ORCameraGridStateOff];
}

#pragma mark - construct methods

- (void)constructView
{
    [self constructImageBorder];
    [self constructGridView];
    [self setConstraints];
}

- (void)constructImageBorder
{
    self.imageBorderView = [[UIView alloc] init];
    [self.imageBorderView setBackgroundColor:[UIColor clearColor]];
    self.imageBorderView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:150/255.0f blue:35/255.0f alpha:1.0f].CGColor;
    self.imageBorderView.layer.borderWidth = 1.0f;
    [self.imageBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.imageBorderView];
}

- (void)constructGridView
{
    self.gridView = [[UIView alloc] init];
    [self.gridView setBackgroundColor:[UIColor clearColor]];
    [self.gridView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.gridView];
    
    CGFloat screenRect = [UIScreen mainScreen].bounds.size.width;
    CGFloat gridHeight = screenRect / 3.0f;
    
    UIView* horizontalView = [[UIView alloc] init];
    [horizontalView setBackgroundColor:[UIColor clearColor]];
    [horizontalView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView* verticalTopView = [[UIView alloc] init];
    [verticalTopView setBackgroundColor:[UIColor clearColor]];
    [verticalTopView setTranslatesAutoresizingMaskIntoConstraints:NO];
 
    UIView* verticalMiddleView = [[UIView alloc] init];
    [verticalMiddleView setBackgroundColor:[UIColor clearColor]];
    [verticalMiddleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView* verticalBottomView = [[UIView alloc] init];
    [verticalBottomView setBackgroundColor:[UIColor clearColor]];
    [verticalBottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.gridView addSubview:horizontalView];
    [self.gridView addSubview:verticalTopView];
    [self.gridView addSubview:verticalMiddleView];
    [self.gridView addSubview:verticalBottomView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(horizontalView, verticalTopView, verticalMiddleView, verticalBottomView);
    [self.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[horizontalView]|" options:0 metrics:nil views:views]];
    [horizontalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[horizontalView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    [self.gridView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.gridView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    [self.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[verticalTopView][verticalMiddleView][verticalBottomView]|" options:0 metrics:nil views:views]];
    [verticalTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[verticalTopView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    [verticalMiddleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[verticalMiddleView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    [verticalBottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[verticalBottomView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    
    [verticalTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[verticalTopView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    [verticalMiddleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[verticalMiddleView(==%f)]", gridHeight] options:0 metrics:nil views:views]];
    
    [self.gridView addConstraint:[NSLayoutConstraint constraintWithItem:verticalTopView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gridView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.gridView addConstraint:[NSLayoutConstraint constraintWithItem:verticalMiddleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gridView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.gridView addConstraint:[NSLayoutConstraint constraintWithItem:verticalBottomView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gridView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addVerticalGridBordersForView:horizontalView];
    [self addHorizontalGridBordersForView:verticalTopView isFullHeight:YES];
    [self addHorizontalGridBordersForView:verticalMiddleView isFullHeight:NO];
    [self addHorizontalGridBordersForView:verticalBottomView isFullHeight:YES];
}

- (void)addVerticalGridBordersForView:(UIView*)view
{
    UIView* topBorderView = [[UIView alloc] init];
    [topBorderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3f]];
    [topBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
 
    UIView* bottomBorderView = [[UIView alloc] init];
    [bottomBorderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3f]];
    [bottomBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview:topBorderView];
    [view addSubview:bottomBorderView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(topBorderView, bottomBorderView);
    [topBorderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[topBorderView(==%f)]", 1.0f] options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[topBorderView]-1-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topBorderView]" options:0 metrics:nil views:views]];
    
    [bottomBorderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[bottomBorderView(==%f)]", 1.0f] options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[bottomBorderView]-1-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBorderView]|" options:0 metrics:nil views:views]];
}

- (void)addHorizontalGridBordersForView:(UIView*)view isFullHeight:(BOOL)isFullHeight
{
    UIView* leftBorderView = [[UIView alloc] init];
    [leftBorderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3f]];
    [leftBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView* rightBorderView = [[UIView alloc] init];
    [rightBorderView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3f]];
    [rightBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview:leftBorderView];
    [view addSubview:rightBorderView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(leftBorderView, rightBorderView);
    [leftBorderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[leftBorderView(==%f)]", 1.0f] options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftBorderView]" options:0 metrics:nil views:views]];
    
    [rightBorderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[rightBorderView(==%f)]", 1.0f] options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBorderView]|" options:0 metrics:nil views:views]];

    if (isFullHeight)
    {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftBorderView]|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightBorderView]|" options:0 metrics:nil views:views]];
    }
    else
    {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[leftBorderView]-1-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[rightBorderView]-1-|" options:0 metrics:nil views:views]];
    }
}

- (void)setConstraints
{
    NSDictionary *views = @{@"imageBorderView": self.imageBorderView, @"gridView": self.gridView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imageBorderView]-20-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[imageBorderView]-%f-|", 20.0f] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[gridView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gridView]|" options:0 metrics:nil views:views]];
    
    [self.imageBorderView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:self.imageBorderView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.imageBorderView
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1.0 //Aspect ratio: height = width
                                         constant:0.0f]];
}

#pragma mark - getters, setters

- (void)setIsBorderHidden:(BOOL)isBorderHidden
{
    _isBorderHidden = isBorderHidden;
    if (isBorderHidden) {
        [self.imageBorderView removeFromSuperview];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

@end
