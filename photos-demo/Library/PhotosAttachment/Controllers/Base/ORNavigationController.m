//
//  ORNavigationController.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 25/10/15.
//  Copyright © 2015 Prigodich. All rights reserved.
//

#import "ORNavigationController.h"

@interface ORNavigationController ()

@end

@implementation ORNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:39/255.0f green:41/255.0f blue:43/255.0f alpha:1.0f]];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName  : [UIColor whiteColor]};
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
