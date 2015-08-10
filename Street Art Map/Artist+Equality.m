//
//  Artist+Equality.m
//  Street Art Map
//
//  Created by Alex Smith on 9/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artist+Equality.h"

@implementation Artist (Equality)

-(BOOL)isEqualToArtist:(Artist *)artist
{
    return [self.name isEqualToString:artist.name] && [self.artworks isEqualToSet:artist.artworks];
}

@end
