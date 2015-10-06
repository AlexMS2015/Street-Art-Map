//
//  Artist+Create.h
//  Street Art Map
//
//  Created by Alex Smith on 9/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artist.h"

@interface Artist (Create)

+(Artist *)artistWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
-(void)deleteFromDatabase;

@end
