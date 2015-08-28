//
//  FlickrPhotosTVCTableViewController.m
//  Shutterbug
//
//  Created by Angela Hsu on 8/19/15.
//  Copyright (c) 2015 Optaros. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPlacesTVC ()

@end

@implementation FlickrPlacesTVC


- (void)setPlaces:(NSArray *)places {
    _places = places;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *topPlacesIcon = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *recentsIcon = [self.tabBarController.tabBar.items objectAtIndex:1];
    [topPlacesIcon initWithTitle:@"Top Places" image:[UIImage imageNamed:@"maps.png"] selectedImage:[UIImage imageNamed:@"maps_selected.png"]];
    [recentsIcon initWithTitle:@"Recents" image:[UIImage imageNamed:@"icon-recent.png"] selectedImage:[UIImage imageNamed:@"icon-recent.png"]];
    
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




@end
