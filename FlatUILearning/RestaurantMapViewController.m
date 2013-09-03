//
//  RestaurantMapViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "RestaurantMapViewController.h"
#import "Restaurant.h"
#import "BasicMapAnnotation.h"
#define MinCourseMapZoomLevel 8

@interface RestaurantMapViewController()
{
    NSMutableArray *arr;
}


@end


@implementation RestaurantMapViewController



-(void)viewDidLoad
{
    
    [self.slidingViewController setAnchorLeftPeekAmount:20];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.locMgr) {
        self.locMgr = [[CLLocationManager alloc] init] ;
        [self.locMgr setDelegate:self];
        [self.locMgr setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeSatellite;
        _mapView.showsUserLocation=YES;
        
        self.mapView.mapType = MKMapTypeStandard;
        self.locMgr.desiredAccuracy=kCLLocationAccuracyBest;

    }

    [self.locMgr startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView  removeAnnotations:arr];
    [arr removeAllObjects];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [super locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    [self initMapLocationInfo:self.curCoord];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([AppUtilities isIOS6]) {
        [super locationManager:manager didUpdateLocations:locations];
        [self initMapLocationInfo:self.curCoord];
    }

}

-(void) initMapLocationInfo:(CLLocationCoordinate2D) coordinate
{
    [_mapView setCenterCoordinate:coordinate animated:NO];
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.04;
    theSpan.longitudeDelta=0.04;
    MKCoordinateRegion theRegion;
    theRegion.center=self.curCoord;
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    [self.locMgr stopUpdatingLocation];
    
    [Restaurant getNearByRestaurantOnSuccess:^(NSMutableArray *array) {
        [self updateCourseList:array];
    } failure:^(id error) {
        
    } parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:coordinate.latitude ],@"lat",[NSNumber numberWithDouble:coordinate.longitude ],@"lng", nil]];
}

- (void)updateCourseList:(NSArray *)restaurantList{
    int n = [restaurantList count];
    arr = [NSMutableArray arrayWithCapacity:n];
    for (Restaurant *res in restaurantList) {
        BasicMapAnnotation *anno =[[BasicMapAnnotation alloc ] initWithLatitude:res.latitude andLongitude:res.longitude];
        anno.title=res.address;
        [arr addObject:anno];
    }
    [self.mapView addAnnotations:arr];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        [pin setPinColor:MKPinAnnotationColorRed];
        [pin setAnimatesDrop:YES];
        pin.canShowCallout = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = btn;
        return pin;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    BasicMapAnnotation *anno = view.annotation;
    
    if([anno isKindOfClass:[BasicMapAnnotation class]]){
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0){
            NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",
                             anno.coordinate.latitude,anno.coordinate.longitude,
                             self.curCoord.latitude,self.curCoord.longitude];
            NSLog(@"%@",url);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            CLLocationCoordinate2D to;
            
            to.latitude = anno.coordinate.latitude;
            to.longitude = anno.coordinate.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            toLocation.name = @"Destination"; 
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
            
        }
    }
}
@end
