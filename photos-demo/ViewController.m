//
//  ViewController.m
//  photos-demo
//
//  Created by Stanislav Prigodich on 24/10/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "ViewController.h"
#import "ORCameraAttachmentViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)attachPhotosButtonTapped:(id)sender {
    ORCameraAttachmentViewController *cameraAttachmentController = [[ORCameraAttachmentViewController alloc] init];
    cameraAttachmentController.submissionHandler = ^(NSArray * images) {
        for (int i = 0; i < self.imageViews.count; i++) {
            [self.imageViews[i] setImage:[UIImage new]];
        }
        for (int i = 0; i < images.count; i++) {
            ORPhotoAttachment* attachment = (ORPhotoAttachment*)images[i];
            [(UIImageView*)self.imageViews[i] setImage:attachment.image];
        }
    };
    [self presentViewController:[[ORNavigationController alloc] initWithRootViewController:cameraAttachmentController] animated:YES completion:nil];
}

@end
