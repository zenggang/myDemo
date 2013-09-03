//
//  BaseLocationViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseLocationViewController.h"

@interface BaseLocationViewController ()

@end

@implementation BaseLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.locMgr = [[CLLocationManager alloc] init] ;
    [self.locMgr setDelegate:self];
    [self.locMgr setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.locMgr startUpdatingLocation]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Customer Method
- (CLLocationDistance)distanceFromRestaurant:(Restaurant *)restaurant
{
    MKMapPoint mp = MKMapPointForCoordinate(_curCoord);
    MKMapPoint mp2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(restaurant.latitude,restaurant.longitude ));
    CLLocationDistance d = MKMetersBetweenMapPoints(mp,mp2);
    return d;
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setCurCoord:newLocation.coordinate];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];

   [self setCurCoord:currentLocation.coordinate];
}
@end
