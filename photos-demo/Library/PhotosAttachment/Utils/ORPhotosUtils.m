//
//  ORPhotosUtils.m
//  PhotosAttachment
//
//  Created by Stanislav Prigodich on 21/08/15.
//  Copyright (c) 2015 Prigodich. All rights reserved.
//

#import "ORPhotosUtils.h"

@interface ORPhotosUtils()

@end

@implementation ORPhotosUtils

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

+ (void)getLastImageFromCameraRollWithCallback:(void(^)(UIImage *))callback
{
    ALAssetsLibrary *assetsLibrary = [self defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (nil != group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
            if (group.numberOfAssets > 0) {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (nil != result) {
                        UIImage* image = [UIImage imageWithCGImage:[result thumbnail]];
                        callback(image);
                        *stop = YES;
                    }
                }];
            }
        }
                                     
        *stop = NO;
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

+ (NSArray*)getImages
{
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [self defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                [tmpAssets insertObject:result atIndex:0];
            }
        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
    return tmpAssets;
}


@end
