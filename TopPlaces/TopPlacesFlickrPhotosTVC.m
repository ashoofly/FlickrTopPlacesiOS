//
//  TopPlacesFlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Angela Hsu on 8/26/15.
//  Copyright (c) 2015 Optaros. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "FlickrThumbnailsCVC.h"

@interface TopPlacesFlickrPhotosTVC ()

@property (strong, nonatomic) NSDictionary *placesByCountry;
@property (strong, nonatomic) NSArray *sortedCountries;

@end

@implementation TopPlacesFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchPlaces)
                  forControlEvents:UIControlEventValueChanged];
    [self fetchPlaces];
}

- (void)reloadData {

    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (IBAction) fetchPlaces
{
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL: url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
       // NSLog(@"Flickr results = %@", propertyListResults);
        NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.places = places;
            //NSLog(@"self.places: %@", self.places);
            [self populateCountryCategories];
        });
    });
}

- (void)populateCountryCategories
{
    NSMutableDictionary *countries = [NSMutableDictionary dictionary];

    for (NSDictionary *place in self.places)
    {
        NSString *content = [place valueForKeyPath:FLICKR_PLACE_NAME];  //e.g., "_content" = "Kennedy, British Columbia, Canada";
        NSArray *places = [content componentsSeparatedByString:@", "];
        NSString *country = [places lastObject];
        NSArray *loc_detail_array = [places subarrayWithRange:NSMakeRange(0, places.count-1)];
        NSString *loc_detail = [loc_detail_array componentsJoinedByString:@", "];
        NSString *place_id = [place valueForKeyPath:FLICKR_PLACE_ID]; //e.g., "place_id" = "A7DKfKpUVLwZamwh_Q";
        NSString *value;
        if ((value = [countries objectForKey:country])) {
            NSMutableArray *temp = [value mutableCopy];
            temp = [self insertPlace:@{loc_detail: place_id} intoSortedArray:temp];
            [countries setObject:temp forKey:country];

        } else {
            [countries setObject:@[@{loc_detail: place_id}] forKey:country];
        }
    }
    /*e.g., countries = {Belize =     ({"Caye Caulker Airport" = "tL2fyO5UVLzpXrbI.g";},
                                       {"Placencia Airport" = "IAS1Ca9UVLy_JlsCWg";});
                         Canada =     ({"Brookport, Quebec" = "yPf9R4ZUVLy7S.lRzQ";},
                                       {"Cressy, Ontario" = 31AnQrdUVLxanHq8gQ;},
                                       {"Delhaven, Nova Scotia" = ".9mtosBUVLxkT1nR8w";};
                         ...
                        }
     */
    
    self.placesByCountry = countries.copy;
    self.sortedCountries = [[self.placesByCountry allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self reloadData];
}

- (NSMutableArray *)insertPlace:(NSDictionary *)place intoSortedArray:(NSMutableArray *)array {
    NSUInteger newIndex = [array indexOfObject:place inSortedRange:NSMakeRange(0, [array count]) options:NSBinarySearchingInsertionIndex usingComparator:^(id obj1, id obj2) {
        NSDictionary *dic1 = (NSDictionary *)obj1;
        NSDictionary *dic2 = (NSDictionary *)obj2;
        return [[dic1.allKeys firstObject] compare:[dic2.allKeys firstObject]];
    }];
    [array insertObject:place atIndex:newIndex];
    return array;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedCountries count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sortedCountries objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *country = [self.sortedCountries objectAtIndex:section];
    return [[self.placesByCountry objectForKey:country] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *country = [self.sortedCountries objectAtIndex:indexPath.section];
    NSArray *local_places = [self.placesByCountry objectForKey:country];
    NSString *place = [[[local_places objectAtIndex:indexPath.row] allKeys] firstObject];

    NSArray *broken_down = [place componentsSeparatedByString:@", "];
    cell.textLabel.text = [broken_down firstObject];
    if (!([broken_down firstObject]==[broken_down lastObject])) {
        cell.detailTextLabel.text = [broken_down lastObject];
    }
    else {
        cell.detailTextLabel.text = @" ";
    }
    return cell;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"thumbnails"]) {
                if ([segue.destinationViewController isKindOfClass:[FlickrThumbnailsCVC class]]) {
                    //[self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
                    FlickrThumbnailsCVC *destVC = (FlickrThumbnailsCVC *)segue.destinationViewController;
                    destVC.title = [self setDestVCTitle:cell];
                    destVC.placeID = [self setPlaceID:indexPath];
                    
                }
            }
        }
        
    }
    
    
}

- (NSString *)setDestVCTitle:(UITableViewCell *)cell
{
    if (![cell.detailTextLabel.text isEqual:@" "])
        return [NSString stringWithFormat:@"%@, %@", cell.textLabel.text, cell.detailTextLabel.text];
    else
        return cell.textLabel.text;
}

- (NSString *)setPlaceID:(NSIndexPath *)indexPath
{
    NSString *country = [self.sortedCountries objectAtIndex:indexPath.section];
    NSArray *local_places = [self.placesByCountry objectForKey:country];
    NSDictionary *place = [local_places objectAtIndex:indexPath.row];
    NSString *place_id = [place objectForKey:[[place allKeys] firstObject]];
    return place_id;
}


@end
