//
//  RestaurantMapViewController.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-24.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseLocationViewController.h"

@interface RestaurantMapViewController : BaseLocationViewController<MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end
