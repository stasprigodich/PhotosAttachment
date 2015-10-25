//
//  ORChoosePhotoViewController.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 21/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORChoosePhotoViewController.h"
#import "ORPhotosUtils.h"

@interface ORChoosePhotoViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray* assets;
@property (nonatomic, strong) NSMutableArray* selectedAssets;

@property (nonatomic, strong) UICollectionView* collectionView;
@property (strong, nonatomic) UIButton* submissionButton;
@property (strong, nonatomic) UILabel* submissionLabel;

@property (nonatomic, copy) void (^callback)(NSArray* images);

@end

@implementation ORChoosePhotoViewController

- (instancetype)initWithCallback:(void(^)(NSArray*))callback
{
    self = [super init];
    if (self) {
        self.callback = callback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.assets = [[NSArray alloc] init];
    self.selectedAssets = [[NSMutableArray alloc] init];
    [self initNavigationBar];

    [self constructCollectionView];
    [self constructSubmissionButton];
    [self setConstraints];
    
    [self loadPhotos];
}

#pragma mark - construct methods

- (void)constructCollectionView
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 3;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];
}

- (void)constructSubmissionButton
{
    self.submissionButton = [[UIButton alloc] init];
    [self.submissionButton addTarget:self action:@selector(submissionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submissionButton];
    [self constructSubmissionLabel];
    [self setSubmissionButtonState:NO];
}

- (void)constructSubmissionLabel
{
    self.submissionLabel = [[UILabel alloc] init];
    self.submissionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [self.submissionButton addSubview:self.submissionLabel];
}

- (void)setConstraints
{
    NSDictionary *views = @{ @"collectionView": self.collectionView, @"submissionButton": self.submissionButton, @"submissionLabel": self.submissionLabel};
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submissionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[collectionView]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[submissionButton]|" options: 0 metrics: nil views: views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView][submissionButton]|" options: 0 metrics: nil views: views]];
    [self.submissionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[submissionButton(==49)]" options: 0 metrics: nil views: views]];

    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.submissionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.submissionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.submissionButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)rowsNumber
{
    return self.assets.count + ((3 - (self.assets.count % 3)) % 3);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self rowsNumber];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row < ([self rowsNumber] - self.assets.count))
    {
        cell.backgroundColor = [UIColor whiteColor];
        for (UIView* subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        cell.contentView.layer.borderWidth = 0;
    }
    else
    {
        cell.backgroundColor = [UIColor lightGrayColor];
        
        ALAsset *asset = self.assets[indexPath.row - ([self rowsNumber] - self.assets.count)];
        UIImage* image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height);
        [cell.contentView addSubview:imageView];
        if ([self.selectedAssets containsObject:asset])
        {
            cell.contentView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:146/255.0f blue:35/255.0f alpha:1.0f].CGColor;
            cell.contentView.layer.borderWidth = 4;
        }
        else
        {
            cell.contentView.layer.borderWidth = 0;
        }
        if (self.selectedAssets.count == self.maxCountSelectedPhotos && ![self.selectedAssets containsObject:asset])
        {
            UIView* hoverView = [[UIView alloc] initWithFrame:cell.contentView.frame];
            hoverView.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:0.5f];
            hoverView.tag = 1;
            [cell.contentView addSubview:hoverView];
        }
        else
        {
            UIView* hoverView = [cell.contentView viewWithTag:1];
            [hoverView removeFromSuperview];
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = self.view.frame.size.width / 3.0f - 2;
    return CGSizeMake(cellWidth, cellWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self rowsNumber] - self.assets.count)
    {
        ALAsset* selectedAsset = self.assets[indexPath.row - ([self rowsNumber] - self.assets.count)];
        if ([self.selectedAssets containsObject:selectedAsset])
        {
            [self.selectedAssets removeObject:selectedAsset];
            if (self.selectedAssets.count == 0)
            {
                [self setSubmissionButtonState:NO];
            }
        }
        else
        {
            if (self.selectedAssets.count < self.maxCountSelectedPhotos)
            {
                [self setSubmissionButtonState:YES];
                [self.selectedAssets addObject:selectedAsset];
            }
        }
        [collectionView reloadData];
    }
}

#pragma mark - actions

- (void)closeButtonTapped:(id)sender
{
    [self dismiss];
}

- (void)submissionButtonTapped:(id)sender
{
    NSMutableArray* images = [NSMutableArray new];
    for (ALAsset* asset in self.selectedAssets) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        UIImage *img = [UIImage
                        imageWithCGImage:[rep fullScreenImage]
                        scale:[rep scale]
                        orientation:UIImageOrientationUp];
        ORPhotoAttachment *photoAttachment = [ORPhotoAttachment new];
        photoAttachment.image = img;
        [images addObject:photoAttachment];
    }
    self.callback(images);
    [self dismiss];
}

#pragma mark - private methods

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNavigationBar
{
    self.title = @"Camera Roll";
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
}

- (void)loadPhotos {
    __block NSArray *tmpAssets = [ORPhotosUtils getImages];
    self.assets = tmpAssets;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void) {
        if (self.assets != nil && self.assets.count > 0)
        {
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
        else
        {
            self.assets = [[NSArray alloc] init];
        }
    });
}

- (void)setSubmissionButtonState:(BOOL)isEnabled
{
    if (isEnabled)
    {
        [self.submissionButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:150/255.0f blue:35/255.0f alpha:1.0f]];
        [self.submissionButton setEnabled:YES];
        self.submissionLabel.text = @"SELECT";
        [self.submissionLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [self.submissionButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]];
        [self.submissionButton setEnabled:NO];
        self.submissionLabel.text = @"Select photos";
        [self.submissionLabel setTextColor:[UIColor blackColor]];
    }
}

@end
