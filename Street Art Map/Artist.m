//
//  Artist.m
//  Street Art Map
//
//  Created by Alex Smith on 8/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artist.h"
#import "Artwork.h"


@implementation Artist

@dynamic name;
@dynamic artworks;

/*-(BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (object && [object isMemberOfClass:[self class]]) {
        Artist *otherArtist = (Artist *)object;
        return [self.name isEqualToString:otherArtist.name];
    }
    
    return NO;
}

-(NSUInteger)hash
{
    return [self.artworks hash] ^ [self.name hash];
}*/

@end
