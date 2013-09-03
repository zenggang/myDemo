//
//  GoldCoreData.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-29.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldCoreData.h"


@implementation GoldCoreData

@dynamic platform;
@dynamic gold;


+(void) saveGoldCoreDataToDisc:(NSString *) platform withGold:(int) goldAmount
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    GoldCoreData *gold =[GoldCoreData MR_createInContext:localContext];
    gold.platform=platform;
    gold.gold=[NSNumber numberWithInt:goldAmount];
    [localContext MR_saveToPersistentStoreAndWait]; 
}
 
- (void)updateGoldAmount:(int) goldUpdate{
    // Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    // Build the predicate to find the person sought
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"platform ==[c] %@ ",self.platform];
    GoldCoreData *goldFounded = [GoldCoreData MR_findFirstWithPredicate:predicate inContext:localContext];
    // If a person was founded
    if (goldFounded) {
        // Update its age
        goldFounded.gold=[NSNumber numberWithInt:goldUpdate ];
        // Save the modification in the local context
        // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
        [localContext MR_saveToPersistentStoreAndWait];
    }
}
@end
