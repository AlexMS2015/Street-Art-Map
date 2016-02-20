//
//  TestDataLoader.h
//  Street Art Map
//
//  Created by Alex Smith on 20/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TestDataLoader : NSObject

+(TestDataLoader *)loadTestDataInContext:(NSManagedObjectContext *)context;

@end
