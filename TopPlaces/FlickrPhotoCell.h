//
//  FlickrPhotoCell.h
//  TopPlaces
//
//  Created by Angela Hsu on 8/27/15.
//  Copyright (c) 2015 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSDictionary *photo;

@end
