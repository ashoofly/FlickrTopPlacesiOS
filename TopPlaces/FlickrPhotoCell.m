//
//  FlickrPhotoCell.m
//  TopPlaces
//
//  Created by Angela Hsu on 8/27/15.
//  Copyright (c) 2015 Optaros. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoCell

- (void) setPhoto:(NSDictionary *)photo
{
    if (_photo != photo) _photo = photo;
    NSURL *thumbnailURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatSquare];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setHighlighted:NO];
    
    _photo = nil;
    _imageView.image = nil;
}

@end
