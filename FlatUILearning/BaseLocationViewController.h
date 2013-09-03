//
//  BaseLocationViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "BaseListViewController.h"
#import <MapKit/MapKit.h>
#import "Restaurant.h"

@interface BaseLocationViewController : BaseListViewController<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locMgr;
@property (nonatomic, assign) CLLocationCoordinate2D curCoord;

- (CLLocationDistance)distanceFromRestaurant:(Restaurant *)restaurant;
@end
