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
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
}



@end
