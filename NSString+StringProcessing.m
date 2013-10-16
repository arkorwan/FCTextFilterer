//
//  NSString+StringProcessing.m
//
//  Created by worakarn isaratham on 9/12/13.
//  Copyright (c) 2013 FaceCard. All rights reserved.
//

#import "NSString+StringProcessing.h"

@implementation NSString (StringProcessing)

- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (BOOL) containsStringInsensitive:(NSString *)substring
{
    return [[self lowercaseString] containsString:[substring lowercaseString]];
}

- (NSArray *) splitByWhitespace
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
