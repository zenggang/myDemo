//
//  SingleMenu.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-19.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "SingleMenuCoreData.h"
#import "SingleMenu.h"

@implementation SingleMenuCoreData

@dynamic   title;
@dynamic  price;
  

+(void) saveSingleMenuToDisc:(SingleMenu *) singleMenu
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    SingleMenuCoreData *menu =[SingleMenuCoreData MR_createInContext:localContext];
    menu.title=singleMenu.title;
    menu.price=singleMenu.price;
    [localContext MR_saveToPersistentStoreAndWait];
}

- (void) deleteMenuWithTitle{
    // Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    // Build the predicate to find the person sought
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title ==[c] %@ ",self.title];
    SingleMenuCoreData *singleMenu = [SingleMenuCoreData MR_findFirstWithPredicate:predicate inContext:localContext];
    // If a person was founded
    if (singleMenu) {
        // Update its age
        [singleMenu MR_deleteInContext:localContext];
        // Save the modification in the local context
        // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
        [localContext MR_saveToPersistentStoreAndWait];
    }
}
@end
