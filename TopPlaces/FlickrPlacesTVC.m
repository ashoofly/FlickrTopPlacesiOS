//
//  FlickrPhotosTVCTableViewController.m
//  Shutterbug
//
//  Created by Angela Hsu on 8/19/15.
//  Copyright (c) 2015 Optaros. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
//#import "ImageViewController.h"

@interface FlickrPlacesTVC ()

@end

@implementation FlickrPlacesTVC


- (void)setPlaces:(NSArray *)places {
    _places = places;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *place = self.places[indexPath.row];
    cell.textLabel.text = [place valueForKeyPath:FLICKR_PLACE_NAME];
    NSLog(@"Adding cell '%@'", cell.textLabel.text);
    //cell.detailTextLabel.text = [place valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}


#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    id detail = self.splitViewController.viewControllers[1];
//    if ([detail isKindOfClass:[UINavigationController class]]) {
//        detail = [((UINavigationController *)detail).viewControllers firstObject];
//    }
//    if ([detail isKindOfClass:[ImageViewController class]]) {
//        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
//    }
//    
//}


#pragma mark - Navigation

//- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo {
//    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
//    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
//}

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([sender isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        if (indexPath) {
//            if ([segue.identifier isEqualToString:@"Display Photo"]) {
//                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
//                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
//                    
//                }
//            }
//        }
//        
//    }
//    
//}


@end