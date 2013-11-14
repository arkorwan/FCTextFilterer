//
//  NSString+StringProcessing.m
//
//  Created by worakarn isaratham on 9/12/13.
//  Copyright (c) 2013 FaceCard. All rights reserved.
//

#import "NSString+StringProcessing.h"

@implementation NSString (StringProcessing)

- (BOOL) containsString: (NSString*) substring options:(NSStringCompareOptions) mask
{
    NSRange range = [self rangeOfString : substring options:mask];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (BOOL) containsString:(NSString *)substring
{
    return [self containsString:substring options: NSCaseInsensitiveSearch];
}

- (NSArray *) splitByWhitespace
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
