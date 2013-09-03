//
//  GoldCoreData.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-29.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GoldCoreData : NSManagedObject

@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSNumber * gold;

@end
