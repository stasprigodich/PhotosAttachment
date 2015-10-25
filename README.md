# PhotosAttachment
Library has ability to take photos via camera, from camera roll, crop and zoom


## Camera

![Alt][screenshot1_thumb]

## Editing
Preview photos, delete and crop

![Alt][screenshot2_thumb]

## Crop and zoom
![Alt][screenshot3_thumb]

[screenshot1_thumb]: http://s13.postimg.org/4rrlxbcnr/IMG_1794.jpg
[screenshot2_thumb]: http://s13.postimg.org/upv83ci53/IMG_1795.jpg
[screenshot3_thumb]: http://s13.postimg.org/43ireddxz/IMG_1796.jpg

## How to use
Add folder PhotosAttachment from sample project to your project.

```obj-c
ORCameraAttachmentViewController *cameraAttachmentController = [[ORCameraAttachmentViewController alloc] init];
cameraAttachmentController.submissionHandler = ^(NSArray * images) {
    //'images' is array of ORPhotoAttachment objects. get image from image property
};
[self presentViewController:[[ORNavigationController alloc] initWithRootViewController:cameraAttachmentController] animated:YES completion:nil];
```
